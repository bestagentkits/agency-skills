# frozen_string_literal: true

SKILL_SLUG_PATTERN = /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/.freeze

EXTERNAL_COLLECTIONS = [
  {
    id: "scientific-agent-skills",
    label: "Scientific Agent Skills",
    default_source: "/tmp/scientific-agent-skills-source",
    skill_glob: "skills/*/SKILL.md"
  },
  {
    id: "baoyu-skills",
    label: "Baoyu Skills",
    default_source: "/tmp/baoyu-skills-source",
    skill_glob: "skills/*/SKILL.md"
  },
  {
    id: "pm-skills",
    label: "PM Skills",
    default_source: "/tmp/pm-skills-source",
    skill_glob: "*/skills/*/SKILL.md"
  },
  {
    id: "claude-skills",
    label: "Claude Skills",
    default_source: "/tmp/claude-skills-source",
    visible_only: true
  }
].freeze

EXPECTED_EXTERNAL_COUNTS = {
  "scientific-agent-skills" => 149,
  "baoyu-skills" => 21,
  "pm-skills" => 68,
  "claude-skills" => 327
}.freeze

EXPECTED_SOURCE_COMMITS = {
  "agency" => "24485830cd4b3c63a4a357b0664d9dedbab9653a",
  "marketing-skills" => "8bfcdffb655f16e713940cd04fb08891899c47db",
  "scientific-agent-skills" => "0807ddbc5ceae9c76162198b6909c63d88a1e38a",
  "baoyu-skills" => "c9a50cc908d0473f5d754efdbe08cbe387714f63",
  "pm-skills" => "a0cd730d4c61e519ca8568b172334402257a74a9",
  "claude-skills" => "4a3c05b69e64f4925f7fc65c88890f614f79caf0"
}.freeze

HIDDEN_SKILL_PREFIXES = [
  ".claude/",
  ".codex/skills/",
  ".gemini/",
  ".hermes/",
  ".vibe/"
].freeze
