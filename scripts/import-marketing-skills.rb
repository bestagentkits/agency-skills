#!/usr/bin/env ruby
# frozen_string_literal: true

require "fileutils"
require "json"
require "open3"
require "yaml"
require_relative "marketing-readme-writer"

SOURCE_DIR = File.expand_path(ARGV[0] || "/tmp/marketingskills-source")
TARGET_DIR = File.expand_path(ARGV[1] || Dir.pwd)
MANIFEST_PATH = File.join(TARGET_DIR, "data", "skills-manifest.json")

def fail_with(message)
  warn "Marketing import failed: #{message}"
  exit 1
end

def git_head(path)
  output, status = Open3.capture2e("git", "-C", path, "rev-parse", "HEAD")
  fail_with("cannot resolve marketing source HEAD: #{output.strip}") unless status.success?
  output.strip
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

def titleize(slug)
  slug.split("-").map { |part| part.upcase == part ? part : part.capitalize }.join(" ")
end

def parse_skill(path)
  content = File.read(path)
  match = content.match(/\A---\n(.*?)\n---\n/m)
  fail_with("#{path} missing YAML frontmatter") unless match
  metadata = YAML.safe_load(match[1], permitted_classes: [], aliases: false)
  fail_with("#{path} frontmatter is not a map") unless metadata.is_a?(Hash)
  fail_with("#{path} missing name or description") unless metadata["name"] && metadata["description"]
  [metadata, content]
end

def openai_yaml(metadata, skill)
  display_name = titleize(metadata.fetch("name"))
  description = metadata.fetch("description").to_s
  <<~YAML
    interface:
      display_name: #{yaml_quote(display_name)}
      short_description: #{yaml_quote(short_description(description))}
      default_prompt: #{yaml_quote("Use $#{skill} to help with #{display_name.downcase} work.")}
  YAML
end

def rewrite_moved_links(root)
  Dir.glob(File.join(root, "**", "*")).select { |path| File.file?(path) }.each do |path|
    next unless [".md", ".json", ".csv"].include?(File.extname(path))
    content = File.read(path)
    rewritten = content
                .gsub("../../../tools/", "__TOOLS_UP3__/")
                .gsub("../../tools/", "../tools/")
                .gsub("__TOOLS_UP3__/", "../../tools/")
    File.write(path, rewritten) unless rewritten == content
  end
end

def patch_text(path, pairs)
  return unless File.exist?(path)
  content = File.read(path)
  pairs.each { |from, to| content = content.gsub(from, to) }
  File.write(path, content)
end

def manifest_index(manifest)
  manifest.each_with_object({}) { |entry, index| index[entry.fetch("skill")] = entry }
end

fail_with("missing #{MANIFEST_PATH}") unless File.exist?(MANIFEST_PATH)
fail_with("missing #{File.join(SOURCE_DIR, "skills")}") unless Dir.exist?(File.join(SOURCE_DIR, "skills"))
source_head = git_head(SOURCE_DIR)
manifest = JSON.parse(File.read(MANIFEST_PATH)).reject { |entry| entry["collection"] == "marketing-skills" }
index = manifest_index(manifest)
imported = []

Dir.glob(File.join(SOURCE_DIR, "skills", "*", "SKILL.md")).sort.each do |skill_path|
  metadata, _content = parse_skill(skill_path)
  slug = metadata.fetch("name")
  fail_with("duplicate skill #{slug}") if index[slug]
  target_dir = File.join(TARGET_DIR, slug)
  FileUtils.rm_rf(target_dir)
  FileUtils.mkdir_p(target_dir)
  FileUtils.cp_r("#{File.dirname(skill_path)}/.", target_dir)
  rewrite_moved_links(target_dir)
  FileUtils.mkdir_p(File.join(target_dir, "agents"))
  File.write(File.join(target_dir, "agents", "openai.yaml"), openai_yaml(metadata, slug))
  entry = {
    "skill" => slug,
    "display_name" => titleize(slug),
    "description" => metadata.fetch("description"),
    "source_path" => "skills/#{slug}/SKILL.md",
    "division" => "marketing-skills",
    "collection" => "marketing-skills",
    "source_commit" => source_head
  }
  imported << entry
  index[slug] = entry
end

FileUtils.rm_rf(File.join(TARGET_DIR, "tools"))
FileUtils.cp_r(File.join(SOURCE_DIR, "tools"), File.join(TARGET_DIR, "tools"))
Dir.glob(File.join(TARGET_DIR, "tools", "clis", "*.js")).each { |path| FileUtils.chmod(0o644, path) }
registry_path = File.join(TARGET_DIR, "tools", "REGISTRY.md")
registry = File.read(registry_path).gsub("../skills/", "../")
File.write(registry_path, registry)

patch_text(File.join(TARGET_DIR, "tools", "clis", "README.md"), {
  "/path/to/marketingskills/tools/clis" => "/path/to/agency-skills/tools/clis",
  "Every CLI is a standalone Node.js script" => "Every CLI is imported here as a standalone Node.js script"
})
patch_text(File.join(TARGET_DIR, "tools", "integrations", "github.md"), {
  "skills/prospecting/references/saas-prospecting.md" => "../../prospecting/references/saas-prospecting.md"
})
patch_text(File.join(TARGET_DIR, "marketing-plan", "references", "idea-cross-reference.md"), {
  "skills/marketing-ideas/SKILL.md" => "../../marketing-ideas/SKILL.md",
  "skills/marketing-ideas/references/ideas-by-category.md" => "../../marketing-ideas/references/ideas-by-category.md",
  "in the `marketingskills` repo" => "in this repository"
})
patch_text(File.join(TARGET_DIR, "marketing-plan", "references", "ops-stack-mapping.md"), {
  "live in this `marketingskills` repo" => "live in this repository"
})
patch_text(File.join(TARGET_DIR, "marketing-plan", "references", "methodology.md"), {
  "exists in the `marketingskills` repo" => "exists in this repository"
})
patch_text(File.join(TARGET_DIR, "social", "references", "listening.md"), {
  "# Working inside the marketingskills repo:\ncp skills/social/references/listening-sources-template.md" => "# Working inside this repository:\ncp social/references/listening-sources-template.md"
})

manifest += imported
File.write(MANIFEST_PATH, "#{JSON.pretty_generate(manifest)}\n")
write_marketing_import_readme(TARGET_DIR, manifest, source_head)
puts "Imported #{imported.length} marketing skills and copied tools."
