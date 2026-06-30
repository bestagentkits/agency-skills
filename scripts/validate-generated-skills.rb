#!/usr/bin/env ruby
# frozen_string_literal: true

require "json"
require "open3"
require "yaml"

ROOT = File.expand_path(ARGV[0] || Dir.pwd)
AGENCY_SOURCE = File.expand_path(ARGV[1] || "/tmp/agency-agents-source")
MARKETING_SOURCE = File.expand_path(ARGV[2] || "/tmp/marketingskills-source")
EXPECTED_AGENCY_COUNT = 232
EXPECTED_MARKETING_COUNT = 45

def fail_with(message)
  warn "Validation failed: #{message}"
  exit 1
end

def parse_frontmatter(path)
  content = File.read(path)
  match = content.match(/\A---\n(.*?)\n---\n/m)
  fail_with("#{path} is missing YAML frontmatter") unless match
  metadata = YAML.safe_load(match[1], permitted_classes: [], aliases: false)
  fail_with("#{path} frontmatter is not a map") unless metadata.is_a?(Hash)
  [metadata, content[match[0].length..] || ""]
end

def git_head(path)
  output, status = Open3.capture2e("git", "-C", path, "rev-parse", "HEAD")
  fail_with("cannot resolve source HEAD for #{path}: #{output.strip}") unless status.success?
  output.strip
end

def relative_file_list(path)
  Dir.glob(File.join(path, "**", "*"))
     .select { |file| File.file?(file) }
     .map { |file| file.delete_prefix("#{path}/") }
     .sort
end

def validate_openai_yaml(openai_path, skill)
  openai = YAML.safe_load(File.read(openai_path), permitted_classes: [], aliases: false)
  fail_with("#{openai_path} missing interface") unless openai.is_a?(Hash) && openai["interface"].is_a?(Hash)
  %w[display_name short_description default_prompt].each do |key|
    fail_with("#{openai_path} missing interface.#{key}") if openai["interface"][key].to_s.strip.empty?
  end
  fail_with("#{openai_path} default_prompt missing skill reference") unless openai["interface"]["default_prompt"].include?("$#{skill}")
end

manifest_path = File.join(ROOT, "data", "skills-manifest.json")
fail_with("missing #{manifest_path}") unless File.exist?(manifest_path)
manifest = JSON.parse(File.read(manifest_path))
agency_entries = manifest.select { |entry| entry["collection"] == "agency" || !entry.key?("collection") }
marketing_entries = manifest.select { |entry| entry["collection"] == "marketing-skills" }

fail_with("expected #{EXPECTED_AGENCY_COUNT} agency entries, got #{agency_entries.length}") unless agency_entries.length == EXPECTED_AGENCY_COUNT
fail_with("expected #{EXPECTED_MARKETING_COUNT} marketing entries, got #{marketing_entries.length}") unless marketing_entries.length == EXPECTED_MARKETING_COUNT
fail_with("unexpected manifest collection") unless manifest.length == agency_entries.length + marketing_entries.length

manifest_skills = manifest.map { |entry| entry.fetch("skill") }.sort
root_skills = Dir.glob(File.join(ROOT, "*", "SKILL.md")).map { |path| File.basename(File.dirname(path)) }.sort
fail_with("root skill folders do not match manifest") unless root_skills == manifest_skills

seen = {}
manifest.each do |entry|
  skill = entry.fetch("skill")
  fail_with("duplicate skill #{skill}") if seen[skill]
  seen[skill] = true
  skill_dir = File.join(ROOT, skill)
  skill_path = File.join(skill_dir, "SKILL.md")
  openai_path = File.join(skill_dir, "agents", "openai.yaml")
  fail_with("missing #{skill_path}") unless File.exist?(skill_path)
  fail_with("missing #{openai_path}") unless File.exist?(openai_path)

  skill_metadata, skill_body = parse_frontmatter(skill_path)
  fail_with("#{skill_path} name mismatch") unless skill_metadata["name"] == skill
  fail_with("#{skill_path} invalid skill name") unless skill.match?(/\A[a-z0-9]+(?:-[a-z0-9]+)*\z/)
  fail_with("#{skill_path} empty description") if skill_metadata["description"].to_s.strip.empty?
  validate_openai_yaml(openai_path, skill)

  case entry.fetch("collection", "agency")
  when "agency"
    source_path = File.join(AGENCY_SOURCE, entry.fetch("source_path"))
    fail_with("missing source #{source_path}") unless File.exist?(source_path)
    fail_with("#{skill_path} frontmatter keys drifted: #{skill_metadata.keys}") unless skill_metadata.keys.sort == %w[description name]
    _source_metadata, source_body = parse_frontmatter(source_path)
    fail_with("#{skill_path} body does not match source body") unless skill_body.strip == source_body.strip
  when "marketing-skills"
    source_path = File.join(MARKETING_SOURCE, entry.fetch("source_path"))
    source_dir = File.dirname(source_path)
    fail_with("missing source #{source_path}") unless File.exist?(source_path)
    source_metadata, = parse_frontmatter(source_path)
    fail_with("#{skill_path} imported description mismatch") unless skill_metadata["description"] == source_metadata["description"]
    missing = relative_file_list(source_dir) - relative_file_list(skill_dir)
    fail_with("#{skill_dir} missing imported files: #{missing.join(", ")}") unless missing.empty?
  else
    fail_with("unknown collection for #{skill}")
  end
