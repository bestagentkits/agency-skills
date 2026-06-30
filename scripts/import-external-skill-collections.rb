#!/usr/bin/env ruby
# frozen_string_literal: true

require "json"
require_relative "imported-collection-support"
require_relative "readme-writer"

TARGET_DIR = File.expand_path(ARGV.shift || Dir.pwd)
MANIFEST_PATH = File.join(TARGET_DIR, "data", "skills-manifest.json")
TOOLS_MANIFEST_PATH = File.join(TARGET_DIR, "data", "imported-tools-manifest.json")

def import_fail(message)
  fail_with("External import failed: #{message}")
end

def namespaced_slug(config, relative, base_slug)
  parts = relative.split("/")
  parts = parts[0...-1]
  parts.delete("skills")
  prefix = slugify([config.fetch(:id), *parts].join("-"))
  "#{prefix}-#{base_slug}"
end

def unique_skill_slug(base_slug, config, relative, used)
  slug = base_slug
  slug = namespaced_slug(config, relative, base_slug) if used[slug]
  candidate = slug
  index = 2
  while used[candidate]
    candidate = "#{slug}-#{index}"
    index += 1
  end
  candidate
end

def clean_old_external_imports(target_dir, manifest)
  external_ids = EXTERNAL_COLLECTIONS.map { |config| config.fetch(:id) }
  old_entries, kept_entries = manifest.partition { |entry| external_ids.include?(entry["collection"]) }
  old_entries.each do |entry|
    skill = entry.fetch("skill")
    validate_skill_slug!(skill, "manifest entry")
    FileUtils.rm_rf(safe_target_path!(target_dir, skill))
  end
  kept_skills = kept_entries.map { |entry| entry.fetch("skill") }
  external_ids.each do |id|
    Dir.glob(File.join(target_dir, "#{id}-*")).each do |path|
      next unless File.directory?(path) && File.exist?(File.join(path, "SKILL.md"))
      next if kept_skills.include?(File.basename(path))
      FileUtils.rm_rf(path)
    end
  end
  kept_entries
end

def copy_skill(skill_path, target_dir, skill, metadata)
  skill_dir = File.dirname(skill_path)
  reject_symlinks!(skill_dir)
  validate_skill_slug!(skill, skill_path)
  target_skill_dir = safe_target_path!(target_dir, skill)
  FileUtils.rm_rf(target_skill_dir)
  FileUtils.mkdir_p(target_skill_dir)
  FileUtils.cp_r("#{skill_dir}/.", target_skill_dir)
  chmod_asset_files(target_skill_dir)
  copied_skill_path = File.join(target_skill_dir, "SKILL.md")
  if metadata.delete("_frontmatter_recovered")
    rewrite_minimal_frontmatter(copied_skill_path, metadata, skill)
  else
    rewrite_frontmatter_name(copied_skill_path, skill)
  end
  FileUtils.mkdir_p(File.join(target_skill_dir, "agents"))
  File.write(File.join(target_skill_dir, "agents", "openai.yaml"), openai_yaml(metadata, skill))
end

def copy_external_assets(source_dir, target_dir, config, imported_skill_dirs)
  asset_root = safe_target_path!(target_dir, "tools", "imported", config.fetch(:id))
  FileUtils.rm_rf(asset_root)
  files = external_asset_files(source_dir, imported_skill_dirs)
  files.each do |source_file|
    reject_symlinks!(source_file)
    relative = relative_path(source_dir, source_file)
    target_file = safe_target_path!(asset_root, relative)
    FileUtils.mkdir_p(File.dirname(target_file))
    FileUtils.cp(source_file, target_file)
  end
  chmod_asset_files(asset_root)
  files.map { |path| relative_path(source_dir, path) }.sort
end

import_fail("missing #{MANIFEST_PATH}") unless File.exist?(MANIFEST_PATH)
manifest = JSON.parse(File.read(MANIFEST_PATH))
manifest = clean_old_external_imports(TARGET_DIR, manifest)
used = manifest.each_with_object({}) { |entry, index| index[entry.fetch("skill")] = true }
source_args = ARGV.dup
imported = []
tools_manifest = []

EXTERNAL_COLLECTIONS.each_with_index do |config, index|
  source_dir = File.expand_path(source_args[index] || config.fetch(:default_source))
  import_fail("missing source #{source_dir}") unless Dir.exist?(source_dir)
  source_head = git_head(source_dir)
  skill_paths = source_skill_paths(source_dir, config)
  import_fail("#{config.fetch(:id)} has no canonical skills") if skill_paths.empty?
  imported_skill_dirs = []

  skill_paths.each do |skill_path|
    metadata, = parse_frontmatter(skill_path)
    import_fail("#{skill_path} missing name or description") unless metadata["name"] && metadata["description"]
    relative = relative_path(source_dir, skill_path)
    base_slug = slugify(metadata.fetch("name"))
    validate_skill_slug!(base_slug, skill_path)
    skill = unique_skill_slug(base_slug, config, relative, used)
    used[skill] = true
    copy_skill(skill_path, TARGET_DIR, skill, metadata)
    imported_skill_dirs << File.dirname(relative)
    imported << {
      "skill" => skill,
      "display_name" => titleize(metadata.fetch("name")),
      "description" => metadata.fetch("description"),
      "source_path" => relative,
      "source_skill" => metadata.fetch("name"),
      "division" => config.fetch(:id),
      "collection" => config.fetch(:id),
      "source_commit" => source_head
    }
  end

  tools_manifest << {
    "collection" => config.fetch(:id),
    "source_commit" => source_head,
    "files" => copy_external_assets(source_dir, TARGET_DIR, config, imported_skill_dirs.uniq)
  }
end

manifest += imported
File.write(MANIFEST_PATH, "#{JSON.pretty_generate(manifest)}\n")
File.write(TOOLS_MANIFEST_PATH, "#{JSON.pretty_generate(tools_manifest)}\n")
write_agency_skills_readme(TARGET_DIR, manifest)
puts "Imported #{imported.length} external skills and #{tools_manifest.sum { |entry| entry.fetch("files").length }} supporting files."
