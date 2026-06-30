# Convert Agency Agents To Skills

## Context
- Source: `https://github.com/msitarzewski/agency-agents`
- Source HEAD: `24485830cd4b3c63a4a357b0664d9dedbab9653a`
- Target repo: `bestagentkits/agency-skills`
- Agent count: 232 canonical source agent files in divisions from `divisions.json`

## Phases

1. Inventory source agents
   - Status: complete
   - Confirm agent files by frontmatter, not folder guesses.

2. Convert agents into skills
   - Status: complete
   - Create one top-level skill folder per agent slug.
   - Generate `SKILL.md` with Codex-compatible frontmatter.
   - Generate `agents/openai.yaml` for UI metadata.
   - Preserve original agent body and metadata.

3. Add repo documentation
   - Status: complete
   - Create README with banner, install instructions, source attribution, and full skill index.
   - Copy MIT license from source.

4. Add banner asset
   - Status: complete
   - Generate 5:2 image with visible text `Agency Skills`.
   - Save under `assets/` and embed in README.

5. Validate
   - Status: complete
   - Run converter checks.
   - Validate skill frontmatter and generated UI metadata.
   - Check README references and final file counts.

6. Publish
   - Status: complete
   - Initialize git repository.
   - Create public GitHub repo `bestagentkits/agency-skills`.
   - Commit and push.

## Success Criteria
- 232 source agents become 232 skill folders.
- Each skill has valid `SKILL.md` frontmatter with lowercase hyphenated name.
- Each skill has `agents/openai.yaml`.
- README embeds the 5:2 banner and lists generated skills.
- GitHub repo is public and pushed.

## Docs Impact
- Major: this creates the repo README and conversion documentation.

## Unresolved Questions
- None.
