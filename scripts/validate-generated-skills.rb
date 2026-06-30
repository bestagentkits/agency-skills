#!/usr/bin/env ruby
# frozen_string_literal: true

require "json"
require "yaml"
require_relative "imported-collection-support"
require_relative "readme-writer"
require_relative "skill-paths"

ROOT = File.expand_path(ARGV[0] || Dir.pwd)
AGENCY_SOURCE = File.expand_path(ARGV[1] || "/tmp/agency-agents-source")
MARKETING_SOURCE = File.expand_path(ARGV[2] || "/tmp/marketingskills-source")
EXTERNAL_SOURCE_ARGS = ARGV[3..] || []
EXPECTED_PLUGIN_VERSION = "0.3.0"
EXPECTED_COUNTS = {
  "agency" => 232,
  "marketing-skills" => 45
}.merge(EXPECTED_EXTERNAL_COUNTS).freeze

def validation_fail(message)
  fail_with("Validation failed: #{message}")
end

def validate_openai_yaml(openai_path, skill)
  openai = YAML.safe_load(File.read(openai_path), permitted_classes: [], aliases: false)
  validation_fail("#{openai_path} missing interface") unless openai.is_a?(Hash) && openai["interface"].is_a?(Hash)
  %w[display_name short_description default_prompt].each do |key|
    validation_fail("#{openai_path} missing interface.#{key}") if openai["interface"][key].to_s.strip.empty?
  end
  validation_fail("#{openai_path} default_prompt missing skill reference") unless openai["interface"]["default_prompt"].include?("$#{skill}")
end

def source_for_collection(collection)
  case collection
  when "agency" then AGENCY_SOURCE
  when "marketing-skills" then MARKETING_SOURCE
  else
    config_index = EXTERNAL_COLLECTIONS.index { |config| config.fetch(:id) == collection }
    validation_fail("unknown collection #{collection}") unless config_index
    File.expand_path(EXTERNAL_SOURCE_ARGS[config_index] || EXTERNAL_COLLECTIONS[config_index].fetch(:default_source))
  end
end

def validate_no_symlinks!(path)
  Dir.glob(File.join(path, "**", "*"), File::FNM_DOTMATCH).each do |candidate|
    next if [".", ".."].include?(File.basename(candidate))
    validation_fail("generated tree contains symlink #{candidate}") if File.lstat(candidate).symlink?
  end
end

def validate_expected_sources!
  EXPECTED_SOURCE_COMMITS.each do |collection, commit|
    source = source_for_collection(collection)
    validation_fail("#{collection} source commit drifted") unless git_head(source) == commit
  end
end

def validate_no_hidden_mirrors!(manifest)
  manifest.each do |entry|
    relative = entry.fetch("source_path")
    validation_fail("#{entry.fetch("skill")} imports hidden mirror #{relative}") if hidden_skill_path?(relative) || relative.start_with?(".")
  end
end

manifest_path = File.join(ROOT, "data", "skills-manifest.json")
validation_fail("missing #{manifest_path}") unless File.exist?(manifest_path)
validate_expected_sources!
manifest = JSON.parse(File.read(manifest_path))
entries_by_collection = manifest.group_by { |entry| entry.fetch("collection", "agency") }

validation_fail("unexpected manifest collections") unless entries_by_collection.keys.sort == EXPECTED_COUNTS.keys.sort
EXPECTED_COUNTS.each do |collection, count|
  actual = entries_by_collection.fetch(collection, []).length
  validation_fail("expected #{count} #{collection} entries, got #{actual}") unless actual == count
end
validate_no_hidden_mirrors!(manifest)

manifest_skills = manifest.map { |entry| entry.fetch("skill") }.sort
manifest_paths = manifest.map { |entry| skill_storage_path(entry) }.sort
skill_paths = Dir.glob(File.join(ROOT, SKILLS_ROOT, "*", "*", "SKILL.md"))
                 .map { |path| File.dirname(path).delete_prefix("#{ROOT}/") }
                 .sort
validation_fail("nested skill folders do not match manifest") unless skill_paths == manifest_paths
root_skill_paths = Dir.glob(File.join(ROOT, "*", "SKILL.md"))
validation_fail("root still contains skill folders: #{root_skill_paths.join(", ")}") unless root_skill_paths.empty?
seen = {}

