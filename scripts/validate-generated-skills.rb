#!/usr/bin/env ruby
# frozen_string_literal: true

require "json"
require "open3"
require "yaml"

ROOT = File.expand_path(ARGV[0] || Dir.pwd)
SOURCE_DIR = File.expand_path(ARGV[1] || "/tmp/agency-agents-source")
EXPECTED_COUNT = 232

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
  fail_with("cannot resolve source HEAD: #{output.strip}") unless status.success?
  output.strip
end

manifest_path = File.join(ROOT, "data", "skills-manifest.json")
fail_with("missing #{manifest_path}") unless File.exist?(manifest_path)

manifest = JSON.parse(File.read(manifest_path))
fail_with("expected #{EXPECTED_COUNT} manifest entries, got #{manifest.length}") unless manifest.length == EXPECTED_COUNT
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
  source_path = File.join(SOURCE_DIR, entry.fetch("source_path"))

  fail_with("missing #{skill_path}") unless File.exist?(skill_path)
  fail_with("missing #{openai_path}") unless File.exist?(openai_path)
  fail_with("missing source #{source_path}") unless File.exist?(source_path)

  skill_metadata, skill_body = parse_frontmatter(skill_path)
  fail_with("#{skill_path} frontmatter keys drifted: #{skill_metadata.keys}") unless skill_metadata.keys.sort == %w[description name]
  fail_with("#{skill_path} name mismatch") unless skill_metadata["name"] == skill
  fail_with("#{skill_path} invalid skill name") unless skill.match?(/\A[a-z0-9]+(?:-[a-z0-9]+)*\z/)
  fail_with("#{skill_path} empty description") if skill_metadata["description"].to_s.strip.empty?

  _source_metadata, source_body = parse_frontmatter(source_path)
  fail_with("#{skill_path} body does not match source body") unless skill_body.strip == source_body.strip

  openai = YAML.safe_load(File.read(openai_path), permitted_classes: [], aliases: false)
  fail_with("#{openai_path} missing interface") unless openai.is_a?(Hash) && openai["interface"].is_a?(Hash)
  %w[display_name short_description default_prompt].each do |key|
    fail_with("#{openai_path} missing interface.#{key}") if openai["interface"][key].to_s.strip.empty?
  end
  fail_with("#{openai_path} default_prompt missing skill reference") unless openai["interface"]["default_prompt"].include?("$#{skill}")
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
fail_with("README does not reference banner") unless readme.include?("assets/agency-skills-banner.png")
fail_with("README does not include source commit") unless readme.include?(git_head(SOURCE_DIR))
readme_links = readme.scan(/- \[`\$([^`]+)`\]\(([^)]+)\) - (.+)$/)
fail_with("README expected #{manifest.length} skill links, got #{readme_links.length}") unless readme_links.length == manifest.length
readme_skills = readme_links.map { |skill, path, _name| [skill, path] }.sort
expected_links = manifest.map { |entry| [entry.fetch("skill"), "#{entry.fetch("skill")}/SKILL.md"] }.sort
fail_with("README skill links do not match manifest") unless readme_skills == expected_links

marketplace = JSON.parse(File.read(marketplace_path))
plugin = marketplace.fetch("plugins").find { |entry| entry["name"] == "agency-skills" }
fail_with("marketplace missing agency-skills plugin") unless plugin
fail_with("marketplace agency-skills plugin must use strict:false") unless plugin["strict"] == false
fail_with("marketplace source repo mismatch") unless plugin.dig("source", "repo") == "bestagentkits/agency-skills"
marketplace_skills = plugin.fetch("skills").sort
expected_skills = manifest.map { |entry| "./#{entry.fetch("skill")}" }.sort
fail_with("marketplace skills do not match manifest") unless marketplace_skills == expected_skills

puts "Validated #{manifest.length} generated skills."
