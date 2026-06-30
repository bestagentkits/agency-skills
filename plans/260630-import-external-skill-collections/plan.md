---
title: "Import External Skill Collections Into Agency Skills"
description: "Plan the additive import of four external skill catalogs into the existing root-skill marketplace."
status: complete
priority: P2
effort: 2d
branch: "main"
tags: [skills, import, marketplace, validation]
created: 2026-06-30
---

# Import External Skill Collections Into Agency Skills

## Overview
Baseline is `232 agency + 45 marketing = 277` root skills with `SKILL.md` + `agents/openai.yaml`; manifest drives README and marketplace, and validation started hard-coded to those two collections. Incoming canonical inventory is `149 scientific + 21 baoyu + 68 pm + 327 claude = 565`, with collision/exclusion policy already set: local slugs win, namespace incoming collisions, preserve source asset trees as non-executable files, exclude hidden mirrors, keep marketplace `strict: false` (`plans/reports/research-2026-06-30-source-repo-import-audit.md:49-56`, `plans/reports/research-2026-06-30-source-repo-import-audit.md:215-229`, `plans/reports/research-2026-06-30-source-repo-import-audit.md:257-279`, `scripts/generate-plugin-marketplace.rb:35-55`).

## Data Flow
Source checkouts -> per-source inventory + slug resolver -> staged root skill dirs + copied support assets -> `data/skills-manifest.json` -> regenerated `README.md` + `.claude-plugin/marketplace.json` -> catalog-aware validator. Backward compatibility: keep the existing 277 skills untouched and additive (`scripts/import-marketing-skills.rb:87-145`, `scripts/marketing-readme-writer.rb:14-85`).

## Phases
1. Generalize the importer. Depends on none; owns `scripts/**`.
   TODO: extract shared helpers from the current marketing importer so one entrypoint can map `skills/*/SKILL.md`, `*/skills/*/SKILL.md`, and visible-only claude roots without executing upstream scripts (`scripts/import-marketing-skills.rb:40-146`).
   Risk: High. Wrong canonical path or slug mapping. Mitigation: adapter per source + explicit namespace map from the audit (`plans/reports/research-2026-06-30-source-repo-import-audit.md:158-229`).
2. Stage and import skills/assets. Depends on 1; owns new root skill dirs, copied asset trees, and `data/skills-manifest.json`.
   TODO: import 565 canonical skills, namespace incoming collisions, preserve support trees (`commands/`, `scripts/`, `references/`, `assets/`, `packages/`, `screenshots/`, `docs/`, `.claude-plugin`, `.codex`) as non-executable files, and exclude baoyu/claude mirrors (`plans/reports/research-2026-06-30-source-repo-import-audit.md:257-279`).
   Risk: High. Partial repo mutation. Mitigation: stage outside tracked paths, promote only after counts/link checks pass (`scripts/import-marketing-skills.rb:95-145`).
3. Regenerate docs and marketplace. Depends on 2; owns `README.md` and `.claude-plugin/marketplace.json`.
   TODO: drive README index, source provenance, and plugin skill list from manifest only; keep Anthropic marketplace `strict:false` with explicit skills; do not register copied tools/commands as runtime surfaces (`scripts/marketing-readme-writer.rb:14-85`, `scripts/generate-plugin-marketplace.rb:28-60`, `README.md:29-44`).
   Risk: Medium. Manifest/README/marketplace drift. Mitigation: one renderer path, no hand-edited counts.
4. Expand validation and ship/rollback gates. Depends on 1-3; owns `scripts/validate-generated-skills.rb` and repro commands.
   TODO: replace fixed `232/45` assertions with collection-aware rules, validate `842` root skills after import, verify namespace decisions, copied asset presence, `agents/openai.yaml`, hidden-mirror exclusion, and non-executable copied scripts/commands without executing source code (`scripts/validate-generated-skills.rb:11-12`, `scripts/validate-generated-skills.rb:50-142`, `plans/reports/research-2026-06-30-source-repo-import-audit.md:248-279`).
   Risk: High. False pass on missing or duplicated imports. Mitigation: validate from manifest + source inventories, then run the full repro flow on a temp target first.

## Validation
- Temp-target dry run passes before touching the working tree, then repo run passes after import.
- `manifest rows == root skill dirs == README links == marketplace skills`, and post-import count is `842`.
- Collision samples are verified for `marketing-ideas`, `pricing-strategy`, and the 13 claude/local overlaps (`plans/reports/research-2026-06-30-source-repo-import-audit.md:149-156`, `plans/reports/research-2026-06-30-source-repo-import-audit.md:193-199`).

## Rollback
Land the import in one commit. Primary rollback is `git revert <commit>`; local fallback is restore `data/skills-manifest.json`, `README.md`, `.claude-plugin/marketplace.json`, and importer/validator scripts from HEAD, then delete only the newly imported or namespaced root dirs and copied external asset trees.

## Unresolved Questions
- None.