manifest.each do |entry|
  skill = entry.fetch("skill")
  validation_fail("duplicate skill #{skill}") if seen[skill]
  seen[skill] = true
  skill_dir = File.join(ROOT, skill_storage_path(entry))
  skill_path = File.join(skill_dir, "SKILL.md")
  openai_path = File.join(skill_dir, "agents", "openai.yaml")
  validation_fail("missing #{skill_path}") unless File.exist?(skill_path)
  validation_fail("missing #{openai_path}") unless File.exist?(openai_path)
  skill_metadata, skill_content = parse_frontmatter(skill_path)
  validation_fail("#{skill_path} name mismatch") unless skill_metadata["name"] == skill
  validation_fail("#{skill_path} invalid skill name") unless skill.match?(/\A[a-z0-9]+(?:-[a-z0-9]+)*\z/)
  validation_fail("#{skill_path} empty description") if skill_metadata["description"].to_s.strip.empty?
  validation_fail("#{skill_path} is a symlink") if File.lstat(skill_path).symlink?
  validate_openai_yaml(openai_path, skill)

  source_path = File.join(source_for_collection(entry.fetch("collection", "agency")), entry.fetch("source_path"))
  validation_fail("missing source #{source_path}") unless File.exist?(source_path)
  source_metadata, source_content = parse_frontmatter(source_path)
  case entry.fetch("collection", "agency")
  when "agency"
    validation_fail("#{skill_path} frontmatter drifted") unless skill_metadata.keys.sort == %w[description name]
    source_body = source_content.sub(/\A---\n.*?\n---\n/m, "")
    skill_body = skill_content.sub(/\A---\n.*?\n---\n/m, "")
    validation_fail("#{skill_path} body does not match source body") unless skill_body.strip == source_body.strip
  else
    validation_fail("#{skill_path} imported description mismatch") unless skill_metadata["description"] == source_metadata["description"]
    missing = relative_file_list(File.dirname(source_path)) - relative_file_list(skill_dir)
    validation_fail("#{skill_dir} missing imported files: #{missing.join(", ")}") unless missing.empty?
  end
end

tools_dir = File.join(ROOT, "tools")
source_tools_dir = File.join(MARKETING_SOURCE, "tools")
validation_fail("missing tools directory") unless Dir.exist?(tools_dir)
validation_fail("tools files do not match marketing source") unless relative_file_list(tools_dir).grep_v(%r{\Aimported/}) == relative_file_list(source_tools_dir)
validation_fail("expected 64 marketing CLI tools") unless Dir.glob(File.join(tools_dir, "clis", "*.js")).length == 64
validation_fail("expected 93 marketing integration guides") unless Dir.glob(File.join(tools_dir, "integrations", "*.md")).length == 93
Dir.glob(File.join(tools_dir, "clis", "*.js")).sort.each do |path|
  output, status = Open3.capture2e("node", "--check", path)
  validation_fail("#{path} does not parse: #{output.strip}") unless status.success?
end
executable_assets = Dir.glob(File.join(tools_dir, "**", "*"), File::FNM_DOTMATCH).select { |path| File.file?(path) && File.executable?(path) }
validation_fail("imported tool assets must stay non-executable") unless executable_assets.empty?
validate_no_symlinks!(tools_dir)
entries_by_collection.each_value do |entries|
  entries.each do |entry|
    skill_dir = File.join(ROOT, entry.fetch("skill"))
    validate_no_symlinks!(skill_dir)
    next if entry.fetch("collection", "agency") == "agency"
    executable_skill_files = Dir.glob(File.join(skill_dir, "**", "*"), File::FNM_DOTMATCH).select { |path| File.file?(path) && File.executable?(path) }
    validation_fail("#{skill_dir} contains executable imported files") unless executable_skill_files.empty?
  end
end

