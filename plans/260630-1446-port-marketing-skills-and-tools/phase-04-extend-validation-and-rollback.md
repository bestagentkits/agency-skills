---
phase: 4
title: "Extend validation and rollback"
status: complete
priority: P1
dependencies: [1, 2, 3]
effort: 2h
---

# Phase 4: Extend validation and rollback

## Overview

Extend the validator from a single-catalog agency check into a two-catalog import audit with clear reproduction commands and a rollback path. The current validator hard-codes 232 manifest entries and exact agency source-body equality, so it cannot validate rewritten marketing content or copied `tools/` yet (`scripts/validate-generated-skills.rb:8-10`, `scripts/validate-generated-skills.rb:37-41`, `scripts/validate-generated-skills.rb:64-100`).

## Context Links

- Current validator assumptions: `scripts/validate-generated-skills.rb:8-10`, `scripts/validate-generated-skills.rb:37-41`, `scripts/validate-generated-skills.rb:64-100`
- Current manifest contract: `scripts/convert-agents-to-skills.rb:116-126`
- Marketplace contract: `scripts/generate-plugin-marketplace.rb:19-25`
- Import/link hotspots: `reports/scout-report.md:12-21`

## Requirements

- Functional: preserve the current strict agency validation rules for the original catalog.
- Functional: add marketing validation for rewritten Markdown, generated `agents/openai.yaml`, copied `references/` and `evals/`, and imported `tools/`.
- Functional: verify imported CLI permissions and stable shebangs without executing the CLIs.
- Functional: publish reproducible validation commands and a single-commit rollback plan.
- Non-functional: keep failure output catalog-aware so agency regressions and marketing regressions are distinguishable.

## Architecture

Test matrix:
- Unit: path rewriter fixtures for top-level skill-to-tool, nested reference-to-tool, peer-skill, tool-to-skill, and tool-to-tool links.
- Integration: import into a temp target, then validate manifest rows, `agents/openai.yaml`, copied trees, link resolution, and CLI modes.
- End-to-end: rerun the documented four-command regeneration sequence from a clean checkout and confirm validator success.

Rollback strategy:
- Preferred: land all import changes in one commit and use `git revert <commit>` for clean rollback.
- Local-only fallback: remove imported root skill dirs and `tools/`, restore `data/skills-manifest.json`, `README.md`, `.claude-plugin/marketplace.json`, and revert script changes.

## Related Code Files

- Modify: `scripts/validate-generated-skills.rb`
- Create if needed for size control: `scripts/support/marketing-import-validator.rb`
- Modify: `README.md` (validation/reproduction commands)
- Read only: `.claude-plugin/marketplace.json`, `data/skills-manifest.json`

## Implementation Steps

1. Split validation by catalog: agency keeps exact source-body equality; marketing compares imported Markdown to the source after the shared link rewriter is applied.
2. Add structural checks for imported `references/`, `evals/`, `agents/openai.yaml`, and the `tools/` subtree.
3. Add CLI-specific checks that imported Node scripts remain non-executable assets.
4. Add a broken-link crawl across imported Markdown so doc regressions fail fast.
5. Document and run the final validation sequence:
   - `ruby scripts/convert-agents-to-skills.rb /tmp/agency-source .`
   - `ruby scripts/import-marketing-skills.rb /tmp/marketingskills-source .`
   - `ruby scripts/generate-plugin-marketplace.rb .`
   - `ruby scripts/validate-generated-skills.rb . /tmp/agency-source /tmp/marketingskills-source`

## Todo List

- [x] Validator distinguishes agency and marketing rules.
- [x] Link-resolution audit exists for imported Markdown.
- [x] CLI asset permission checks exist for copied tools.
- [x] README includes the final regeneration + validation commands.

## Success Criteria

- [x] A clean rerun from both source checkouts reproduces the combined repo state.
- [x] Validator failures identify the exact catalog and file class that drifted.
- [x] Rollback can happen with one commit revert and leaves the original agency-only flow intact.

## Risk Assessment

- High: import and validator use different rewrite rules and silently disagree.
  Mitigation: validator must reuse the same rewriter/helper module as import.
- Medium: rollback leaves generated files behind.
  Mitigation: keep all imported content additive and land it in one commit.

## Security Considerations

- Never execute copied CLIs against live credentials during validation.
- Validation should read env-var docs as content only; it must not source any shell profile or `.env` file.

## Next Steps

- After this phase, the implementation is shippable with a reproducible command chain and a clean revert path.
- Rollback documentation should be copied into the final PR description when implementation starts.
