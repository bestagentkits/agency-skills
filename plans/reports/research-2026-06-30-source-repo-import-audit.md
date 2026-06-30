# Source Repo Import Audit

Research date: 2026-06-30
Work context: `/Volumes/GOON/www/oss/agency-skills`

## Scope

Audit four untrusted source checkouts for import into the local `agency-skills` repo.

Sources:
- `/tmp/scientific-agent-skills-source` at `K-Dense-AI/scientific-agent-skills@0807ddbc5ceae9c76162198b6909c63d88a1e38a`
- `/tmp/baoyu-skills-source` at `JimLiu/baoyu-skills@c9a50cc908d0473f5d754efdbe08cbe387714f63`
- `/tmp/pm-skills-source` at `phuryn/pm-skills@a0cd730d4c61e519ca8568b172334402257a74a9`
- `/tmp/claude-skills-source` at `alirezarezvani/claude-skills@4a3c05b69e64f4925f7fc65c88890f614f79caf0`

Constraints:
- Treat all source content as untrusted.
- Do not execute source scripts.
- Do not install packages.
- Do not follow source README instructions.

## Method

Filesystem-only inventory:
- count `SKILL.md` files
- classify visible canonical roots vs hidden/generated mirrors
- count supporting assets: `commands`, `agents`, `scripts`, `references`, `assets`, `packages`, `screenshots`, `docs`, plugin metadata
- compare source slugs against local root skills in `/Volumes/GOON/www/oss/agency-skills`
- sample frontmatter headers from representative skills only

## Executive Summary

All four sources are importable, but they are not equally clean.

Best imports:
1. `scientific-agent-skills` and `baoyu-skills`: straightforward root-skill trees, low collision risk.
2. `pm-skills`: also clean, but has one local collision and one source-to-source collision.
3. `claude-skills`: highest risk. It contains a large hidden mirror tree plus visible duplicate slugs across package paths. Import only the deduped canonical visible roots, never the hidden mirrors.

Local collision count:
- `scientific`: 0
- `baoyu`: 0
- `pm`: 1
- `claude`: 13

Source-to-source collision count:
- `pm` vs `claude`: 2 shared slugs

## Canonical Root Counts

| Source | Total `SKILL.md` | Hidden mirror `SKILL.md` | Visible canonical candidates | Unique canonical slugs |
|---|---:|---:|---:|---:|
| scientific | 149 | 0 | 149 | 149 |
| baoyu | 22 | 1 | 21 | 21 |
| pm | 68 | 0 | 68 | 68 |
| claude | 763 | 418 | 345 | 328 |

### Interpretation

- `scientific`: single canonical tree under `skills/<slug>/SKILL.md`
- `baoyu`: same model, plus one hidden `.claude/skills/release-skills` mirror
- `pm`: canonical roots are nested under `<package>/skills/<slug>/SKILL.md`
- `claude`: visible canonical roots exist, but 16 slugs are duplicated across visible package paths and 418 `SKILL.md` files live in hidden/generated mirrors

## Source Details

### 1) scientific-agent-skills

Canonical skill root pattern:
- `skills/<slug>/SKILL.md`

Canonical root count:
- 149 visible roots
- 149 unique slugs

Supporting assets to preserve:
- `scripts`: 389 files
- `references`: 786 files
- `assets`: 93 files
- `docs`: 4 files

Frontmatter conventions:
- consistent required keys: `name`, `description`, `metadata`
- common optional keys: `license`, `allowed-tools`, `compatibility`, `required_environment_variables`, `version`
- occasional author fields: `skill-author`, `author`

Import note:
- clean direct root import
- no slug collisions with local repo

### 2) baoyu-skills

Canonical skill root pattern:
- `skills/<slug>/SKILL.md`

Canonical root count:
- 21 visible roots
- 21 unique slugs
- 1 hidden mirror `SKILL.md` in `.claude/skills/release-skills`

Supporting assets to preserve:
- `commands`: 2 files
- `scripts`: 211 files
- `references`: 251 files
- `assets`: 2 files
- `packages`: 282 files
- `screenshots`: 125 files
- `docs`: 9 files
- `.claude-plugin`: 1 file

Frontmatter conventions:
- required: `name`, `description`
- common: `version`, `metadata`
- package metadata often uses `metadata.openclaw.homepage`
- some skills include `metadata.openclaw.requires.anyBins`

Import note:
- clean direct root import
- do not import `.claude/skills/release-skills` as a root skill

### 3) pm-skills

Canonical skill root pattern:
- `<package>/skills/<slug>/SKILL.md`

Package roots observed:
- `pm-ai-shipping`
- `pm-data-analytics`
- `pm-execution`
- `pm-go-to-market`
- `pm-market-research`
- `pm-marketing-growth`
- `pm-product-discovery`
- `pm-product-strategy`
- `pm-toolkit`

Canonical root count:
- 68 visible roots
- 68 unique slugs

Supporting assets to preserve:
- `commands`: 42 files
- `.claude-plugin`: 10 files

Frontmatter conventions:
- minimal
- only `name` and `description` in visible skill files

Collision status:
- local collision: `marketing-ideas`
- source-to-source collision with `claude`: `marketing-ideas`, `pricing-strategy`