end

tools_dir = File.join(ROOT, "tools")
source_tools_dir = File.join(MARKETING_SOURCE, "tools")
fail_with("missing tools directory") unless Dir.exist?(tools_dir)
fail_with("tools files do not match source") unless relative_file_list(tools_dir) == relative_file_list(source_tools_dir)
fail_with("expected 64 marketing CLI tools") unless Dir.glob(File.join(tools_dir, "clis", "*.js")).length == 64
fail_with("expected 93 marketing integration guides") unless Dir.glob(File.join(tools_dir, "integrations", "*.md")).length == 93
executable_clis = Dir.glob(File.join(tools_dir, "clis", "*.js")).select { |path| File.executable?(path) }
fail_with("imported CLI tools must stay non-executable assets") unless executable_clis.empty?
Dir.glob(File.join(tools_dir, "clis", "*.js")).sort.each do |path|
  output, status = Open3.capture2e("node", "--check", path)
  fail_with("#{path} does not parse: #{output.strip}") unless status.success?
end

readme_path = File.join(ROOT, "README.md")
banner_path = File.join(ROOT, "assets", "agency-skills-banner.png")
license_path = File.join(ROOT, "LICENSE")
marketplace_path = File.join(ROOT, ".claude-plugin", "marketplace.json")
fail_with("missing README") unless File.exist?(readme_path)
fail_with("missing banner") unless File.exist?(banner_path)
fail_with("missing LICENSE") unless File.exist?(license_path)
fail_with("missing marketplace") unless File.exist?(marketplace_path)

readme = File.read(readme_path)
fail_with("README contains forbidden upstream repo mention") if readme.match?(/msitarzewski|agency-agents/)
fail_with("README does not reference banner") unless readme.include?("assets/agency-skills-banner.png")
fail_with("README missing agency source commit") unless readme.include?(git_head(AGENCY_SOURCE))
fail_with("README missing marketing source commit") unless readme.include?(git_head(MARKETING_SOURCE))
readme_links = readme.scan(/- \[`\$([^`]+)`\]\(([^)]+)\) - (.+)$/)
fail_with("README expected #{manifest.length} skill links, got #{readme_links.length}") unless readme_links.length == manifest.length
readme_skills = readme_links.map { |skill, path, _name| [skill, path] }.sort
expected_links = manifest.map { |entry| [entry.fetch("skill"), "#{entry.fetch("skill")}/SKILL.md"] }.sort
fail_with("README skill links do not match manifest") unless readme_skills == expected_links

marketplace = JSON.parse(File.read(marketplace_path))
plugin = marketplace.fetch("plugins").find { |entry| entry["name"] == "agency-skills" }
fail_with("marketplace missing agency-skills plugin") unless plugin
fail_with("marketplace agency-skills plugin must use strict:false") unless plugin["strict"] == false
fail_with("marketplace version must be 0.2.0") unless plugin["version"] == "0.2.0"
fail_with("marketplace source repo mismatch") unless plugin.dig("source", "repo") == "bestagentkits/agency-skills"
marketplace_skills = plugin.fetch("skills").sort
expected_skills = manifest.map { |entry| "./#{entry.fetch("skill")}" }.sort
fail_with("marketplace skills do not match manifest") unless marketplace_skills == expected_skills

puts "Validated #{manifest.length} generated and imported skills."
