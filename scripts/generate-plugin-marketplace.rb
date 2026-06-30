#!/usr/bin/env ruby
# frozen_string_literal: true

require "fileutils"
require "json"

ROOT = File.expand_path(ARGV[0] || Dir.pwd)
MANIFEST_PATH = File.join(ROOT, "data", "skills-manifest.json")
MARKETPLACE_DIR = File.join(ROOT, ".claude-plugin")
MARKETPLACE_PATH = File.join(MARKETPLACE_DIR, "marketplace.json")
PLUGIN_VERSION = "0.2.0"

def fail_with(message)
  warn "Marketplace generation failed: #{message}"
  exit 1
end

fail_with("missing #{MANIFEST_PATH}") unless File.exist?(MANIFEST_PATH)

manifest = JSON.parse(File.read(MANIFEST_PATH))
skills = manifest.map do |entry|
  skill = entry.fetch("skill")
  skill_path = File.join(ROOT, skill, "SKILL.md")
  fail_with("missing #{skill_path}") unless File.exist?(skill_path)
  "./#{skill}"
end.sort

marketplace = {
  "$schema" => "https://anthropic.com/claude-code/marketplace.schema.json",
  "name" => "agency-skills",
  "description" => "Agency and marketing specialist skills for Claude Code.",
  "owner" => {
    "name" => "bestagentkits"
  },
  "plugins" => [
    {
      "name" => "agency-skills",
      "description" => "Install the full Agency Skills roster: #{skills.length} specialist skills.",
      "version" => PLUGIN_VERSION,
      "author" => {
        "name" => "bestagentkits"
      },
      "homepage" => "https://github.com/bestagentkits/agency-skills",
      "repository" => "https://github.com/bestagentkits/agency-skills",
      "license" => "MIT",
      "category" => "productivity",
      "keywords" => ["skills", "agents", "agency", "marketing", "specialists"],
      "source" => {
        "source" => "github",
        "repo" => "bestagentkits/agency-skills",
        "ref" => "main"
      },
      "strict" => false,
      "skills" => skills
    }
  ]
}

FileUtils.mkdir_p(MARKETPLACE_DIR)
File.write(MARKETPLACE_PATH, "#{JSON.pretty_generate(marketplace)}\n")
puts "Generated marketplace with #{skills.length} skills."
