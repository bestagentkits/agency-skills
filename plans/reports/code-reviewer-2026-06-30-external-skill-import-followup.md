# External Skill Import Follow-up Review

## Scope

Re-checked only prior findings from `code-reviewer-2026-06-30-external-skill-import.md`.

## Result

Not fully resolved. Most prior findings are fixed, but the symlink trust-boundary blocker remains partially open.

## Prior Findings

- RESOLVED: Marketing importer no longer trusts frontmatter `name` as the filesystem slug. It derives slug from source folder, validates it, requires frontmatter name match, and uses `safe_target_path!` before `rm_rf` (`scripts/import-marketing-skills.rb:92-103`).
- PARTIAL: Symlink rejection added, but `reject_symlinks!` does not reject when the path passed to it is itself a symlinked directory. It only checks children from `Dir.glob(root/**/**)` and skips `File.lstat(root)` for directories (`scripts/imported-collection-support.rb:143-149`). Repro command returned `not rejected` for a symlinked directory root. This still allows an untrusted source to expose external directory contents through `source_skill_dir` or `source_tools`.
- RESOLVED: Validator now uses locked expected counts and source commits (`scripts/imported-collection-support.rb:38-52`, `scripts/validate-generated-skills.rb:13-16`, `scripts/validate-generated-skills.rb:49-53`).
- RESOLVED: Agency converter rejects invalid/empty slugs before writing (`scripts/convert-agents-to-skills.rb:41-44`, `scripts/convert-agents-to-skills.rb:103-111`).
- RESOLVED: README display text is escaped for generated Markdown (`scripts/readme-writer.rb:16-20`, `scripts/readme-writer.rb:30-34`).

## Verification

- Ruby syntax checks: pass.
- Full generated validation: pass, `Validated 842 generated and imported skills.`
- Claude plugin validate: pass.
- `git diff --check`: pass.
- Forbidden README/marketplace string scan: pass.
- Current generated tree symlink/executable scan: no paths returned.

## Required Fix

Update `reject_symlinks!` to check `File.lstat(root).symlink?` before deciding whether to glob children. Then rerun the same validation commands.

## Unresolved Questions

- None.

## Final Focused Follow-up

Prior blocker resolved. `reject_symlinks!` now checks `File.lstat(root).symlink?` before globbing children (`scripts/imported-collection-support.rb:91-97`). The previous root-symlink repro now fails closed with `refusing to import symlink .../link`.

Verification passed: Ruby syntax checks, full `validate-generated-skills` (`Validated 842 generated and imported skills.`), `claude plugin validate .`, `git diff --check`, and forbidden README/marketplace string scan.

Remaining blockers: none.