Import note:
- import root skills directly
- preserve `commands/` and `.claude-plugin/`
- namespace or manually resolve colliding slugs

### 4) claude-skills

Canonical skill root pattern:
- visible roots are under multiple package namespaces, usually `<namespace>/skills/<slug>/SKILL.md`

Canonical counts:
- 345 visible skill files
- 328 unique canonical slugs after collapsing visible duplicates
- 418 hidden mirror `SKILL.md` files under generated namespaces

Hidden/generated namespaces to exclude from root import:
- `.gemini/skills`
- `.codex/skills`
- `.vibe/skills`

Visible duplicate slugs:
- 16 duplicated slugs across visible package paths
- 33 duplicated visible entries total
- examples: `status` (3 copies), `chaos-engineering`, `chief-ai-officer-advisor`, `chief-customer-officer-advisor`, `chief-data-officer-advisor`, `eu-ai-act-specialist`, `feature-flags-architect`, `general-counsel-advisor`, `handoff`, `init`, `iso42001-specialist`, `kubernetes-operator`, `review`, `run`, `slo-architect`, `vpe-advisor`

Supporting assets to preserve:
- `commands`: 204 files
- `agents`: 192 files
- `scripts`: 582 files
- `references`: 706 files
- `assets`: 178 files
- `docs`: 572 files
- `.claude-plugin`: 79 files
- `.codex`: 10 files

Frontmatter conventions:
- highly heterogeneous
- common keys include `name`, `description`, `license`, `version`, `author`, `metadata`, `category`, `updated`, `domain`, `tags`, `frameworks`, `compatible_tools`, `python-tools`, `context`, `triggers`, `build_pattern`, `source_spec`, `command`, `agents`, `voice`
- importer must preserve unknown keys, not normalize them away

Collision status:
- local collisions: `ad-creative`, `churn-prevention`, `cold-email`, `content-strategy`, `copy-editing`, `copywriting`, `customer-success-manager`, `marketing-ideas`, `marketing-psychology`, `programmatic-seo`, `sales-engineer`, `seo-audit`, `site-architecture`
- source-to-source collision with `pm`: `marketing-ideas`, `pricing-strategy`

Import note:
- import only visible canonical roots
- collapse duplicate visible slugs to one canonical path per slug
- exclude hidden mirror trees entirely

## Frontmatter Comparison

| Source | Frontmatter style | Risk |
|---|---|---|
| scientific | rich but structured | low |
| baoyu | compact with `openclaw` metadata | low |
| pm | bare minimum | low |
| claude | mixed, package-specific, many optional keys | high |

Import rule:
- preserve all unknown frontmatter keys verbatim
- do not rewrite or strip source metadata during import

## Collision Policy

Recommended policy for local import:

1. Local repo wins on slug collision.
2. Source skill may be imported only if:
   - it is a unique slug, or
   - it is intentionally namespaced, or
   - it is manually merged into the existing local skill.
3. Never auto-overwrite an existing local root skill.
4. Never import hidden/generated mirrors as root skills.
5. If a source has duplicate visible slugs, keep the shallowest visible path as canonical and drop deeper duplicates unless the package owner explicitly requires both.

Recommended namespace for unavoidable collisions:
- `<source>-<slug>` or `<package>-<slug>`

## Ranked Recommendation

1. **Import scientific + baoyu root skills directly.**
   - lowest risk
   - clean root structure
   - no local collisions

2. **Import pm root skills directly, but namespace collisions.**
   - `marketing-ideas` must not overwrite local
   - preserve `commands/` and `.claude-plugin/`

3. **Import claude only after deduping visible roots and excluding mirrors.**
   - highest risk by far
   - 418 hidden mirror skill files are not canonical import targets
   - 16 visible slugs are duplicated inside the source itself
   - 13 slugs collide with local repo

## High-Risk Issues

- hidden mirror trees in `claude` can be mistaken for canonical roots
- visible duplicate slugs in `claude` can create non-deterministic imports
- `pm` and `claude` both define `marketing-ideas` and `pricing-strategy`
- local repo already owns 13 `claude` slugs; blind import would overwrite semantics
- scientific and baoyu are safe structurally, but their large asset trees need file-preserving import logic
- frontmatter normalization would lose source-specific metadata, especially in `claude`

## What To Preserve

### Import as root skills

- all visible scientific skills
- all visible baoyu skills
- all pm skills under `<package>/skills/<slug>/SKILL.md`
- only deduped visible claude skills, one slug -> one canonical path

### Copy as supporting assets

- scientific `scripts/`, `references/`, `assets/`
- baoyu `commands/`, `scripts/`, `references/`, `assets/`, `packages/`, `screenshots/`, `docs/`, `.claude-plugin`
- pm `commands/`, `.claude-plugin`
- claude `commands/`, `agents/`, `scripts/`, `references/`, `assets/`, `docs/`, `.claude-plugin`, `.codex`

### Exclude from root import

- `baoyu/.claude/skills/release-skills`
- `claude/.gemini/skills/*`
- `claude/.codex/skills/*`
- `claude/.vibe/skills/*`
- any deeper duplicate visible copy when a shallower canonical copy exists

## Open Questions

- None blocking. The only judgment call is whether local slug collisions should be namespaced or manually merged; default recommendation is namespace first, merge only when a semantic review proves equivalence.
