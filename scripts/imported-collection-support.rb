# frozen_string_literal: true

require "date"
require "fileutils"
require "json"
require "open3"
require "yaml"
require_relative "imported-collection-config"

def fail_with(message)
  warn message
  exit 1
end

def git_head(path)
  output, status = Open3.capture2e("git", "-C", path, "rev-parse", "HEAD")
  fail_with("cannot resolve source HEAD for #{path}: #{output.strip}") unless status.success?
  output.strip
end

def parse_frontmatter(path)
  content = File.read(path)
  match = content.match(/\A---\n(.*?)\n---\n/m)
  fail_with("#{path} is missing YAML frontmatter") unless match
  metadata = safe_load_frontmatter(match[1], path)
  fail_with("#{path} frontmatter is not a map") unless metadata.is_a?(Hash)
  [metadata, content]
end

def safe_load_frontmatter(frontmatter, path)
  YAML.safe_load(frontmatter, permitted_classes: [Date, Time], aliases: false)
rescue Psych::SyntaxError
  metadata = recover_simple_frontmatter(frontmatter)
  metadata["_frontmatter_recovered"] = true
  warn "Recovered invalid YAML frontmatter in #{path}"
  metadata
end

def recover_simple_frontmatter(frontmatter)
  metadata = {}
  frontmatter.each_line do |line|
    line = line.chomp
    next unless line =~ /\A([A-Za-z0-9_-]+):\s*(.*)\z/
    key = Regexp.last_match(1)
    value = Regexp.last_match(2).strip
    value = value[1..-2] if value.start_with?('"') && value.end_with?('"')
    metadata[key] = value
  end
  fail_with("cannot recover frontmatter missing name or description") unless metadata["name"] && metadata["description"]
  metadata
end

def slugify(value)
  value.to_s.downcase.gsub(/[^a-z0-9]+/, "-").gsub(/\A-|-+\z/, "")
end

def valid_skill_slug?(slug)
  slug.to_s.match?(SKILL_SLUG_PATTERN)
end

def validate_skill_slug!(slug, context)
  fail_with("#{context} produced invalid skill slug #{slug.inspect}") unless valid_skill_slug?(slug)
end

def safe_target_path!(root, *parts)
  expanded_root = File.expand_path(root)
  path = File.expand_path(File.join(expanded_root, *parts))
  return path if path == expanded_root || path.start_with?("#{expanded_root}/")
  fail_with("refusing to write outside #{expanded_root}: #{path}")
end

def titleize(slug)
  slug.to_s.split("-").map { |part| part.upcase == part ? part : part.capitalize }.join(" ")
end

def short_description(value)
  text = value.to_s.gsub(/\s+/, " ").strip
  return text if text.length <= 64
  cut = text[0, 61].sub(/\s+\S*\z/, "")
  "#{cut.empty? ? text[0, 61] : cut}..."
end

def yaml_quote(value)
  value.to_s.inspect
end

def relative_path(source_dir, path)
  path.delete_prefix("#{source_dir}/")
end

def reject_symlinks!(path)
  root = File.expand_path(path)
  fail_with("refusing to import symlink #{root}") if File.lstat(root).symlink?
  paths = File.file?(root) ? [root] : Dir.glob(File.join(root, "**", "*"), File::FNM_DOTMATCH)
  paths.each do |candidate|
    next if [".", ".."].include?(File.basename(candidate))
    fail_with("refusing to import symlink #{candidate}") if File.lstat(candidate).symlink?
  end
end

def hidden_skill_path?(relative)
  HIDDEN_SKILL_PREFIXES.any? { |prefix| relative.start_with?(prefix) }
end

def source_skill_paths(source_dir, config)
  if config[:visible_only]
    paths = marketplace_skill_paths(source_dir)
    paths = visible_skill_paths(source_dir) if paths.empty?
    paths.group_by { |path| parse_frontmatter(path).first["name"].to_s }
         .values
         .map { |group| group.min_by { |path| [relative_path(source_dir, path).split("/").length, relative_path(source_dir, path)] } }
         .sort
  else
    Dir.glob(File.join(source_dir, config.fetch(:skill_glob)))
  end.sort
end

def visible_skill_paths(source_dir)
  Dir.glob(File.join(source_dir, "**", "SKILL.md")).select do |path|
    relative = relative_path(source_dir, path)
    !relative.start_with?(".") && !relative.include?("/.git/") && !hidden_skill_path?(relative)
  end
end

def marketplace_skill_paths(source_dir)
  marketplace_path = File.join(source_dir, ".claude-plugin", "marketplace.json")
  return [] unless File.exist?(marketplace_path)
  marketplace = JSON.parse(File.read(marketplace_path))
  marketplace.fetch("plugins", []).flat_map do |plugin|
    source = plugin["source"].to_s.sub(%r{\A\./}, "")
    next [] if source.empty? || source.start_with?(".")
    source_root = File.join(source_dir, source)
    [File.join(source_root, "SKILL.md"), *Dir.glob(File.join(source_root, "skills", "*", "SKILL.md"))]
  end.compact.select { |path| File.exist?(path) }.uniq
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

def rewrite_frontmatter_name(skill_path, skill)
  content = File.read(skill_path)
  rewritten = content.sub(/\A---\n(.*?)\n---\n/m) do |frontmatter|
    frontmatter.sub(/^name:\s*.*$/, "name: #{skill}")
  end
  File.write(skill_path, rewritten)
end

def rewrite_minimal_frontmatter(skill_path, metadata, skill)
  content = File.read(skill_path)
  body = content.sub(/\A---\n.*?\n---\n/m, "")
  minimal = {
    "name" => skill,
    "description" => metadata.fetch("description")
  }
  File.write(skill_path, "#{minimal.to_yaml}---\n#{body}")
end

def relative_file_list(path)
  Dir.glob(File.join(path, "**", "*"), File::FNM_DOTMATCH)
     .select { |file| File.file?(file) || File.symlink?(file) }
     .map { |file| file.delete_prefix("#{path}/") }
     .sort
end

def external_asset_files(source_dir, imported_skill_dirs)
  ignored = imported_skill_dirs.map { |dir| "#{dir}/" }
  Dir.glob(File.join(source_dir, "**", "*"), File::FNM_DOTMATCH).select do |path|
    next false unless File.file?(path) || File.symlink?(path)
    relative = relative_path(source_dir, path)
    next false if relative.start_with?(".git/")
    next false if hidden_skill_path?(relative)
    next false if ignored.any? { |prefix| relative.start_with?(prefix) }
    true
  end
end

def chmod_asset_files(root)
  return unless Dir.exist?(root)
  Dir.glob(File.join(root, "**", "*"), File::FNM_DOTMATCH)
     .select { |path| File.file?(path) }
     .each { |path| FileUtils.chmod(0o644, path) }
end
