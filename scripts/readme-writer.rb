# frozen_string_literal: true

require_relative "skill-paths"

COLLECTION_LABELS = {
  "agency" => "Agency Skills",
  "marketing-skills" => "Marketing Skills",
  "scientific-agent-skills" => "Scientific Agent Skills",
  "baoyu-skills" => "Baoyu Skills",
  "pm-skills" => "PM Skills",
  "claude-skills" => "Claude Skills"
}.freeze

def readme_label(value)
  COLLECTION_LABELS[value] || value.to_s.split("-").map(&:capitalize).join(" ")
end

def markdown_cell(value)
  value.to_s.gsub(/[\r\n\t]/, " ")
       .gsub(/[\\\[\]\(\)]/) { |char| "\\#{char}" }
       .gsub("|", "\\|")
       .gsub(/\s+/, " ")
       .strip
end

def readme_source_commits(manifest)
  manifest.group_by { |item| item.fetch("collection", "agency") }.map do |collection, items|
    commit = items.find { |item| item["source_commit"].to_s != "" }&.fetch("source_commit", nil)
    commit ? "- #{readme_label(collection)}: `#{commit}`" : nil
  end.compact.sort.join("\n")
end

def category_image_path(division)
  "assets/categories/#{division}.png"
end

def readme_index(manifest)
  manifest.group_by { |item| item.fetch("division") }.sort.map do |division, items|
    image = category_image_path(division)
    rows = items.sort_by { |item| item.fetch("display_name").to_s }.map do |item|
      "| [`$#{item.fetch("skill")}`](#{skill_storage_path(item)}/SKILL.md) | #{markdown_cell(item.fetch("display_name"))} |"
    end
    [
      "### #{readme_label(division)} (#{items.length})",
      "",
      "<img src=\"#{image}\" alt=\"#{readme_label(division)} category banner\" width=\"100%\">",
      "",
      "| Skill | Name |",
      "| --- | --- |",
      rows.join("\n")
    ].join("\n")
  end.join("\n\n")
end

def write_agency_skills_readme(target_dir, manifest)
  File.write(File.join(target_dir, "README.md"), <<~MD)
    <p align="center">
      <img src="assets/agency-skills-banner.png" alt="Agency Skills banner" width="100%">
    </p>

    # Agency Skills

    This repository packages specialist agent, marketing, product, scientific, and engineering workflows as Codex-compatible skills. Skills live under `skills/<group>/<skill>/`. Each skill folder has:
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
    Use $pi-agent to configure a terminal coding harness.
    ```

    ## Claude Code Plugin Marketplace

    This repo ships an Anthropic Claude Code plugin marketplace catalog at `.claude-plugin/marketplace.json`.

    ```text
    /plugin marketplace add https://github.com/bestagentkits/agency-skills.git
    /plugin install agency-skills@agency-skills
    ```

    The marketplace entry uses `strict: false` with an explicit `skills` list, so the manifest paths are the single source of truth.

    ## Imported Tools

    Marketing integration guides and zero-dependency Node.js CLIs are available under `tools/`.

    - `tools/REGISTRY.md` indexes marketing tool capabilities by category.
    - `tools/integrations/` contains API and workflow guides.
    - `tools/clis/` contains standalone Node.js CLI adapters imported as non-executable assets. Run selected tools with `node tools/clis/<tool>.js ...` after reviewing their operation and credentials.
    - `tools/imported/` preserves commands, agents, scripts, packages, docs, plugin metadata, and other supporting assets from imported collections as non-executable reference files.

    ## Source Conversion

    The conversion is reproducible from local checkouts of the source corpora:

    ```bash
    AGENCY_SOURCE=/tmp/agency-source
    MARKETING_SOURCE=/tmp/marketingskills-source
    SCIENTIFIC_SOURCE=/tmp/scientific-agent-skills-source
    BAOYU_SOURCE=/tmp/baoyu-skills-source
    PM_SOURCE=/tmp/pm-skills-source
    CLAUDE_SKILLS_SOURCE=/tmp/claude-skills-source
    ruby scripts/convert-agents-to-skills.rb "$AGENCY_SOURCE" .
    ruby scripts/import-marketing-skills.rb "$MARKETING_SOURCE" .
    ruby scripts/import-external-skill-collections.rb . "$SCIENTIFIC_SOURCE" "$BAOYU_SOURCE" "$PM_SOURCE" "$CLAUDE_SKILLS_SOURCE"
    ruby scripts/generate-category-banners.rb .
    ruby scripts/generate-plugin-marketplace.rb .
    ruby scripts/validate-generated-skills.rb . "$AGENCY_SOURCE" "$MARKETING_SOURCE" "$SCIENTIFIC_SOURCE" "$BAOYU_SOURCE" "$PM_SOURCE" "$CLAUDE_SKILLS_SOURCE"
    ```

    Importers preserve full skill folders under `skills/<group>/` and add `agents/openai.yaml`. Incoming slug collisions are namespaced so existing local skills are not overwritten. Imported scripts and CLIs are stored as non-executable assets.

    ## Skills Catalog

    Total skills: **#{manifest.length}**.

    #{readme_index(manifest)}

    ## License

    Original skill and tool content retains its source license and attribution. See [LICENSE](LICENSE).

    Packaging scripts and the generated banner in this repository are provided under MIT unless otherwise noted.
  MD
end