tools_manifest_path = File.join(ROOT, "data", "imported-tools-manifest.json")
validation_fail("missing #{tools_manifest_path}") unless File.exist?(tools_manifest_path)
tools_manifest = JSON.parse(File.read(tools_manifest_path))
EXTERNAL_COLLECTIONS.each_with_index do |config, index|
  source_dir = File.expand_path(EXTERNAL_SOURCE_ARGS[index] || config.fetch(:default_source))
  source_paths = entries_by_collection.fetch(config.fetch(:id)).map { |entry| File.dirname(entry.fetch("source_path")) }.uniq
  expected_files = external_asset_files(source_dir, source_paths).map { |path| relative_path(source_dir, path) }.sort
  entry = tools_manifest.find { |item| item["collection"] == config.fetch(:id) }
  validation_fail("tools manifest missing #{config.fetch(:id)}") unless entry
  validation_fail("#{config.fetch(:id)} tools manifest drifted") unless entry.fetch("files").sort == expected_files
  target_files = relative_file_list(File.join(tools_dir, "imported", config.fetch(:id))).sort
  validation_fail("#{config.fetch(:id)} copied tools drifted") unless target_files == expected_files
end

readme = File.read(File.join(ROOT, "README.md"))
validation_fail("README contains forbidden upstream repo mention") if readme.match?(/msitarzewski|agency-agents/)
validation_fail("README does not reference banner") unless readme.include?("assets/agency-skills-banner.png")
validation_fail("README should not include source commit section") if readme.include?("Source commits:")
validation_fail("README missing total skill count") unless readme.include?("Total skills: **#{manifest.length}**.")
category_svgs = Dir.glob(File.join(ROOT, "assets", "categories", "*.svg"))
validation_fail("category banners must be raster PNG files, found SVG assets") unless category_svgs.empty?
entries_by_collection.keys.each { |collection| validation_fail("#{collection} source commit drifted") unless git_head(source_for_collection(collection)) == EXPECTED_SOURCE_COMMITS.fetch(collection) }
manifest.group_by { |entry| entry.fetch("division") }.each_key do |division|
  items = manifest.select { |entry| entry.fetch("division") == division }
  category_heading = "### #{readme_label(division)} (#{items.length})"
  banner_path = File.join(ROOT, "assets", "categories", "#{division}.png")
  section_start = readme.index(category_heading)
  validation_fail("README missing #{division} category heading") unless section_start
  section_end = readme.index("\n### ", section_start + category_heading.length) || readme.length
  section = readme[section_start...section_end]
  validation_fail("README missing #{division} category banner") unless section.include?("assets/categories/#{division}.png")
  validation_fail("README missing #{division} category table header") unless section.include?("| Skill | Name |\n| --- | --- |")
  validation_fail("missing category banner #{banner_path}") unless File.exist?(banner_path)
  identify, status = Open3.capture2e("magick", "identify", "-format", "%m %wx%h", banner_path)
  validation_fail("#{banner_path} must be PNG 5:2 1600x640, got #{identify}") unless status.success? && identify == "PNG 1600x640"
  row_count = section.scan(/^\| \[`\$[^`]+`\]\([^)]+\) \| .+ \|$/).length
  validation_fail("README #{division} category table expected #{items.length} rows, got #{row_count}") unless row_count == items.length
end
readme_links = readme.scan(/^\| \[`\$([^`]+)`\]\(([^)]+)\) \| (.+) \|$/)
validation_fail("README expected #{manifest.length} skill links, got #{readme_links.length}") unless readme_links.length == manifest.length
readme_skills = readme_links.map { |skill, path, _name| [skill, path] }.sort
expected_links = manifest.map { |entry| [entry.fetch("skill"), "#{skill_storage_path(entry)}/SKILL.md"] }.sort
validation_fail("README skill links do not match manifest") unless readme_skills == expected_links

marketplace = JSON.parse(File.read(File.join(ROOT, ".claude-plugin", "marketplace.json")))
plugin = marketplace.fetch("plugins").find { |item| item["name"] == "agency-skills" }
validation_fail("marketplace missing agency-skills plugin") unless plugin
validation_fail("marketplace agency-skills plugin must use strict:false") unless plugin["strict"] == false
validation_fail("marketplace version must be #{EXPECTED_PLUGIN_VERSION}") unless plugin["version"] == EXPECTED_PLUGIN_VERSION
validation_fail("marketplace source repo mismatch") unless plugin.dig("source", "repo") == "bestagentkits/agency-skills"
validation_fail("marketplace skills do not match manifest") unless plugin.fetch("skills").sort == manifest.map { |entry| "./#{skill_storage_path(entry)}" }.sort

puts "Validated #{manifest.length} generated and imported skills."
