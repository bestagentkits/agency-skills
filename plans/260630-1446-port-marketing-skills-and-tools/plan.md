---
title: "Port Marketing Skills And Tools Into Agency Skills"
description: "Plan the additive import of the MarketingSkills catalog into the existing root-skill marketplace."
status: complete
priority: P2
effort: 1d
branch: "main"
tags: [skills, tools, import, marketing]
blockedBy: []
blocks: []
created: 2026-06-30
createdBy: "ck:plan"
source: skill
---

# Port Marketing Skills And Tools Into Agency Skills

## Overview

Import the `/tmp/marketingskills-source` skill and tool catalog into the existing root-skill repo while preserving the current agency regeneration flow, keeping tools as copied docs/CLIs only, and widening validation for a mixed catalog. Current repo truth: root skills plus `agents/openai.yaml`, manifest-driven marketplace generation, and agency-only validation (`README.md:7-10`, `scripts/convert-agents-to-skills.rb:105-126`, `scripts/generate-plugin-marketplace.rb:19-59`, `scripts/validate-generated-skills.rb:37-100`).

## Phases

| Phase | Name | Status | Depends on | Detail |
|-------|------|--------|------------|--------|
| 1 | [Add import pipeline](./phase-01-add-import-pipeline.md) | Complete | - | Import entrypoint, README helper, path rewriting |
| 2 | [Import skills and tools](./phase-02-import-skills-and-tools.md) | Complete | 1 | Copy 45 skills + 161 tool files, generate `agents/openai.yaml`, import CLIs as non-executable assets |
| 3 | [Regenerate marketplace and docs](./phase-03-regenerate-marketplace-and-docs.md) | Complete | 2 | Refresh README + marketplace from the combined manifest; tools stay docs only |
| 4 | [Extend validation and rollback](./phase-04-extend-validation-and-rollback.md) | Complete | 1-3 | Catalog-aware validator, broken-link crawl, reproducible commands, single-commit rollback |

## Dependencies

Sequential only. File ownership stays non-overlapping: Phase 1 owns `scripts/**`; Phase 2 owns imported root skill dirs, `tools/**`, and `data/skills-manifest.json`; Phase 3 owns `README.md` and `.claude-plugin/marketplace.json`; Phase 4 owns validator code and validation commands.

## Done Means

- Combined manifest and marketplace enumerate the existing 232 agency skills plus the imported marketing catalog.
- Imported marketing skills live at repo root and ship `agents/openai.yaml` to match the current repo contract (`README.md:7-10`).
- `tools/` is copied as docs/CLIs only; no plugin command, slash command, or MCP registration is added.
- Internal markdown links resolve after rewrite, CLI tools are non-executable assets by default, and the combined validator passes against both source checkouts.

## Rollback

Land the import in one commit. Reverting that commit must remove imported root skill dirs and `tools/`, restore the pre-import README/marketplace/manifest, and leave the agency-only regeneration path usable.

## References

- [Scout report](./reports/scout-report.md)
- [Phase 1](./phase-01-add-import-pipeline.md)
- [Phase 2](./phase-02-import-skills-and-tools.md)
- [Phase 3](./phase-03-regenerate-marketplace-and-docs.md)
- [Phase 4](./phase-04-extend-validation-and-rollback.md)
