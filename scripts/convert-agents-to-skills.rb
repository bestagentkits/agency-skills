#!/usr/bin/env ruby
# frozen_string_literal: true

require "fileutils"
require "json"
require "open3"
require "yaml"

SOURCE_DIR = File.expand_path(ARGV[0] || "/tmp/agency-agents-source")
TARGET_DIR = File.expand_path(ARGV[1] || Dir.pwd)
SOURCE_REPO = "https://github.com/msitarzewski/agency-agents"

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

  body = content[match[0].length..] || ""
  {
    path: path,
    relative_path: path.delete_prefix("#{SOURCE_DIR}/"),
    metadata: metadata,
    body: body
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

agents.each do |agent|
  base_slug = slugify(File.basename(agent[:relative_path], ".md"))
  slug = base_slug
  if used_slugs.key?(slug)
    prefix = slugify(File.dirname(agent[:relative_path]))
    slug = "#{prefix}-#{base_slug}"
  end
  used_slugs[slug] = true

  skill_dir = File.join(TARGET_DIR, slug)
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
    "division" => agent[:relative_path].split("/").first
  }
end

FileUtils.mkdir_p(File.join(TARGET_DIR, "data"))
File.write(File.join(TARGET_DIR, "data", "skills-manifest.json"), JSON.pretty_generate(manifest))

readme_index = manifest.group_by { |item| item["division"] }.sort.map do |division, items|
  label = DOMAIN_LABELS[division] || division
  rows = items.sort_by { |item| item["display_name"].to_s }.map do |item|
    "- [`$#{item["skill"]}`](#{item["skill"]}/SKILL.md) - #{item["display_name"]}"
  end
  ["### #{label}", "", rows.join("\n")].join("\n")
end.join("\n\n")

File.write(File.join(TARGET_DIR, "README.md"), <<~MD)
  <p align="center">
    <img src="assets/agency-skills-banner.png" alt="Agency Skills banner" width="100%">
  </p>

  # Agency Skills

  Codex skills converted from [msitarzewski/agency-agents](#{SOURCE_REPO}) at commit `#{SOURCE_HEAD}`.

  This repository packages the Agency Agents roster as Codex-compatible skills. Each source agent becomes a standalone skill folder with:

  - `SKILL.md` containing Codex skill frontmatter and the original specialist instructions
  - `agents/openai.yaml` containing UI metadata for skill lists and default prompts

  ## Install

  Clone this repository into a Codex skills directory or copy selected skill folders into your existing skills path.

  ```bash
  git clone https://github.com/bestagentkits/agency-skills.git
  ```

  To use a skill, invoke it by name in Codex, for example:

  ```text
  Use $engineering-backend-architect to review this API design.
  ```

  ## Source Conversion

  The conversion is reproducible:

  ```bash
  git clone #{SOURCE_REPO} /tmp/agency-agents-source
  ruby scripts/convert-agents-to-skills.rb /tmp/agency-agents-source .
  ```

  The converter selects Markdown files with source frontmatter containing both `name` and `description` from canonical source divisions in `divisions.json`. Documentation, examples, `integrations/` generated outputs, and strategy files are not converted.

  ## Skill Index

  #{readme_index}

  ## License

  Source agents are from `msitarzewski/agency-agents`, licensed under MIT. See [LICENSE](LICENSE).

  Converted agent content retains upstream attribution. Packaging scripts and the generated banner in this repository are provided under the same MIT license unless otherwise noted.
MD

license_path = File.join(SOURCE_DIR, "LICENSE")
FileUtils.cp(license_path, File.join(TARGET_DIR, "LICENSE")) if File.exist?(license_path)

puts "Converted #{manifest.length} agents into skills."
