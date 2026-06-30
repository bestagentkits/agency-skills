---
phase: 2
title: "Import skills and tools"
status: complete
priority: P1
dependencies: [1]
effort: 3h
---

# Phase 2: Import skills and tools

## Overview

Use the Phase 1 import pipeline to copy the marketing source tree into the local marketplace layout: 45 root skill folders plus a repo-root `tools/` tree. The import is additive; existing agency skills stay untouched (`reports/scout-report.md:12-25`).

## Context Links

- Source inventory: `reports/scout-report.md:12-14`
- Skill-to-tool rewrite examples: `reports/scout-report.md:18-19`
- Tool-local link stability: `reports/scout-report.md:20-21`
- Repo skill contract: `README.md:7-10`

## Requirements

- Functional: create 45 new repo-root skill folders from `skills/<name>/`.
- Functional: preserve each skill's `references/` and `evals/` subtrees when present (`reports/scout-report.md:12-13`).
- Functional: create `agents/openai.yaml` for imported skills so marketplace consumers see the same shape as existing skills (`README.md:7-10`).
- Functional: copy `tools/REGISTRY.md`, `tools/clis/*`, `tools/integrations/*`, and `tools/composio/*`.
- Non-functional: preserve executable bits and shebangs on the 64 CLI files (`reports/scout-report.md:12-14`).

## Architecture

Data flow:
1. Input: marketing source files and the Phase 1 path map.
2. Transform: stage copied content, rewrite Markdown links, generate OpenAI metadata, then merge manifest rows.
3. Output: imported root skill folders, imported `tools/`, and a combined manifest ready for docs/marketplace generation.

Backwards compatibility:
- Existing 232 agency skill folders remain in place and are not renamed.
- Imported tools remain plain files under `tools/`; they are not wired into plugin runtime surfaces.

## Related Code Files

- Modify: `data/skills-manifest.json`
- Create: `ab-testing/`, `ad-creative/`, `ads/`, `ai-seo/`, `analytics/`, `aso/`, `churn-prevention/`, `co-marketing/`, `cold-email/`, `community-marketing/`, plus 35 more imported root skill dirs
- Create: `tools/REGISTRY.md`, `tools/clis/*`, `tools/integrations/*`, `tools/composio/*`
- Read only: existing root skills remain untouched

## Implementation Steps

1. Stage imported content outside tracked paths first so broken-link or permission failures do not leave a partial repo mutation.
2. Copy each source skill directory to repo root, preserve `SKILL.md`, `references/`, and `evals/`, then generate `agents/openai.yaml`.
3. Copy the full `tools/` tree and run the shared rewriter over any Markdown file whose target moved because skills were relocated to repo root.
4. Append marketing entries to `data/skills-manifest.json` with the agreed catalog metadata and source provenance.
5. Run a pre-docs audit: missing files, broken relative links inside imported Markdown, duplicate skill names, and missing executable bits on CLIs.

## Todo List

- [x] 45 imported skill folders exist at repo root.
- [x] Imported skills with `references/` or `evals/` preserve those trees.
- [x] `tools/` exists with registry, CLIs, integrations, and Composio docs.
- [x] Manifest contains additive marketing rows without disturbing agency rows.

## Success Criteria

- [x] Imported skills count matches the source inventory.
- [x] `tools/` file count matches the source inventory; CLI scripts are non-executable assets.
- [x] Broken-link audit reports zero unresolved internal Markdown links across imported skills and tools.

## Risk Assessment

- High: partial import mutates manifest before copied files are complete.
  Mitigation: stage generated output first, then promote into tracked paths after audit.
- Medium: permission bits drop on copied CLIs.
  Mitigation: preserve file modes during copy and verify them before commit.

## Security Considerations

- Do not run copied vendor CLIs; validate only structure, shebangs, permissions, and docs.
- Keep import additive; never delete unrelated root skill folders during copy.

## Next Steps

- Phase 3 consumes the combined manifest and imported filesystem layout.
- Rollback after this phase is path-scoped: remove imported root skill dirs plus `tools/`, then restore the prior manifest snapshot.
