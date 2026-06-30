---
phase: 1
title: "Add import pipeline"
status: complete
priority: P1
dependencies: []
effort: 3h
---

# Phase 1: Add import pipeline

## Overview

Create the reusable import machinery for marketing skills and tools before any generated content is written. Current repo scripts only know how to generate agency root skills plus `agents/openai.yaml`, manifest entries, README, and marketplace artifacts (`scripts/convert-agents-to-skills.rb:76-126`, `scripts/generate-plugin-marketplace.rb:19-59`).

## Context Links

- Repo contract: `README.md:7-10`
- Agency converter: `scripts/convert-agents-to-skills.rb:76-126`
- Marketplace generator: `scripts/generate-plugin-marketplace.rb:19-59`
- Validation constraint to preserve: `scripts/validate-generated-skills.rb:58-73`
- Source inventory + rewrite hotspots: `reports/scout-report.md:12-21`

## Requirements

- Functional: import from `/tmp/marketingskills-source` into repo-root skill folders and repo-root `tools/`.
- Functional: preserve source marketing `SKILL.md` frontmatter, including extra metadata like `metadata.version` (`skills/ads/SKILL.md:1-6`).
- Functional: generate `agents/openai.yaml` for every imported skill so the repo contract stays consistent (`README.md:7-10`, `scripts/convert-agents-to-skills.rb:76-84`).
- Non-functional: keep main scripts under 200 lines by extracting shared helpers instead of piling logic into existing generators.

## Architecture

Data flow:
1. Input: existing repo root, agency manifest, and marketing source tree.
2. Transform: build a source-to-destination path map for `skills/<name>/** -> <name>/**` and `tools/** -> tools/**`; then rewrite relative Markdown links from the resolved source target to the resolved destination target.
3. Output: import-ready skill directories, tool tree, manifest rows, README sections, and OpenAI metadata generated from one shared helper layer.

Failure modes:
- High / High: regex-only link rewrites miss nested `references/` and tool-to-skill links.
  Mitigation: one path-aware rewriter shared by import and validation.
- Medium / High: README logic drifts between the agency converter and the marketing importer.
  Mitigation: one shared README builder called by both scripts.

## Related Code Files

- Create: `scripts/import-marketing-skills.rb`
- Create: `scripts/support/relative-markdown-link-rewriter.rb`
- Create: `scripts/support/skill-catalog-artifact-builder.rb`
- Modify: `scripts/convert-agents-to-skills.rb`
- Modify: `scripts/generate-plugin-marketplace.rb`

## Implementation Steps

1. Add shared helpers for `agents/openai.yaml`, manifest entry normalization, and README rendering so the existing agency converter and the new marketing importer use the same artifact contract.
2. Define the combined manifest schema with explicit catalog metadata, e.g. `catalog`, `source_repo`, `source_commit`, and `source_path`, while keeping `skill` as the marketplace key (`scripts/generate-plugin-marketplace.rb:20-25`).
3. Implement a path-aware Markdown rewriter that resolves each relative link from the source file location and emits the correct relative path from the destination file location.
4. Update the agency converter to emit the new manifest metadata and to call the shared README builder instead of carrying a second copy of README rendering logic.
5. Update the marketplace generator text to be count-driven and source-agnostic rather than hard-coded to the current agency-only description (`scripts/generate-plugin-marketplace.rb:36-38`).

## Todo List

- [x] README helper exists for the combined marketing import output.
- [x] Import script entrypoint exists with source root + target root arguments.
- [x] Link rewriter handles moved tool and skill references.
- [x] Manifest schema is additive and backward-compatible for marketplace generation.

## Success Criteria

- [x] Import maps each source skill folder into a root skill folder.
- [x] Existing agency generation still emits valid root skills and `agents/openai.yaml`.
- [x] No Ruby script exceeds the repo's 200-line guideline.

## Risk Assessment

- High: helper drift between import and validation.
  Mitigation: validation must call the same rewriter/helper code path as import.
- Medium: manifest schema extension breaks downstream consumers.
  Mitigation: keep existing keys intact and treat new keys as additive.

## Security Considerations

- Do not execute imported CLI scripts in this phase.
- Treat all imported content as data; only inspect files, permissions, and links.

## Next Steps

- Phase 2 depends on the rewriter and shared artifact helpers being in place.
- Rollback is code-only here: revert new helper/import files and restore the previous generator text.
