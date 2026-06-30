#!/usr/bin/env ruby
# frozen_string_literal: true

require "fileutils"
require "json"
require "open3"
require "yaml"
require_relative "readme-writer"
require_relative "skill-paths"

SOURCE_DIR = File.expand_path(ARGV[0] || "/tmp/agency-agents-source")
TARGET_DIR = File.expand_path(ARGV[1] || Dir.pwd)
MANIFEST_PATH = File.join(TARGET_DIR, "data", "skills-manifest.json")

def fail_with(message)
  warn "Conversion failed: #{message}"
  exit 1
end

def git_head(path)
  output, status = Open3.capture2e("git", "-C", path, "rev-parse", "HEAD")
  fail_with("cannot resolve source HEAD: #{output.strip}") unless status.success?
  output.strip
end

def division_labels(source_dir)
  path = File.join(source_dir, "divisions.json")
  fail_with("missing #{path}") unless File.exist?(path)
  divisions = JSON.parse(File.read(path)).fetch("divisions")
  divisions.transform_values { |value| value.fetch("label") }.freeze
end

SOURCE_HEAD = git_head(SOURCE_DIR)
DOMAIN_LABELS = division_labels(SOURCE_DIR)
SOURCE_DIVISIONS = DOMAIN_LABELS.keys.freeze

def slugify(value)
  value.downcase
       .gsub(/[^a-z0-9]+/, "-")
       .gsub(/\A-|-+\z/, "")
end

def validate_skill_slug!(slug, context)
  return if slug.match?(/\A[a-z0-9]+(?:-[a-z0-9]+)*\z/)
  fail_with("#{context} produced invalid skill slug #{slug.inspect}")
end

def safe_target_path!(root, *parts)
  expanded_root = File.expand_path(root)
  path = File.expand_path(File.join(expanded_root, *parts))
  return path if path == expanded_root || path.start_with?("#{expanded_root}/")
  fail_with("refusing to write outside #{expanded_root}: #{path}")
end

def yaml_quote(value)
  value.to_s.inspect
end

def short_description(value)
  text = value.to_s.gsub(/\s+/, " ").strip
  return text if text.length <= 64
  cut = text[0, 61].sub(/\s+\S*\z/, "")
  "#{cut.empty? ? text[0, 61] : cut}..."
end

def parse_agent(path)
  content = File.read(path)
  return nil unless content.start_with?("---\n")

  match = content.match(/\A---\n(.*?)\n---\n/m)
  return nil unless match
  metadata = YAML.safe_load(match[1], permitted_classes: [], aliases: false)
  return nil unless metadata.is_a?(Hash)
  return nil unless metadata["name"] && metadata["description"]
  {
    relative_path: path.delete_prefix("#{SOURCE_DIR}/"),
    metadata: metadata,
    body: content[match[0].length..] || ""
  }
rescue Psych::SyntaxError => e
  warn "Skipping #{path}: #{e.message}"
  nil
end

def skill_description(agent)
  display_name = agent[:metadata]["name"].to_s
  description = agent[:metadata]["description"].to_s.gsub(/\s+/, " ").strip
  "Use when Codex should act as the #{display_name} specialist from Agency Agents. #{description}"
end

def openai_yaml(agent, skill_name)
  display_name = agent[:metadata]["name"].to_s
  description = agent[:metadata]["description"].to_s
  <<~YAML
    interface:
      display_name: #{yaml_quote(display_name)}
      short_description: #{yaml_quote(short_description(description))}
      default_prompt: #{yaml_quote("Use $#{skill_name} to help with #{display_name.downcase} work.")}
  YAML
end

agents = Dir.glob("#{SOURCE_DIR}/**/*.md")
            .reject { |path| path.include?("/.git/") }
            .select { |path| SOURCE_DIVISIONS.include?(path.delete_prefix("#{SOURCE_DIR}/").split("/").first) }
            .map { |path| parse_agent(path) }
            .compact
            .sort_by { |agent| agent[:relative_path] }

used_slugs = {}
manifest = []

if File.exist?(MANIFEST_PATH)
  old_manifest = JSON.parse(File.read(MANIFEST_PATH))
  old_manifest.each do |entry|
    validate_skill_slug!(entry.fetch("skill"), "manifest entry")
    FileUtils.rm_rf(safe_target_path!(TARGET_DIR, entry.fetch("skill")))
  end
  old_manifest.select { |entry| entry.fetch("collection", "agency") == "agency" }.each do |entry|
    FileUtils.rm_rf(safe_target_path!(TARGET_DIR, entry["path"] || entry.fetch("skill")))
  end
end

SOURCE_DIVISIONS.each do |division|
  FileUtils.rm_rf(safe_target_path!(TARGET_DIR, skill_path_for(division, "")))
end

agents.each do |agent|
  base_slug = slugify(File.basename(agent[:relative_path], ".md"))
  validate_skill_slug!(base_slug, agent[:relative_path])
  slug = base_slug
  if used_slugs.key?(slug)
    prefix = slugify(File.dirname(agent[:relative_path]))
    slug = "#{prefix}-#{base_slug}"
  end
  validate_skill_slug!(slug, agent[:relative_path])
  used_slugs[slug] = true
  division = agent[:relative_path].split("/").first
  skill_path = skill_path_for(division, slug)
  skill_dir = File.join(TARGET_DIR, skill_path)
  FileUtils.mkdir_p(File.join(skill_dir, "agents"))
  File.write(File.join(skill_dir, "SKILL.md"), <<~MD)
    ---
    name: #{slug}
    description: #{skill_description(agent).inspect}
    ---

    #{agent[:body].strip}
  MD
  File.write(File.join(skill_dir, "agents", "openai.yaml"), openai_yaml(agent, slug))
  manifest << {
    "skill" => slug,
    "display_name" => agent[:metadata]["name"],
    "description" => agent[:metadata]["description"],
    "source_path" => agent[:relative_path],
    "division" => division,
    "collection" => "agency",
    "source_commit" => SOURCE_HEAD,
    "path" => skill_path
  }
end

FileUtils.mkdir_p(File.join(TARGET_DIR, "data"))
File.write(MANIFEST_PATH, JSON.pretty_generate(manifest))
write_agency_skills_readme(TARGET_DIR, manifest)

license_path = File.join(SOURCE_DIR, "LICENSE")
FileUtils.cp(license_path, File.join(TARGET_DIR, "LICENSE")) if File.exist?(license_path)
puts "Converted #{manifest.length} agents into skills."
