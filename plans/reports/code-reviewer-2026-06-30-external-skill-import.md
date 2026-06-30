# Code Review Summary

## Scope

- Files: `scripts/imported-collection-support.rb`, `scripts/import-external-skill-collections.rb`, `scripts/readme-writer.rb`, `scripts/validate-generated-skills.rb`, `scripts/convert-agents-to-skills.rb`, `scripts/import-marketing-skills.rb`, `scripts/generate-plugin-marketplace.rb`, `data/skills-manifest.json`, `data/imported-tools-manifest.json`, `README.md`, `.claude-plugin/marketplace.json`
- LOC reviewed: 12,705 current LOC in scoped files
- Focus: recent import implementation + generated manifest/README/marketplace contracts
- Scout findings: main trust boundaries are untrusted source path/name handling, copied symlinks, generated contract consistency, validator independence

## Overall Assessment

Generated output contract is mostly coherent: manifest count is 842; collection split matches expected `232/45/149/21/68/327`; marketplace is `strict:false` with 842 explicit skills; README links match manifest. Fresh checks passed for Ruby syntax, generated-skill validation, Claude plugin validation, diff whitespace, and executable imported asset scan.

Not production-ready until the source trust-boundary gaps below are closed. Current source snapshots appear benign for these issues, but the importers are explicitly pointed at untrusted `/tmp` checkouts and can mutate/copy outside intended boundaries before validation runs.

## Critical Issues

- [scripts/import-marketing-skills.rb:91](../../scripts/import-marketing-skills.rb) Untrusted frontmatter `name` is used directly as the filesystem slug, then `FileUtils.rm_rf(target_dir)` runs before any slug or containment validation. A malicious `/tmp/marketingskills-source/skills/*/SKILL.md` with `name: ../../some-path` can delete and rewrite paths outside `TARGET_DIR` via lines 93-98. Validation catches invalid skill names only after the destructive operation.
  Fix: validate `slug` against `\A[a-z0-9]+(?:-[a-z0-9]+)*\z` before `File.join`; derive slug from source directory if possible; guard every target path with `expanded.start_with?("#{File.expand_path(TARGET_DIR)}/")`; fail before `rm_rf`, `mkdir_p`, `cp_r`, or `write`.

## High Priority

- [scripts/imported-collection-support.rb:175](../../scripts/imported-collection-support.rb) The import pipeline does not reject symlinks from untrusted source trees. `FileUtils.cp_r("#{skill_dir}/.", target_skill_dir)` preserves symlinks for skill folders, while asset copying treats symlinked files as regular files because `File.file?` follows symlinks and `FileUtils.cp` copies the target bytes. This can commit repo-local symlinks pointing outside the repo or copy arbitrary local files into `tools/imported`.
  Fix: use `File.lstat` during all source walks; fail on symlinks unless explicitly allowlisted; add validator checks that no generated root skill or `tools/imported` path is a symlink; copy only regular files/directories after containment checks.

- [scripts/validate-generated-skills.rb:50](../../scripts/validate-generated-skills.rb) Validator shares the same selection helpers as the importer (`source_skill_paths`, `external_asset_files`) to compute expected counts and asset lists. If those helpers exclude a valid source path, include a mirror path, or collapse a duplicate incorrectly, validation self-confirms the bug. This weakens the stated contract that final counts are fixed at 842 and external splits are `149/21/68/327`.
  Fix: encode expected source commits and per-collection counts as independent constants or a lockfile; add direct negative scans for excluded hidden/generated mirrors; validate imported manifest paths against the locked inventory rather than recomputing with importer logic.

## Medium Priority

- [scripts/convert-agents-to-skills.rb:98](../../scripts/convert-agents-to-skills.rb) Agency converter slugifies the source filename but never rejects an empty slug before writing. A parseable source file with a punctuation-only basename would write `SKILL.md` and `agents/openai.yaml` at the repo root, corrupting the package before validation fails.
  Fix: reject empty or invalid `base_slug` before line 106; use the same slug validator and target containment helper across all importers.

## Low Priority

- [scripts/readme-writer.rb:23](../../scripts/readme-writer.rb) README generation interpolates manifest `display_name` values into Markdown without escaping. Current generated values are clean, but future untrusted source metadata can break the index or inject misleading links/text.
  Fix: strip newlines/control chars and escape `[` `]` `(` `)` in generated Markdown labels.

## Edge Cases Found by Scout

- Current generated tree has no symlinks under repo root or `tools/imported`.
- Current marketing source skill names match the expected slug regex.
- Claude visible source has duplicate names; current 327 count reflects the existing shallowest-path collapse policy, but validation should lock that policy independently.
- README sample path uses `/tmp/agency-source`; local validation passes with actual checkout `/tmp/agency-agents-source`.

## Positive Observations

- Existing local slugs win via manifest-seeded `used` map before external import.
- Generated contracts line up: `skills-manifest.json`, root skill folders, README links, and marketplace skills all match.
- Imported executable-asset scan passed; copied tool assets are non-executable in current output.
- Source scripts are not executed by the import flow.

## Recommended Actions

1. Add shared `valid_skill_slug!` and `safe_target_path!` helpers; apply before every destructive file operation.
2. Add symlink rejection to copy and validation paths.
3. Split validator oracle from importer logic with locked expected counts, commits, and hidden-path negative checks.
4. Re-run `ruby scripts/validate-generated-skills.rb . /tmp/agency-agents-source /tmp/marketingskills-source /tmp/scientific-agent-skills-source /tmp/baoyu-skills-source /tmp/pm-skills-source /tmp/claude-skills-source`, `claude plugin validate .`, and executable asset scan.

## Metrics

- Type Coverage: N/A Ruby scripts
- Test Coverage: N/A; validation script exists, no unit coverage observed
- Linting Issues: 0 Ruby syntax errors; `git diff --check` clean

## Plan Follow-ups

- Plan tasks appear functionally complete, but `plans/260630-import-external-skill-collections/plan.md` still has `status: pending`.
- Phase 4 needs hardening for false-pass validation, specifically independent expected counts and source inventory lock.

## Unresolved Questions

- Should marketing importer preserve upstream `name` exactly, or should folder basename be the canonical slug when the two disagree?
