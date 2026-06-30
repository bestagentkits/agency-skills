# frozen_string_literal: true

def marketing_readme_index(manifest)
  labels = { "marketing-skills" => "Marketing Skills" }
  manifest.group_by { |item| item.fetch("division") }.sort.map do |division, items|
    label = labels[division] || division.split("-").map(&:capitalize).join(" ")
    rows = items.sort_by { |item| item.fetch("display_name").to_s }.map do |item|
      "- [`$#{item.fetch("skill")}`](#{item.fetch("skill")}/SKILL.md) - #{item.fetch("display_name")}"
    end
    ["### #{label}", "", rows.join("\n")].join("\n")
  end.join("\n\n")
end

def write_marketing_import_readme(target_dir, manifest, source_head)
  File.write(File.join(target_dir, "README.md"), <<~MD)
    <p align="center">
      <img src="assets/agency-skills-banner.png" alt="Agency Skills banner" width="100%">
    </p>

    # Agency Skills

    Codex skills converted at source commit `24485830cd4b3c63a4a357b0664d9dedbab9653a` and marketing source commit `#{source_head}`.
    This repository packages specialist agent and marketing workflows as Codex-compatible skills. Each skill folder has:
    - `SKILL.md` containing Codex skill frontmatter and specialist instructions
    - `agents/openai.yaml` containing UI metadata for skill lists and default prompts

    ## Install

    Clone this repository into a Codex skills directory or copy selected skill folders into your existing skills path.

    ```bash
    git clone https://github.com/bestagentkits/agency-skills.git
    ```

    To use a skill, invoke it by name in Codex, for example:

    ```text
    Use $engineering-backend-architect to review this API design.
    Use $copywriting to improve this landing page headline.
    ```

    ## Claude Code Plugin Marketplace

    This repo ships an Anthropic Claude Code plugin marketplace catalog at `.claude-plugin/marketplace.json`.

    ```text
    /plugin marketplace add https://github.com/bestagentkits/agency-skills.git
    /plugin install agency-skills@agency-skills
    ```

    The marketplace entry uses `strict: false` with an explicit `skills` list, so the root skill folders are the single source of truth.

    ## Marketing Tools

    Marketing integration guides and zero-dependency Node.js CLIs are available under `tools/`.

    - `tools/REGISTRY.md` indexes tool capabilities by category.
    - `tools/integrations/` contains API and workflow guides.
    - `tools/clis/` contains standalone Node.js CLI adapters imported as non-executable assets. Run selected tools with `node tools/clis/<tool>.js ...` after reviewing their operation and credentials.

    ## Source Conversion

    The conversion is reproducible from local checkouts of the source corpora:

    ```bash
    AGENCY_SOURCE=/tmp/agency-source
    MARKETING_SOURCE=/tmp/marketingskills-source
    ruby scripts/convert-agents-to-skills.rb "$AGENCY_SOURCE" .
    ruby scripts/import-marketing-skills.rb "$MARKETING_SOURCE" .
    ruby scripts/generate-plugin-marketplace.rb .
    ruby scripts/validate-generated-skills.rb . "$AGENCY_SOURCE" "$MARKETING_SOURCE"
    ```

    The agency converter selects Markdown files with source frontmatter containing both `name` and `description` from canonical source divisions in `divisions.json`. The marketing importer preserves full skill folders, references, eval files, and the `tools/` catalog.

    ## Skill Index

    #{marketing_readme_index(manifest)}

    ## License

    Original skill and tool content is licensed under MIT. See [LICENSE](LICENSE).

    Converted content retains its original attribution. Packaging scripts and the generated banner in this repository are provided under the same MIT license unless otherwise noted.
  MD
end
