# Scout Report

## Repo Contract

- `README.md:7-10` defines the local skill contract: each root skill folder ships `SKILL.md` plus `agents/openai.yaml`.
- `scripts/convert-agents-to-skills.rb:105-126` creates root skill folders, writes `agents/openai.yaml`, and regenerates `data/skills-manifest.json`.
- `scripts/generate-plugin-marketplace.rb:19-59` builds `.claude-plugin/marketplace.json` only from `data/skills-manifest.json`.
- `scripts/validate-generated-skills.rb:37-100` validates a single 232-entry agency catalog and enforces exact source-body equality for agency skill content.

## Source Inventory

- Filesystem scan of `/tmp/marketingskills-source` found 45 skill folders, 38 `references/` subdirs, 43 `evals/` subdirs, 161 files under `tools/`, 93 integration guides, and 64 executable CLI scripts.
- Source skills already have `name` and `description` frontmatter and may carry extra metadata like `metadata.version`, so imported marketing skill validation cannot reuse the agency-only `frontmatter keys == [description, name]` rule (`skills/ads/SKILL.md:1-6`).
- Tool docs and CLIs are documentation/runtime artifacts, not plugin metadata: registry index (`tools/REGISTRY.md:13-18`), CLI usage contract (`tools/clis/README.md:3-5`), executable shebang example (`tools/clis/github-prospects.js:1-5`).

## Link Rewrite Hotspots

- Top-level skills link into `../../tools/...` and will break if copied to repo root without rewrite (`skills/prospecting/SKILL.md:227-244`).
- Nested skill references link into `../../../tools/...` and peer skills like `../../pricing/SKILL.md`; those targets must be recalculated from the new destination path, not by regex-only replacement (`skills/prospecting/references/data-sources.md:39-58`, `skills/offers/references/offer-formats.md:198-202`).
- Tool docs keep stable tool-local links to CLIs and Composio docs (`tools/integrations/g2.md:7-12`, `tools/integrations/composio.md:180-183`).
- Tool docs also contain at least one back-link into the source `skills/` tree, which must be rewritten when skills move to repo root (`tools/REGISTRY.md:511-511`).

## Collision Check

- Filesystem scan found zero root-name conflicts between current repo skill folders and the 45 source marketing skill folder names.
