---
phase: 3
title: "Regenerate marketplace and docs"
status: complete
priority: P2
dependencies: [2]
effort: 2h
---

# Phase 3: Regenerate marketplace and docs

## Overview

Regenerate all manifest consumers after the import: README, marketplace catalog, and reproduction instructions. This phase stays additive: tools are documented, not registered as plugin commands or MCP servers (`README.md:26-35`, `scripts/generate-plugin-marketplace.rb:27-54`).

## Context Links

- Current README install/source sections: `README.md:12-49`
- Current marketplace generator contract: `scripts/generate-plugin-marketplace.rb:19-59`
- Current marketplace output shape: `.claude-plugin/marketplace.json:8-32`
- Inventory and tool-doc surfaces: `reports/scout-report.md:12-21`

## Requirements

- Functional: regenerate `README.md` from the combined manifest and source metadata.
- Functional: add a distinct Marketing Skills section instead of mixing the imported generic skills into the current Agency Skills division index.
- Functional: document `tools/REGISTRY.md`, `tools/clis/README.md`, and the new import/reproduction sequence.
- Functional: keep `.claude-plugin/marketplace.json` skill-only; do not add tool entries.
- Non-functional: avoid mentioning `msitarzewski/agency-agents` in README.

## Architecture

Data flow:
1. Input: combined manifest and source provenance from both catalogs.
2. Transform: render README sections for the legacy Agency Skills index, the imported Marketing Skills index, and the imported tools surface; regenerate marketplace skill list from manifest `skill` keys only.
3. Output: human docs plus plugin catalog, both reproducible from the scripts.

Failure modes:
- Medium / High: rerunning the agency converter overwrites the combined README.
  Mitigation: one shared README builder used by both the agency converter and the marketing importer.
- Low / Medium: marketplace description drifts from actual skill count.
  Mitigation: generate count-driven copy from manifest length.

## Related Code Files

- Modify: `README.md`
- Modify: `.claude-plugin/marketplace.json`
- Modify: `scripts/generate-plugin-marketplace.rb`
- Modify: `scripts/convert-agents-to-skills.rb`
- Modify: `scripts/import-marketing-skills.rb`

## Implementation Steps

1. Move combined README rendering into the marketing import helper.
2. Keep the existing Agency Skills index grouped by `division`, then render a Marketing Skills section from the imported marketing catalog.
3. Add a tools overview that points to `tools/REGISTRY.md`, `tools/clis/README.md`, and the integration/composio docs.
4. Update reproduction instructions to the four-step combined flow: agency convert, marketing import, marketplace generate, validate.
5. Regenerate `.claude-plugin/marketplace.json` from the combined manifest and update plugin copy to be source-agnostic and count-driven.

## Todo List

- [x] README includes the combined catalog and Marketing Skills section.
- [x] README documents the imported `tools/` surface and reproduction flow.
- [x] Marketplace still lists only `./<skill>` entries.
- [x] Marketplace copy no longer assumes an agency-only 232-skill catalog.

## Success Criteria

- [x] README reflects the combined catalog and the new import commands.
- [x] Marketplace skill count matches the combined manifest count.
- [x] No imported tool file is exposed as a plugin command or marketplace entry.

## Risk Assessment

- Medium: README and marketplace are regenerated from different assumptions.
  Mitigation: both consume the same combined manifest metadata.
- Low: imported marketing skills are sorted inconsistently across docs and marketplace.
  Mitigation: sort by manifest `skill` for marketplace and by display name/name for README sections.

## Security Considerations

- Documentation must not embed secrets or suggest committed credential files.
- Tool docs can mention environment variables, but the repo should still ship only documentation and scripts, not any filled env files.

## Next Steps

- Phase 4 validates the generated docs and marketplace against the final imported tree.
- Rollback is artifact-only here: rerender README/marketplace from the pre-import manifest state or revert the import commit.
