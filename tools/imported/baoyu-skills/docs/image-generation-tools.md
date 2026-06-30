# Image Generation Tools

Skills in this repo are loaded by multiple agent runtimes (Claude Code, Codex, Cursor, Hermes, other agents, bare CLI). Each runtime exposes a different image-generation capability — some have a runtime-native tool (Codex `imagegen`, Cursor `GenerateImage`, Hermes `image_generate`), others rely on an installed skill (`baoyu-image-gen`, or user-defined). This document defines the canonical **backend-selection rule** every skill that renders images follows so skills stay portable.

## The Rule

When a skill needs to render an image, resolve the backend in this order:

1. **Current-request override** — if the user names a specific backend in the current message, use it.
2. **Saved preference** — if the skill's `EXTEND.md` sets `preferred_image_backend` to a backend available right now, use it.
3. **Auto-select** (when the preference is `auto`, unset, or the pinned backend isn't available):
   - **Codex (`imagegen`)** — first, inspect your available-skills / tool inventory. If a skill named `imagegen` is listed, you are running inside Codex and MUST use it: invoke via the `Skill` tool with `skill: "imagegen"`, passing the saved prompt file's content (plus output path and aspect ratio per Codex `imagegen`'s own args). Codex `imagegen` is the official raster backend in that runtime and outranks any non-native skill (e.g., `baoyu-image-gen`) unless the user has explicitly pinned a different `preferred_image_backend`.
   - **Cursor (`GenerateImage`)** — if the runtime exposes a native `GenerateImage` tool, you are running inside Cursor and it outranks any non-native skill the same way Codex `imagegen` does. Two hard caveats: (a) it has no aspect-ratio parameter — state the target aspect ratio / dimensions explicitly in the prompt text passed as `description`; (b) it does not accept an output directory — it saves to a tool-managed location, so after generation copy/move the file to the skill's expected output path (e.g., `outputs/.../NN-xxx.png`). Reference images go in `reference_image_paths`.
   - **Other runtime-native tools** — if the runtime exposes a different native image tool (e.g., Hermes `image_generate`), use it the same way.
   - Otherwise, if exactly one non-native backend is installed (e.g., `baoyu-image-gen`), use it.
   - Otherwise (multiple non-native backends with no runtime-native tool), ask the user once — batch with any other initial questions.
4. **If none are available**, tell the user and ask how to proceed.

**⛔ Never substitute SVG, HTML, canvas, or other code-based rendering for raster image generation.** Codex `imagegen`'s own description says it should be used "when the output should be a bitmap asset rather than repo-native code or vector." If you cannot resolve a raster backend via step 3, fall through to step 4 and ask the user — do **not** silently emit SVG, write inline `<svg>` markup, or produce HTML/CSS art as a substitute. This applies even if the article/section seems "diagram-like": the consumer skill calling this rule has already decided that a raster image is what it needs.

Setting `preferred_image_backend: ask` forces the step-3 prompt every run regardless of available backends.

## The Preference Field

Each image-consuming skill's `EXTEND.md` carries a single `preferred_image_backend` field:

| Value | Meaning |
|---|---|
| `auto` (default) | Apply the auto-select rule — runtime-native preferred, fall back to only installed backend, ask if multiple non-native. |
| `ask` | Always confirm the backend on every run, even when a runtime-native tool exists. |
| `<backend-id>` (e.g., `codex-imagegen`, `baoyu-image-gen`, `GenerateImage`, `image_generate`) | Pin this backend when available; fall back to `auto` if it isn't. |

The field is **absent-equals-auto**: older `EXTEND.md` files without this field behave exactly as if `preferred_image_backend: auto` were set. No schema version bump is needed to introduce it.

## Prompt File Requirement (hard)

Regardless of which backend is chosen, every skill that renders images MUST write each image's full, final prompt to a standalone file under `prompts/` (naming: `NN-{type}-[slug].md`) BEFORE invoking any backend. The backend receives the prompt file (or its content); the file is the reproducibility record and allows switching backends without regenerating prompts.

## How Skills Declare This

Each `SKILL.md` that renders images includes **exactly one** `## Image Generation Tools` section (near the top, after `## User Input Tools` and before the main workflow) that **inlines** this rule. Skills are self-contained and cannot link to `docs/` — each skill folder must ship the rule inside its own `SKILL.md`. See [CLAUDE.md → Skill Self-Containment](../CLAUDE.md).

Each skill's `references/config/preferences-schema.md` (and its `EXTEND.md` template in `first-time-setup.md`) lists `preferred_image_backend` alongside other preference fields. First-time setup does NOT ask the user about the backend — `auto` is set silently. Users who want to pin a specific backend edit `EXTEND.md` later, and each skill's `## Changing Preferences` section documents the common one-line edits.

Concrete tool names (`imagegen`, `GenerateImage`, `image_generate`, `baoyu-image-gen`) in this document and in SKILL.md are **examples** — agents in other runtimes apply the rule above and substitute the local equivalent. Skill-specific parameters for these backends are illustrative; runtimes without those knobs can omit them.

## Backend Skills Are Exempt

Skills that **are themselves** image-generation backends — currently `baoyu-image-gen`, `baoyu-image-gen` (deprecated), and `baoyu-danger-gemini-web` — do NOT include a `## Image Generation Tools` section. They render directly via their own provider integrations and have no need to "select a backend." The rule applies only to consumer skills that delegate rendering to whatever backend the runtime exposes.
