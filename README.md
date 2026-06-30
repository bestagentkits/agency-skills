<p align="center">
  <img src="assets/agency-skills-banner.png" alt="Agency Skills banner" width="100%">
</p>

# Agency Skills

This repository packages specialist agent, marketing, product, scientific, and engineering workflows as Codex-compatible skills. Each skill folder has:
- `SKILL.md` containing Codex skill frontmatter and specialist instructions
- `agents/openai.yaml` containing UI metadata for skill lists and default prompts

Source commits:
- Agency Skills: `24485830cd4b3c63a4a357b0664d9dedbab9653a`
- Baoyu Skills: `c9a50cc908d0473f5d754efdbe08cbe387714f63`
- Claude Skills: `4a3c05b69e64f4925f7fc65c88890f614f79caf0`
- Marketing Skills: `8bfcdffb655f16e713940cd04fb08891899c47db`
- PM Skills: `a0cd730d4c61e519ca8568b172334402257a74a9`
- Scientific Agent Skills: `0807ddbc5ceae9c76162198b6909c63d88a1e38a`

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

The marketplace entry uses `strict: false` with an explicit `skills` list, so the root skill folders are the single source of truth.

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
ruby scripts/generate-plugin-marketplace.rb .
ruby scripts/validate-generated-skills.rb . "$AGENCY_SOURCE" "$MARKETING_SOURCE" "$SCIENTIFIC_SOURCE" "$BAOYU_SOURCE" "$PM_SOURCE" "$CLAUDE_SKILLS_SOURCE"
```

Importers preserve full skill folders and add `agents/openai.yaml`. Incoming slug collisions are namespaced so existing local skills are not overwritten. Imported scripts and CLIs are stored as non-executable assets.

## Skill Index

### Academic

- [`$academic-anthropologist`](academic-anthropologist/SKILL.md) - Anthropologist
- [`$academic-geographer`](academic-geographer/SKILL.md) - Geographer
- [`$academic-historian`](academic-historian/SKILL.md) - Historian
- [`$academic-narratologist`](academic-narratologist/SKILL.md) - Narratologist
- [`$academic-psychologist`](academic-psychologist/SKILL.md) - Psychologist

### Baoyu Skills

- [`$baoyu-article-illustrator`](baoyu-article-illustrator/SKILL.md) - Baoyu Article Illustrator
- [`$baoyu-comic`](baoyu-comic/SKILL.md) - Baoyu Comic
- [`$baoyu-compress-image`](baoyu-compress-image/SKILL.md) - Baoyu Compress Image
- [`$baoyu-cover-image`](baoyu-cover-image/SKILL.md) - Baoyu Cover Image
- [`$baoyu-danger-gemini-web`](baoyu-danger-gemini-web/SKILL.md) - Baoyu Danger Gemini Web
- [`$baoyu-danger-x-to-markdown`](baoyu-danger-x-to-markdown/SKILL.md) - Baoyu Danger X To Markdown
- [`$baoyu-diagram`](baoyu-diagram/SKILL.md) - Baoyu Diagram
- [`$baoyu-electron-extract`](baoyu-electron-extract/SKILL.md) - Baoyu Electron Extract
- [`$baoyu-format-markdown`](baoyu-format-markdown/SKILL.md) - Baoyu Format Markdown
- [`$baoyu-image-gen`](baoyu-image-gen/SKILL.md) - Baoyu Image Gen
- [`$baoyu-infographic`](baoyu-infographic/SKILL.md) - Baoyu Infographic
- [`$baoyu-markdown-to-html`](baoyu-markdown-to-html/SKILL.md) - Baoyu Markdown To Html
- [`$baoyu-post-to-wechat`](baoyu-post-to-wechat/SKILL.md) - Baoyu Post To Wechat
- [`$baoyu-post-to-weibo`](baoyu-post-to-weibo/SKILL.md) - Baoyu Post To Weibo
- [`$baoyu-post-to-x`](baoyu-post-to-x/SKILL.md) - Baoyu Post To X
- [`$baoyu-slide-deck`](baoyu-slide-deck/SKILL.md) - Baoyu Slide Deck
- [`$baoyu-translate`](baoyu-translate/SKILL.md) - Baoyu Translate
- [`$baoyu-url-to-markdown`](baoyu-url-to-markdown/SKILL.md) - Baoyu Url To Markdown
- [`$baoyu-wechat-summary`](baoyu-wechat-summary/SKILL.md) - Baoyu Wechat Summary
- [`$baoyu-xhs-images`](baoyu-xhs-images/SKILL.md) - Baoyu Xhs Images
- [`$baoyu-youtube-transcript`](baoyu-youtube-transcript/SKILL.md) - Baoyu Youtube Transcript

### Claude Skills

- [`$a11y-audit`](a11y-audit/SKILL.md) - A11y Audit
- [`$ab-test-setup`](ab-test-setup/SKILL.md) - Ab Test Setup
- [`$claude-skills-marketing-skill-ad-creative-ad-creative`](claude-skills-marketing-skill-ad-creative-ad-creative/SKILL.md) - Ad Creative
- [`$adversarial-reviewer`](adversarial-reviewer/SKILL.md) - Adversarial Reviewer
- [`$aeo`](aeo/SKILL.md) - Aeo
- [`$agent-designer`](agent-designer/SKILL.md) - Agent Designer
- [`$agent-protocol`](agent-protocol/SKILL.md) - Agent Protocol
- [`$agent-workflow-designer`](agent-workflow-designer/SKILL.md) - Agent Workflow Designer
- [`$agenthub`](agenthub/SKILL.md) - Agenthub
- [`$agile-product-owner`](agile-product-owner/SKILL.md) - Agile Product Owner
- [`$ai-act-readiness`](ai-act-readiness/SKILL.md) - Ai Act Readiness
- [`$ai-security`](ai-security/SKILL.md) - Ai Security
- [`$aims-audit`](aims-audit/SKILL.md) - Aims Audit
- [`$analytics-tracking`](analytics-tracking/SKILL.md) - Analytics Tracking
- [`$andreessen`](andreessen/SKILL.md) - Andreessen
- [`$api-design-reviewer`](api-design-reviewer/SKILL.md) - Api Design Reviewer
- [`$api-test-suite-builder`](api-test-suite-builder/SKILL.md) - Api Test Suite Builder
- [`$app-store-optimization`](app-store-optimization/SKILL.md) - App Store Optimization
- [`$apple-hig-expert`](apple-hig-expert/SKILL.md) - Apple Hig Expert
- [`$atlassian-admin`](atlassian-admin/SKILL.md) - Atlassian Admin
- [`$atlassian-templates`](atlassian-templates/SKILL.md) - Atlassian Templates
- [`$autoresearch-agent`](autoresearch-agent/SKILL.md) - Autoresearch Agent
- [`$aws-solution-architect`](aws-solution-architect/SKILL.md) - Aws Solution Architect
- [`$azure-cloud-architect`](azure-cloud-architect/SKILL.md) - Azure Cloud Architect
- [`$behuman`](behuman/SKILL.md) - Behuman
- [`$board`](board/SKILL.md) - Board
- [`$board-deck-builder`](board-deck-builder/SKILL.md) - Board Deck Builder
- [`$board-meeting`](board-meeting/SKILL.md) - Board Meeting
- [`$board-prep`](board-prep/SKILL.md) - Board Prep
- [`$boardroom`](boardroom/SKILL.md) - Boardroom
- [`$brand-guidelines`](brand-guidelines/SKILL.md) - Brand Guidelines
- [`$brief`](brief/SKILL.md) - Brief
- [`$browser-automation`](browser-automation/SKILL.md) - Browser Automation
- [`$browserstack`](browserstack/SKILL.md) - Browserstack
- [`$business-growth-skills`](business-growth-skills/SKILL.md) - Business Growth Skills
- [`$business-investment-advisor`](business-investment-advisor/SKILL.md) - Business Investment Advisor
- [`$business-operations-skills`](business-operations-skills/SKILL.md) - Business Operations Skills
- [`$c-level-agents`](c-level-agents/SKILL.md) - C Level Agents
- [`$c-level-skills`](c-level-skills/SKILL.md) - C Level Skills
- [`$caio-review`](caio-review/SKILL.md) - Caio Review
- [`$campaign-analytics`](campaign-analytics/SKILL.md) - Campaign Analytics
- [`$capa-officer`](capa-officer/SKILL.md) - Capa Officer
- [`$capacity-planner`](capacity-planner/SKILL.md) - Capacity Planner
- [`$capture`](capture/SKILL.md) - Capture
- [`$caveman`](caveman/SKILL.md) - Caveman
- [`$cco-review`](cco-review/SKILL.md) - Cco Review
- [`$cdo-review`](cdo-review/SKILL.md) - Cdo Review
- [`$ceo-advisor`](ceo-advisor/SKILL.md) - Ceo Advisor
- [`$cfo-advisor`](cfo-advisor/SKILL.md) - Cfo Advisor
- [`$cfo-review`](cfo-review/SKILL.md) - Cfo Review
- [`$challenge`](challenge/SKILL.md) - Challenge
- [`$change-management`](change-management/SKILL.md) - Change Management
- [`$changelog-generator`](changelog-generator/SKILL.md) - Changelog Generator
- [`$channel-economics`](channel-economics/SKILL.md) - Channel Economics
- [`$chaos-engineering`](chaos-engineering/SKILL.md) - Chaos Engineering
- [`$chief-ai-officer-advisor`](chief-ai-officer-advisor/SKILL.md) - Chief Ai Officer Advisor
- [`$chief-customer-officer-advisor`](chief-customer-officer-advisor/SKILL.md) - Chief Customer Officer Advisor
- [`$chief-data-officer-advisor`](chief-data-officer-advisor/SKILL.md) - Chief Data Officer Advisor
- [`$chief-of-staff`](chief-of-staff/SKILL.md) - Chief Of Staff
- [`$chro-advisor`](chro-advisor/SKILL.md) - Chro Advisor
- [`$claude-skills-marketing-skill-churn-prevention-churn-prevention`](claude-skills-marketing-skill-churn-prevention-churn-prevention/SKILL.md) - Churn Prevention
- [`$ci-cd-pipeline-builder`](ci-cd-pipeline-builder/SKILL.md) - Ci Cd Pipeline Builder
- [`$ciso-advisor`](ciso-advisor/SKILL.md) - Ciso Advisor
- [`$ciso-review`](ciso-review/SKILL.md) - Ciso Review
- [`$claude-coach`](claude-coach/SKILL.md) - Claude Coach
- [`$clinical-research`](clinical-research/SKILL.md) - Clinical Research
- [`$cloud-security`](cloud-security/SKILL.md) - Cloud Security
- [`$cmo-advisor`](cmo-advisor/SKILL.md) - Cmo Advisor
- [`$cmo-review`](cmo-review/SKILL.md) - Cmo Review
- [`$code-reviewer`](code-reviewer/SKILL.md) - Code Reviewer
- [`$code-to-prd`](code-to-prd/SKILL.md) - Code To Prd
- [`$code-tour`](code-tour/SKILL.md) - Code Tour
- [`$codebase-onboarding`](codebase-onboarding/SKILL.md) - Codebase Onboarding
- [`$claude-skills-marketing-skill-cold-email-cold-email`](claude-skills-marketing-skill-cold-email-cold-email/SKILL.md) - Cold Email
- [`$collab-proof`](collab-proof/SKILL.md) - Collab Proof
- [`$commercial-forecaster`](commercial-forecaster/SKILL.md) - Commercial Forecaster
- [`$commercial-policy`](commercial-policy/SKILL.md) - Commercial Policy
- [`$commercial-skills`](commercial-skills/SKILL.md) - Commercial Skills
- [`$company-os`](company-os/SKILL.md) - Company Os
- [`$competitive-intel`](competitive-intel/SKILL.md) - Competitive Intel
- [`$competitive-teardown`](competitive-teardown/SKILL.md) - Competitive Teardown
- [`$competitor-alternatives`](competitor-alternatives/SKILL.md) - Competitor Alternatives
- [`$compliance-os`](compliance-os/SKILL.md) - Compliance Os
- [`$compliance-readiness`](compliance-readiness/SKILL.md) - Compliance Readiness
- [`$confluence-expert`](confluence-expert/SKILL.md) - Confluence Expert
- [`$content-creator`](content-creator/SKILL.md) - Content Creator
- [`$content-humanizer`](content-humanizer/SKILL.md) - Content Humanizer
- [`$content-production`](content-production/SKILL.md) - Content Production
- [`$claude-skills-marketing-skill-content-strategy-content-strategy`](claude-skills-marketing-skill-content-strategy-content-strategy/SKILL.md) - Content Strategy
- [`$context-engine`](context-engine/SKILL.md) - Context Engine
- [`$contract-and-proposal-writer`](contract-and-proposal-writer/SKILL.md) - Contract And Proposal Writer
- [`$coo-advisor`](coo-advisor/SKILL.md) - Coo Advisor
- [`$claude-skills-marketing-skill-copy-editing-copy-editing`](claude-skills-marketing-skill-copy-editing-copy-editing/SKILL.md) - Copy Editing
- [`$claude-skills-marketing-skill-copywriting-copywriting`](claude-skills-marketing-skill-copywriting-copywriting/SKILL.md) - Copywriting
- [`$coverage`](coverage/SKILL.md) - Coverage
- [`$cpo-advisor`](cpo-advisor/SKILL.md) - Cpo Advisor
- [`$cpo-review`](cpo-review/SKILL.md) - Cpo Review
- [`$cro-advisor`](cro-advisor/SKILL.md) - Cro Advisor
- [`$cro-review`](cro-review/SKILL.md) - Cro Review
- [`$cross-eval`](cross-eval/SKILL.md) - Cross Eval
- [`$cs-onboard`](cs-onboard/SKILL.md) - Cs Onboard
- [`$cto-advisor`](cto-advisor/SKILL.md) - Cto Advisor
- [`$cto-review`](cto-review/SKILL.md) - Cto Review
- [`$culture-architect`](culture-architect/SKILL.md) - Culture Architect
- [`$claude-skills-business-growth-customer-success-manager-customer-success-manager`](claude-skills-business-growth-customer-success-manager-customer-success-manager/SKILL.md) - Customer Success Manager
- [`$data-quality-auditor`](data-quality-auditor/SKILL.md) - Data Quality Auditor
- [`$database-designer`](database-designer/SKILL.md) - Database Designer
- [`$database-schema-designer`](database-schema-designer/SKILL.md) - Database Schema Designer
- [`$deal-desk`](deal-desk/SKILL.md) - Deal Desk
- [`$decide`](decide/SKILL.md) - Decide
- [`$decision-logger`](decision-logger/SKILL.md) - Decision Logger
- [`$demo-video`](demo-video/SKILL.md) - Demo Video
- [`$dependency-auditor`](dependency-auditor/SKILL.md) - Dependency Auditor
- [`$design-system`](design-system/SKILL.md) - Design System
- [`$docker-development`](docker-development/SKILL.md) - Docker Development
- [`$dossier`](dossier/SKILL.md) - Dossier
- [`$email-sequence`](email-sequence/SKILL.md) - Email Sequence
- [`$email-template-builder`](email-template-builder/SKILL.md) - Email Template Builder
- [`$engineering-advanced-skills`](engineering-advanced-skills/SKILL.md) - Engineering Advanced Skills
- [`$engineering-skills`](engineering-skills/SKILL.md) - Engineering Skills
- [`$env-secrets-manager`](env-secrets-manager/SKILL.md) - Env Secrets Manager
- [`$epic-design`](epic-design/SKILL.md) - Epic Design
- [`$eu-ai-act-specialist`](eu-ai-act-specialist/SKILL.md) - Eu Ai Act Specialist
- [`$eval`](eval/SKILL.md) - Eval
- [`$execute`](execute/SKILL.md) - Execute
- [`$executive-mentor`](executive-mentor/SKILL.md) - Executive Mentor
- [`$experiment-designer`](experiment-designer/SKILL.md) - Experiment Designer
- [`$extract`](extract/SKILL.md) - Extract
- [`$fda-consultant-specialist`](fda-consultant-specialist/SKILL.md) - Fda Consultant Specialist
- [`$fda-qsr-audit-prep`](fda-qsr-audit-prep/SKILL.md) - Fda Qsr Audit Prep
- [`$feature-flags-architect`](feature-flags-architect/SKILL.md) - Feature Flags Architect
- [`$finance-skills`](finance-skills/SKILL.md) - Finance Skills
- [`$financial-analyst`](financial-analyst/SKILL.md) - Financial Analyst
- [`$fix`](fix/SKILL.md) - Fix
- [`$focused-fix`](focused-fix/SKILL.md) - Focused Fix
- [`$form-cro`](form-cro/SKILL.md) - Form Cro
- [`$founder-coach`](founder-coach/SKILL.md) - Founder Coach
- [`$founder-mode`](founder-mode/SKILL.md) - Founder Mode
- [`$free-tool-strategy`](free-tool-strategy/SKILL.md) - Free Tool Strategy
- [`$freeze`](freeze/SKILL.md) - Freeze
- [`$full-page-screenshot`](full-page-screenshot/SKILL.md) - Full Page Screenshot
- [`$gc-review`](gc-review/SKILL.md) - Gc Review
- [`$gcp-cloud-architect`](gcp-cloud-architect/SKILL.md) - Gcp Cloud Architect
- [`$gdpr-audit-prep`](gdpr-audit-prep/SKILL.md) - Gdpr Audit Prep
- [`$gdpr-dsgvo-expert`](gdpr-dsgvo-expert/SKILL.md) - Gdpr Dsgvo Expert
- [`$general-counsel-advisor`](general-counsel-advisor/SKILL.md) - General Counsel Advisor
- [`$generate`](generate/SKILL.md) - Generate
- [`$git-worktree-manager`](git-worktree-manager/SKILL.md) - Git Worktree Manager
- [`$google-workspace-cli`](google-workspace-cli/SKILL.md) - Google Workspace Cli
- [`$grants`](grants/SKILL.md) - Grants
- [`$grill-me`](grill-me/SKILL.md) - Grill Me
- [`$grill-with-docs`](grill-with-docs/SKILL.md) - Grill With Docs
- [`$handoff`](handoff/SKILL.md) - Handoff
- [`$hard-call`](hard-call/SKILL.md) - Hard Call
- [`$helm-chart-builder`](helm-chart-builder/SKILL.md) - Helm Chart Builder
- [`$inbox-setup`](inbox-setup/SKILL.md) - Inbox Setup
- [`$inbox-triage`](inbox-triage/SKILL.md) - Inbox Triage
- [`$incident-commander`](incident-commander/SKILL.md) - Incident Commander
- [`$incident-response`](incident-response/SKILL.md) - Incident Response
- [`$information-security-manager-iso27001`](information-security-manager-iso27001/SKILL.md) - Information Security Manager Iso27001
- [`$init`](init/SKILL.md) - Init
- [`$internal-comms`](internal-comms/SKILL.md) - Internal Comms
- [`$internal-narrative`](internal-narrative/SKILL.md) - Internal Narrative
- [`$interview-system-designer`](interview-system-designer/SKILL.md) - Interview System Designer
- [`$intl-expansion`](intl-expansion/SKILL.md) - Intl Expansion
- [`$isms-audit-expert`](isms-audit-expert/SKILL.md) - Isms Audit Expert
- [`$iso13485-audit-prep`](iso13485-audit-prep/SKILL.md) - Iso13485 Audit Prep
- [`$iso27001-audit-prep`](iso27001-audit-prep/SKILL.md) - Iso27001 Audit Prep
- [`$iso42001-specialist`](iso42001-specialist/SKILL.md) - Iso42001 Specialist
- [`$jira-expert`](jira-expert/SKILL.md) - Jira Expert
- [`$karpathy-coder`](karpathy-coder/SKILL.md) - Karpathy Coder
- [`$knowledge-ops`](knowledge-ops/SKILL.md) - Knowledge Ops
- [`$kubernetes-operator`](kubernetes-operator/SKILL.md) - Kubernetes Operator
- [`$landing`](landing/SKILL.md) - Landing
- [`$landing-page-generator`](landing-page-generator/SKILL.md) - Landing Page Generator
- [`$launch-strategy`](launch-strategy/SKILL.md) - Launch Strategy
- [`$litreview`](litreview/SKILL.md) - Litreview
- [`$llm-cost-optimizer`](llm-cost-optimizer/SKILL.md) - Llm Cost Optimizer
- [`$llm-wiki`](llm-wiki/SKILL.md) - Llm Wiki
- [`$loop`](loop/SKILL.md) - Loop
- [`$ma-playbook`](ma-playbook/SKILL.md) - Ma Playbook
- [`$markdown-html-orchestrator`](markdown-html-orchestrator/SKILL.md) - Markdown Html Orchestrator
- [`$market-research`](market-research/SKILL.md) - Market Research
- [`$marketing-context`](marketing-context/SKILL.md) - Marketing Context
- [`$marketing-demand-acquisition`](marketing-demand-acquisition/SKILL.md) - Marketing Demand Acquisition
- [`$claude-skills-marketing-skill-marketing-ideas-marketing-ideas`](claude-skills-marketing-skill-marketing-ideas-marketing-ideas/SKILL.md) - Marketing Ideas
- [`$marketing-ops`](marketing-ops/SKILL.md) - Marketing Ops
- [`$claude-skills-marketing-skill-marketing-psychology-marketing-psychology`](claude-skills-marketing-skill-marketing-psychology-marketing-psychology/SKILL.md) - Marketing Psychology
- [`$marketing-skills`](marketing-skills/SKILL.md) - Marketing Skills
- [`$marketing-strategy-pmm`](marketing-strategy-pmm/SKILL.md) - Marketing Strategy Pmm
- [`$mcp-server-builder`](mcp-server-builder/SKILL.md) - Mcp Server Builder
- [`$md-document`](md-document/SKILL.md) - Md Document
- [`$md-review`](md-review/SKILL.md) - Md Review
- [`$md-slides`](md-slides/SKILL.md) - Md Slides
- [`$mdr-745-specialist`](mdr-745-specialist/SKILL.md) - Mdr 745 Specialist
- [`$meeting-analyzer`](meeting-analyzer/SKILL.md) - Meeting Analyzer
- [`$merge`](merge/SKILL.md) - Merge
- [`$migrate`](migrate/SKILL.md) - Migrate
- [`$migration-architect`](migration-architect/SKILL.md) - Migration Architect
- [`$monorepo-navigator`](monorepo-navigator/SKILL.md) - Monorepo Navigator
- [`$ms365-tenant-manager`](ms365-tenant-manager/SKILL.md) - Ms365 Tenant Manager
- [`$notebooklm`](notebooklm/SKILL.md) - Notebooklm
- [`$observability-designer`](observability-designer/SKILL.md) - Observability Designer
- [`$office-hours`](office-hours/SKILL.md) - Office Hours
- [`$onboard`](onboard/SKILL.md) - Onboard
- [`$onboarding-cro`](onboarding-cro/SKILL.md) - Onboarding Cro
- [`$org-health-diagnostic`](org-health-diagnostic/SKILL.md) - Org Health Diagnostic
- [`$page-cro`](page-cro/SKILL.md) - Page Cro
- [`$paid-ads`](paid-ads/SKILL.md) - Paid Ads
- [`$partnerships-architect`](partnerships-architect/SKILL.md) - Partnerships Architect
- [`$patent`](patent/SKILL.md) - Patent
- [`$paywall-upgrade-cro`](paywall-upgrade-cro/SKILL.md) - Paywall Upgrade Cro
- [`$performance-profiler`](performance-profiler/SKILL.md) - Performance Profiler
- [`$playwright-pro`](playwright-pro/SKILL.md) - Playwright Pro
- [`$pm-skills`](pm-skills/SKILL.md) - Pm Skills
- [`$popup-cro`](popup-cro/SKILL.md) - Popup Cro
- [`$post-mortem`](post-mortem/SKILL.md) - Post Mortem
- [`$postmortem`](postmortem/SKILL.md) - Postmortem
- [`$pr-review-expert`](pr-review-expert/SKILL.md) - Pr Review Expert
- [`$pricing-strategist`](pricing-strategist/SKILL.md) - Pricing Strategist
- [`$claude-skills-marketing-skill-pricing-strategy-pricing-strategy`](claude-skills-marketing-skill-pricing-strategy-pricing-strategy/SKILL.md) - Pricing Strategy
- [`$process-mapper`](process-mapper/SKILL.md) - Process Mapper
- [`$procurement-optimizer`](procurement-optimizer/SKILL.md) - Procurement Optimizer
- [`$product-analytics`](product-analytics/SKILL.md) - Product Analytics
- [`$product-discovery`](product-discovery/SKILL.md) - Product Discovery
- [`$product-manager-toolkit`](product-manager-toolkit/SKILL.md) - Product Manager Toolkit
- [`$product-research`](product-research/SKILL.md) - Product Research
- [`$product-skills`](product-skills/SKILL.md) - Product Skills
- [`$product-strategist`](product-strategist/SKILL.md) - Product Strategist
- [`$claude-skills-marketing-skill-programmatic-seo-programmatic-seo`](claude-skills-marketing-skill-programmatic-seo-programmatic-seo/SKILL.md) - Programmatic Seo
- [`$promote`](promote/SKILL.md) - Promote
- [`$prompt-engineer-toolkit`](prompt-engineer-toolkit/SKILL.md) - Prompt Engineer Toolkit
- [`$prompt-governance`](prompt-governance/SKILL.md) - Prompt Governance
- [`$pulse`](pulse/SKILL.md) - Pulse
- [`$qms-audit-expert`](qms-audit-expert/SKILL.md) - Qms Audit Expert
- [`$quality-documentation-manager`](quality-documentation-manager/SKILL.md) - Quality Documentation Manager
- [`$quality-manager-qmr`](quality-manager-qmr/SKILL.md) - Quality Manager Qmr
- [`$quality-manager-qms-iso13485`](quality-manager-qms-iso13485/SKILL.md) - Quality Manager Qms Iso13485
- [`$ra-qm-skills`](ra-qm-skills/SKILL.md) - Ra Qm Skills
- [`$rag-architect`](rag-architect/SKILL.md) - Rag Architect
- [`$red-team`](red-team/SKILL.md) - Red Team
- [`$referral-program`](referral-program/SKILL.md) - Referral Program
- [`$reflect`](reflect/SKILL.md) - Reflect
- [`$regulatory-affairs-head`](regulatory-affairs-head/SKILL.md) - Regulatory Affairs Head
- [`$remember`](remember/SKILL.md) - Remember
- [`$report`](report/SKILL.md) - Report
- [`$research`](research/SKILL.md) - Research
- [`$research-finance`](research-finance/SKILL.md) - Research Finance
- [`$research-ops-skills`](research-ops-skills/SKILL.md) - Research Ops Skills
- [`$research-summarizer`](research-summarizer/SKILL.md) - Research Summarizer
- [`$resume`](resume/SKILL.md) - Resume
- [`$revenue-operations`](revenue-operations/SKILL.md) - Revenue Operations
- [`$review`](review/SKILL.md) - Review
- [`$rfp-responder`](rfp-responder/SKILL.md) - Rfp Responder
- [`$risk-management-specialist`](risk-management-specialist/SKILL.md) - Risk Management Specialist
- [`$roadmap-communicator`](roadmap-communicator/SKILL.md) - Roadmap Communicator
- [`$run`](run/SKILL.md) - Run
- [`$runbook-generator`](runbook-generator/SKILL.md) - Runbook Generator
- [`$saas-metrics-coach`](saas-metrics-coach/SKILL.md) - Saas Metrics Coach
- [`$saas-scaffolder`](saas-scaffolder/SKILL.md) - Saas Scaffolder
- [`$claude-skills-business-growth-sales-engineer-sales-engineer`](claude-skills-business-growth-sales-engineer-sales-engineer/SKILL.md) - Sales Engineer
- [`$scenario-war-room`](scenario-war-room/SKILL.md) - Scenario War Room
- [`$schema-markup`](schema-markup/SKILL.md) - Schema Markup
- [`$scrum-master`](scrum-master/SKILL.md) - Scrum Master
- [`$secrets-vault-manager`](secrets-vault-manager/SKILL.md) - Secrets Vault Manager
- [`$security-guidance`](security-guidance/SKILL.md) - Security Guidance
- [`$security-pen-testing`](security-pen-testing/SKILL.md) - Security Pen Testing
- [`$self-eval`](self-eval/SKILL.md) - Self Eval
- [`$self-improving-agent`](self-improving-agent/SKILL.md) - Self Improving Agent
- [`$senior-architect`](senior-architect/SKILL.md) - Senior Architect
- [`$senior-backend`](senior-backend/SKILL.md) - Senior Backend
- [`$senior-computer-vision`](senior-computer-vision/SKILL.md) - Senior Computer Vision
- [`$senior-data-engineer`](senior-data-engineer/SKILL.md) - Senior Data Engineer
- [`$senior-data-scientist`](senior-data-scientist/SKILL.md) - Senior Data Scientist
- [`$senior-devops`](senior-devops/SKILL.md) - Senior Devops
- [`$senior-frontend`](senior-frontend/SKILL.md) - Senior Frontend
- [`$senior-fullstack`](senior-fullstack/SKILL.md) - Senior Fullstack
- [`$senior-ml-engineer`](senior-ml-engineer/SKILL.md) - Senior Ml Engineer
- [`$senior-pm`](senior-pm/SKILL.md) - Senior Pm
- [`$senior-prompt-engineer`](senior-prompt-engineer/SKILL.md) - Senior Prompt Engineer
- [`$senior-qa`](senior-qa/SKILL.md) - Senior Qa
- [`$senior-secops`](senior-secops/SKILL.md) - Senior Secops
- [`$senior-security`](senior-security/SKILL.md) - Senior Security
- [`$claude-skills-marketing-skill-seo-audit-seo-audit`](claude-skills-marketing-skill-seo-audit-seo-audit/SKILL.md) - Seo Audit
- [`$setup`](setup/SKILL.md) - Setup
- [`$ship-gate`](ship-gate/SKILL.md) - Ship Gate
- [`$signup-flow-cro`](signup-flow-cro/SKILL.md) - Signup Flow Cro
- [`$claude-skills-marketing-skill-site-architecture-site-architecture`](claude-skills-marketing-skill-site-architecture-site-architecture/SKILL.md) - Site Architecture
- [`$skill-security-auditor`](skill-security-auditor/SKILL.md) - Skill Security Auditor
- [`$skill-tester`](skill-tester/SKILL.md) - Skill Tester
- [`$slo-architect`](slo-architect/SKILL.md) - Slo Architect
- [`$snowflake-development`](snowflake-development/SKILL.md) - Snowflake Development
- [`$soc2-audit-prep`](soc2-audit-prep/SKILL.md) - Soc2 Audit Prep
- [`$soc2-compliance`](soc2-compliance/SKILL.md) - Soc2 Compliance
- [`$social-content`](social-content/SKILL.md) - Social Content
- [`$social-media-analyzer`](social-media-analyzer/SKILL.md) - Social Media Analyzer
- [`$social-media-manager`](social-media-manager/SKILL.md) - Social Media Manager
- [`$spawn`](spawn/SKILL.md) - Spawn
- [`$spec-driven-workflow`](spec-driven-workflow/SKILL.md) - Spec Driven Workflow
- [`$spec-to-repo`](spec-to-repo/SKILL.md) - Spec To Repo
- [`$sql-database-assistant`](sql-database-assistant/SKILL.md) - Sql Database Assistant
- [`$statistical-analyst`](statistical-analyst/SKILL.md) - Statistical Analyst
- [`$status`](status/SKILL.md) - Status
- [`$strategic-alignment`](strategic-alignment/SKILL.md) - Strategic Alignment
- [`$stress-test`](stress-test/SKILL.md) - Stress Test
- [`$stripe-integration-expert`](stripe-integration-expert/SKILL.md) - Stripe Integration Expert
- [`$syllabus`](syllabus/SKILL.md) - Syllabus
- [`$tc-tracker`](tc-tracker/SKILL.md) - Tc Tracker
- [`$tdd-guide`](tdd-guide/SKILL.md) - Tdd Guide
- [`$team-communications`](team-communications/SKILL.md) - Team Communications
- [`$tech-debt-tracker`](tech-debt-tracker/SKILL.md) - Tech Debt Tracker
- [`$tech-stack-evaluator`](tech-stack-evaluator/SKILL.md) - Tech Stack Evaluator
- [`$terraform-patterns`](terraform-patterns/SKILL.md) - Terraform Patterns
- [`$testrail`](testrail/SKILL.md) - Testrail
- [`$threat-detection`](threat-detection/SKILL.md) - Threat Detection
- [`$ui-design-system`](ui-design-system/SKILL.md) - Ui Design System
- [`$universal-scraping-architect`](universal-scraping-architect/SKILL.md) - Universal Scraping Architect
- [`$ux-researcher-designer`](ux-researcher-designer/SKILL.md) - Ux Researcher Designer
- [`$vendor-management`](vendor-management/SKILL.md) - Vendor Management
- [`$video-content-strategist`](video-content-strategist/SKILL.md) - Video Content Strategist
- [`$vpe-advisor`](vpe-advisor/SKILL.md) - Vpe Advisor
- [`$vpe-review`](vpe-review/SKILL.md) - Vpe Review
- [`$webinar-marketing`](webinar-marketing/SKILL.md) - Webinar Marketing
- [`$workflow-builder`](workflow-builder/SKILL.md) - Workflow Builder
- [`$write-a-skill`](write-a-skill/SKILL.md) - Write A Skill
- [`$x-twitter-growth`](x-twitter-growth/SKILL.md) - X Twitter Growth
- [`$youtube-full`](youtube-full/SKILL.md) - Youtube Full

### Design

- [`$design-brand-guardian`](design-brand-guardian/SKILL.md) - Brand Guardian
- [`$design-image-prompt-engineer`](design-image-prompt-engineer/SKILL.md) - Image Prompt Engineer
- [`$design-inclusive-visuals-specialist`](design-inclusive-visuals-specialist/SKILL.md) - Inclusive Visuals Specialist
- [`$design-persona-walkthrough`](design-persona-walkthrough/SKILL.md) - Persona Walkthrough Specialist
- [`$design-ui-designer`](design-ui-designer/SKILL.md) - UI Designer
- [`$design-ux-architect`](design-ux-architect/SKILL.md) - UX Architect
- [`$design-ux-researcher`](design-ux-researcher/SKILL.md) - UX Researcher
- [`$design-visual-storyteller`](design-visual-storyteller/SKILL.md) - Visual Storyteller
- [`$design-whimsy-injector`](design-whimsy-injector/SKILL.md) - Whimsy Injector

### Engineering

- [`$engineering-ai-data-remediation-engineer`](engineering-ai-data-remediation-engineer/SKILL.md) - AI Data Remediation Engineer
- [`$engineering-ai-engineer`](engineering-ai-engineer/SKILL.md) - AI Engineer
- [`$engineering-autonomous-optimization-architect`](engineering-autonomous-optimization-architect/SKILL.md) - Autonomous Optimization Architect
- [`$engineering-backend-architect`](engineering-backend-architect/SKILL.md) - Backend Architect
- [`$engineering-cms-developer`](engineering-cms-developer/SKILL.md) - CMS Developer
- [`$engineering-code-reviewer`](engineering-code-reviewer/SKILL.md) - Code Reviewer
- [`$engineering-codebase-onboarding-engineer`](engineering-codebase-onboarding-engineer/SKILL.md) - Codebase Onboarding Engineer
- [`$engineering-data-engineer`](engineering-data-engineer/SKILL.md) - Data Engineer
- [`$engineering-database-optimizer`](engineering-database-optimizer/SKILL.md) - Database Optimizer
- [`$engineering-devops-automator`](engineering-devops-automator/SKILL.md) - DevOps Automator
- [`$engineering-drupal-shopping-cart`](engineering-drupal-shopping-cart/SKILL.md) - Drupal Shopping Cart Engineer
- [`$engineering-email-intelligence-engineer`](engineering-email-intelligence-engineer/SKILL.md) - Email Intelligence Engineer
- [`$engineering-embedded-firmware-engineer`](engineering-embedded-firmware-engineer/SKILL.md) - Embedded Firmware Engineer
- [`$engineering-feishu-integration-developer`](engineering-feishu-integration-developer/SKILL.md) - Feishu Integration Developer
- [`$engineering-filament-optimization-specialist`](engineering-filament-optimization-specialist/SKILL.md) - Filament Optimization Specialist
- [`$engineering-frontend-developer`](engineering-frontend-developer/SKILL.md) - Frontend Developer
- [`$engineering-git-workflow-master`](engineering-git-workflow-master/SKILL.md) - Git Workflow Master
- [`$engineering-it-service-manager`](engineering-it-service-manager/SKILL.md) - IT Service Manager
- [`$engineering-incident-response-commander`](engineering-incident-response-commander/SKILL.md) - Incident Response Commander
- [`$engineering-minimal-change-engineer`](engineering-minimal-change-engineer/SKILL.md) - Minimal Change Engineer
- [`$engineering-mobile-app-builder`](engineering-mobile-app-builder/SKILL.md) - Mobile App Builder
- [`$engineering-multi-agent-systems-architect`](engineering-multi-agent-systems-architect/SKILL.md) - Multi-Agent Systems Architect
- [`$engineering-orgscript-engineer`](engineering-orgscript-engineer/SKILL.md) - OrgScript Engineer
- [`$engineering-prompt-engineer`](engineering-prompt-engineer/SKILL.md) - Prompt Engineer
- [`$engineering-rapid-prototyper`](engineering-rapid-prototyper/SKILL.md) - Rapid Prototyper
- [`$engineering-sre`](engineering-sre/SKILL.md) - SRE \(Site Reliability Engineer\)
- [`$engineering-senior-developer`](engineering-senior-developer/SKILL.md) - Senior Developer
- [`$engineering-software-architect`](engineering-software-architect/SKILL.md) - Software Architect
- [`$engineering-solidity-smart-contract-engineer`](engineering-solidity-smart-contract-engineer/SKILL.md) - Solidity Smart Contract Engineer
- [`$engineering-technical-writer`](engineering-technical-writer/SKILL.md) - Technical Writer
- [`$engineering-voice-ai-integration-engineer`](engineering-voice-ai-integration-engineer/SKILL.md) - Voice AI Integration Engineer
- [`$engineering-wechat-mini-program-developer`](engineering-wechat-mini-program-developer/SKILL.md) - WeChat Mini Program Developer
- [`$engineering-wordpress-shopping-cart`](engineering-wordpress-shopping-cart/SKILL.md) - WordPress Shopping Cart Engineer

### Finance

- [`$finance-bookkeeper-controller`](finance-bookkeeper-controller/SKILL.md) - Bookkeeper & Controller
- [`$finance-fpa-analyst`](finance-fpa-analyst/SKILL.md) - FP&A Analyst
- [`$finance-financial-analyst`](finance-financial-analyst/SKILL.md) - Financial Analyst
- [`$finance-investment-researcher`](finance-investment-researcher/SKILL.md) - Investment Researcher
- [`$finance-tax-strategist`](finance-tax-strategist/SKILL.md) - Tax Strategist

### Game Development

- [`$blender-addon-engineer`](blender-addon-engineer/SKILL.md) - Blender Add-on Engineer
- [`$game-audio-engineer`](game-audio-engineer/SKILL.md) - Game Audio Engineer
- [`$game-designer`](game-designer/SKILL.md) - Game Designer
- [`$godot-gameplay-scripter`](godot-gameplay-scripter/SKILL.md) - Godot Gameplay Scripter
- [`$godot-multiplayer-engineer`](godot-multiplayer-engineer/SKILL.md) - Godot Multiplayer Engineer
- [`$godot-shader-developer`](godot-shader-developer/SKILL.md) - Godot Shader Developer
- [`$level-designer`](level-designer/SKILL.md) - Level Designer
- [`$narrative-designer`](narrative-designer/SKILL.md) - Narrative Designer
- [`$roblox-avatar-creator`](roblox-avatar-creator/SKILL.md) - Roblox Avatar Creator
- [`$roblox-experience-designer`](roblox-experience-designer/SKILL.md) - Roblox Experience Designer
- [`$roblox-systems-scripter`](roblox-systems-scripter/SKILL.md) - Roblox Systems Scripter
- [`$technical-artist`](technical-artist/SKILL.md) - Technical Artist
- [`$unity-architect`](unity-architect/SKILL.md) - Unity Architect
- [`$unity-editor-tool-developer`](unity-editor-tool-developer/SKILL.md) - Unity Editor Tool Developer
- [`$unity-multiplayer-engineer`](unity-multiplayer-engineer/SKILL.md) - Unity Multiplayer Engineer
- [`$unity-shader-graph-artist`](unity-shader-graph-artist/SKILL.md) - Unity Shader Graph Artist
- [`$unreal-multiplayer-architect`](unreal-multiplayer-architect/SKILL.md) - Unreal Multiplayer Architect
- [`$unreal-systems-engineer`](unreal-systems-engineer/SKILL.md) - Unreal Systems Engineer
- [`$unreal-technical-artist`](unreal-technical-artist/SKILL.md) - Unreal Technical Artist
- [`$unreal-world-builder`](unreal-world-builder/SKILL.md) - Unreal World Builder

### Gis

- [`$gis-3d-scene-developer`](gis-3d-scene-developer/SKILL.md) - 3D & Scene Developer
- [`$gis-bim-specialist`](gis-bim-specialist/SKILL.md) - BIM/GIS Specialist
- [`$gis-cartography-designer`](gis-cartography-designer/SKILL.md) - Cartography Designer
- [`$gis-drone-reality-mapping`](gis-drone-reality-mapping/SKILL.md) - Drone/Reality Mapping Specialist
- [`$gis-analyst`](gis-analyst/SKILL.md) - GIS Analyst
- [`$gis-qa-engineer`](gis-qa-engineer/SKILL.md) - GIS QA Engineer
- [`$gis-geoai-ml-engineer`](gis-geoai-ml-engineer/SKILL.md) - GeoAI/ML Engineer
- [`$gis-geoprocessing-specialist`](gis-geoprocessing-specialist/SKILL.md) - Geoprocessing Specialist
- [`$gis-solution-engineer`](gis-solution-engineer/SKILL.md) - Solution Engineer
- [`$gis-spatial-data-engineer`](gis-spatial-data-engineer/SKILL.md) - Spatial Data Engineer
- [`$gis-spatial-data-scientist`](gis-spatial-data-scientist/SKILL.md) - Spatial Data Scientist
- [`$gis-technical-consultant`](gis-technical-consultant/SKILL.md) - Technical Consultant
- [`$gis-web-gis-developer`](gis-web-gis-developer/SKILL.md) - Web GIS Developer

### Marketing

- [`$marketing-aeo-foundations`](marketing-aeo-foundations/SKILL.md) - AEO Foundations Architect
- [`$marketing-ai-citation-strategist`](marketing-ai-citation-strategist/SKILL.md) - AI Citation Strategist
- [`$marketing-agentic-search-optimizer`](marketing-agentic-search-optimizer/SKILL.md) - Agentic Search Optimizer
- [`$marketing-app-store-optimizer`](marketing-app-store-optimizer/SKILL.md) - App Store Optimizer
- [`$marketing-baidu-seo-specialist`](marketing-baidu-seo-specialist/SKILL.md) - Baidu SEO Specialist
- [`$marketing-bilibili-content-strategist`](marketing-bilibili-content-strategist/SKILL.md) - Bilibili Content Strategist
- [`$marketing-book-co-author`](marketing-book-co-author/SKILL.md) - Book Co-Author
- [`$marketing-carousel-growth-engine`](marketing-carousel-growth-engine/SKILL.md) - Carousel Growth Engine
- [`$marketing-china-ecommerce-operator`](marketing-china-ecommerce-operator/SKILL.md) - China E-Commerce Operator
- [`$marketing-china-market-localization-strategist`](marketing-china-market-localization-strategist/SKILL.md) - China Market Localization Strategist
- [`$marketing-content-creator`](marketing-content-creator/SKILL.md) - Content Creator
- [`$marketing-cross-border-ecommerce`](marketing-cross-border-ecommerce/SKILL.md) - Cross-Border E-Commerce Specialist
- [`$marketing-douyin-strategist`](marketing-douyin-strategist/SKILL.md) - Douyin Strategist
- [`$marketing-email-strategist`](marketing-email-strategist/SKILL.md) - Email Marketing Strategist
- [`$marketing-global-podcast-strategist`](marketing-global-podcast-strategist/SKILL.md) - Global Podcast Strategist
- [`$marketing-growth-hacker`](marketing-growth-hacker/SKILL.md) - Growth Hacker
- [`$marketing-instagram-curator`](marketing-instagram-curator/SKILL.md) - Instagram Curator
- [`$marketing-kuaishou-strategist`](marketing-kuaishou-strategist/SKILL.md) - Kuaishou Strategist
- [`$marketing-linkedin-content-creator`](marketing-linkedin-content-creator/SKILL.md) - LinkedIn Content Creator
- [`$marketing-livestream-commerce-coach`](marketing-livestream-commerce-coach/SKILL.md) - Livestream Commerce Coach
- [`$marketing-multi-platform-publisher`](marketing-multi-platform-publisher/SKILL.md) - Multi-Platform Publisher
- [`$marketing-pr-communications-manager`](marketing-pr-communications-manager/SKILL.md) - PR & Communications Manager
- [`$marketing-podcast-strategist`](marketing-podcast-strategist/SKILL.md) - Podcast Strategist
- [`$marketing-private-domain-operator`](marketing-private-domain-operator/SKILL.md) - Private Domain Operator
- [`$marketing-reddit-community-builder`](marketing-reddit-community-builder/SKILL.md) - Reddit Community Builder
- [`$marketing-seo-specialist`](marketing-seo-specialist/SKILL.md) - SEO Specialist
- [`$marketing-short-video-editing-coach`](marketing-short-video-editing-coach/SKILL.md) - Short-Video Editing Coach
- [`$marketing-social-media-strategist`](marketing-social-media-strategist/SKILL.md) - Social Media Strategist
- [`$marketing-tiktok-strategist`](marketing-tiktok-strategist/SKILL.md) - TikTok Strategist
- [`$marketing-twitter-engager`](marketing-twitter-engager/SKILL.md) - Twitter Engager
- [`$marketing-video-optimization-specialist`](marketing-video-optimization-specialist/SKILL.md) - Video Optimization Specialist
- [`$marketing-wechat-official-account`](marketing-wechat-official-account/SKILL.md) - WeChat Official Account Manager
- [`$marketing-weibo-strategist`](marketing-weibo-strategist/SKILL.md) - Weibo Strategist
- [`$marketing-x-twitter-intelligence-analyst`](marketing-x-twitter-intelligence-analyst/SKILL.md) - X/Twitter Intelligence Analyst
- [`$marketing-xiaohongshu-specialist`](marketing-xiaohongshu-specialist/SKILL.md) - Xiaohongshu Specialist
- [`$marketing-zhihu-strategist`](marketing-zhihu-strategist/SKILL.md) - Zhihu Strategist

### Marketing Skills

- [`$ab-testing`](ab-testing/SKILL.md) - Ab Testing
- [`$ad-creative`](ad-creative/SKILL.md) - Ad Creative
- [`$ads`](ads/SKILL.md) - Ads
- [`$ai-seo`](ai-seo/SKILL.md) - Ai Seo
- [`$analytics`](analytics/SKILL.md) - Analytics
- [`$aso`](aso/SKILL.md) - Aso
- [`$churn-prevention`](churn-prevention/SKILL.md) - Churn Prevention
- [`$co-marketing`](co-marketing/SKILL.md) - Co Marketing
- [`$cold-email`](cold-email/SKILL.md) - Cold Email
- [`$community-marketing`](community-marketing/SKILL.md) - Community Marketing
- [`$competitor-profiling`](competitor-profiling/SKILL.md) - Competitor Profiling
- [`$competitors`](competitors/SKILL.md) - Competitors
- [`$content-strategy`](content-strategy/SKILL.md) - Content Strategy
- [`$copy-editing`](copy-editing/SKILL.md) - Copy Editing
- [`$copywriting`](copywriting/SKILL.md) - Copywriting
- [`$cro`](cro/SKILL.md) - Cro
- [`$customer-research`](customer-research/SKILL.md) - Customer Research
- [`$directory-submissions`](directory-submissions/SKILL.md) - Directory Submissions
- [`$emails`](emails/SKILL.md) - Emails
- [`$free-tools`](free-tools/SKILL.md) - Free Tools
- [`$image`](image/SKILL.md) - Image
- [`$launch`](launch/SKILL.md) - Launch
- [`$lead-magnets`](lead-magnets/SKILL.md) - Lead Magnets
- [`$marketing-ideas`](marketing-ideas/SKILL.md) - Marketing Ideas
- [`$marketing-plan`](marketing-plan/SKILL.md) - Marketing Plan
- [`$marketing-psychology`](marketing-psychology/SKILL.md) - Marketing Psychology
- [`$offers`](offers/SKILL.md) - Offers
- [`$onboarding`](onboarding/SKILL.md) - Onboarding
- [`$paywalls`](paywalls/SKILL.md) - Paywalls
- [`$popups`](popups/SKILL.md) - Popups
- [`$pricing`](pricing/SKILL.md) - Pricing
- [`$product-marketing`](product-marketing/SKILL.md) - Product Marketing
- [`$programmatic-seo`](programmatic-seo/SKILL.md) - Programmatic Seo
- [`$prospecting`](prospecting/SKILL.md) - Prospecting
- [`$public-relations`](public-relations/SKILL.md) - Public Relations
- [`$referrals`](referrals/SKILL.md) - Referrals
- [`$revops`](revops/SKILL.md) - Revops
- [`$sales-enablement`](sales-enablement/SKILL.md) - Sales Enablement
- [`$schema`](schema/SKILL.md) - Schema
- [`$seo-audit`](seo-audit/SKILL.md) - Seo Audit
- [`$signup`](signup/SKILL.md) - Signup
- [`$site-architecture`](site-architecture/SKILL.md) - Site Architecture
- [`$sms`](sms/SKILL.md) - Sms
- [`$social`](social/SKILL.md) - Social
- [`$video`](video/SKILL.md) - Video

### Paid Media

- [`$paid-media-creative-strategist`](paid-media-creative-strategist/SKILL.md) - Ad Creative Strategist
- [`$paid-media-ppc-strategist`](paid-media-ppc-strategist/SKILL.md) - PPC Campaign Strategist
- [`$paid-media-auditor`](paid-media-auditor/SKILL.md) - Paid Media Auditor
- [`$paid-media-paid-social-strategist`](paid-media-paid-social-strategist/SKILL.md) - Paid Social Strategist
- [`$paid-media-programmatic-buyer`](paid-media-programmatic-buyer/SKILL.md) - Programmatic & Display Buyer
- [`$paid-media-search-query-analyst`](paid-media-search-query-analyst/SKILL.md) - Search Query Analyst
- [`$paid-media-tracking-specialist`](paid-media-tracking-specialist/SKILL.md) - Tracking & Measurement Specialist

### PM Skills

- [`$ab-test-analysis`](ab-test-analysis/SKILL.md) - Ab Test Analysis
- [`$analyze-feature-requests`](analyze-feature-requests/SKILL.md) - Analyze Feature Requests
- [`$ansoff-matrix`](ansoff-matrix/SKILL.md) - Ansoff Matrix
- [`$beachhead-segment`](beachhead-segment/SKILL.md) - Beachhead Segment
- [`$brainstorm-experiments-existing`](brainstorm-experiments-existing/SKILL.md) - Brainstorm Experiments Existing
- [`$brainstorm-experiments-new`](brainstorm-experiments-new/SKILL.md) - Brainstorm Experiments New
- [`$brainstorm-ideas-existing`](brainstorm-ideas-existing/SKILL.md) - Brainstorm Ideas Existing
- [`$brainstorm-ideas-new`](brainstorm-ideas-new/SKILL.md) - Brainstorm Ideas New
- [`$brainstorm-okrs`](brainstorm-okrs/SKILL.md) - Brainstorm Okrs
- [`$business-model`](business-model/SKILL.md) - Business Model
- [`$cohort-analysis`](cohort-analysis/SKILL.md) - Cohort Analysis
- [`$competitive-battlecard`](competitive-battlecard/SKILL.md) - Competitive Battlecard
- [`$competitor-analysis`](competitor-analysis/SKILL.md) - Competitor Analysis
- [`$create-prd`](create-prd/SKILL.md) - Create Prd
- [`$customer-journey-map`](customer-journey-map/SKILL.md) - Customer Journey Map
- [`$draft-nda`](draft-nda/SKILL.md) - Draft Nda
- [`$dummy-dataset`](dummy-dataset/SKILL.md) - Dummy Dataset
- [`$grammar-check`](grammar-check/SKILL.md) - Grammar Check
- [`$growth-loops`](growth-loops/SKILL.md) - Growth Loops
- [`$gtm-motions`](gtm-motions/SKILL.md) - Gtm Motions
- [`$gtm-strategy`](gtm-strategy/SKILL.md) - Gtm Strategy
- [`$ideal-customer-profile`](ideal-customer-profile/SKILL.md) - Ideal Customer Profile
- [`$identify-assumptions-existing`](identify-assumptions-existing/SKILL.md) - Identify Assumptions Existing
- [`$identify-assumptions-new`](identify-assumptions-new/SKILL.md) - Identify Assumptions New
- [`$intended-vs-implemented`](intended-vs-implemented/SKILL.md) - Intended Vs Implemented
- [`$interview-script`](interview-script/SKILL.md) - Interview Script
- [`$job-stories`](job-stories/SKILL.md) - Job Stories
- [`$lean-canvas`](lean-canvas/SKILL.md) - Lean Canvas
- [`$market-segments`](market-segments/SKILL.md) - Market Segments
- [`$market-sizing`](market-sizing/SKILL.md) - Market Sizing
- [`$pm-skills-pm-marketing-growth-marketing-ideas-marketing-ideas`](pm-skills-pm-marketing-growth-marketing-ideas-marketing-ideas/SKILL.md) - Marketing Ideas
- [`$metrics-dashboard`](metrics-dashboard/SKILL.md) - Metrics Dashboard
- [`$monetization-strategy`](monetization-strategy/SKILL.md) - Monetization Strategy
- [`$north-star-metric`](north-star-metric/SKILL.md) - North Star Metric
- [`$opportunity-solution-tree`](opportunity-solution-tree/SKILL.md) - Opportunity Solution Tree
- [`$outcome-roadmap`](outcome-roadmap/SKILL.md) - Outcome Roadmap
- [`$pestle-analysis`](pestle-analysis/SKILL.md) - Pestle Analysis
- [`$porters-five-forces`](porters-five-forces/SKILL.md) - Porters Five Forces
- [`$positioning-ideas`](positioning-ideas/SKILL.md) - Positioning Ideas
- [`$pre-mortem`](pre-mortem/SKILL.md) - Pre Mortem
- [`$pricing-strategy`](pricing-strategy/SKILL.md) - Pricing Strategy
- [`$prioritization-frameworks`](prioritization-frameworks/SKILL.md) - Prioritization Frameworks
- [`$prioritize-assumptions`](prioritize-assumptions/SKILL.md) - Prioritize Assumptions
- [`$prioritize-features`](prioritize-features/SKILL.md) - Prioritize Features
- [`$privacy-policy`](privacy-policy/SKILL.md) - Privacy Policy
- [`$product-name`](product-name/SKILL.md) - Product Name
- [`$product-strategy`](product-strategy/SKILL.md) - Product Strategy
- [`$product-vision`](product-vision/SKILL.md) - Product Vision
- [`$release-notes`](release-notes/SKILL.md) - Release Notes
- [`$retro`](retro/SKILL.md) - Retro
- [`$review-resume`](review-resume/SKILL.md) - Review Resume
- [`$sentiment-analysis`](sentiment-analysis/SKILL.md) - Sentiment Analysis
- [`$shipping-artifacts`](shipping-artifacts/SKILL.md) - Shipping Artifacts
- [`$sprint-plan`](sprint-plan/SKILL.md) - Sprint Plan
- [`$sql-queries`](sql-queries/SKILL.md) - Sql Queries
- [`$stakeholder-map`](stakeholder-map/SKILL.md) - Stakeholder Map
- [`$startup-canvas`](startup-canvas/SKILL.md) - Startup Canvas
- [`$strategy-red-team`](strategy-red-team/SKILL.md) - Strategy Red Team
- [`$summarize-interview`](summarize-interview/SKILL.md) - Summarize Interview
- [`$summarize-meeting`](summarize-meeting/SKILL.md) - Summarize Meeting
- [`$swot-analysis`](swot-analysis/SKILL.md) - Swot Analysis
- [`$test-scenarios`](test-scenarios/SKILL.md) - Test Scenarios
- [`$user-personas`](user-personas/SKILL.md) - User Personas
- [`$user-segmentation`](user-segmentation/SKILL.md) - User Segmentation
- [`$user-stories`](user-stories/SKILL.md) - User Stories
- [`$value-prop-statements`](value-prop-statements/SKILL.md) - Value Prop Statements
- [`$value-proposition`](value-proposition/SKILL.md) - Value Proposition
- [`$wwas`](wwas/SKILL.md) - Wwas

### Product

- [`$product-behavioral-nudge-engine`](product-behavioral-nudge-engine/SKILL.md) - Behavioral Nudge Engine
- [`$product-feedback-synthesizer`](product-feedback-synthesizer/SKILL.md) - Feedback Synthesizer
- [`$product-manager`](product-manager/SKILL.md) - Product Manager
- [`$product-sprint-prioritizer`](product-sprint-prioritizer/SKILL.md) - Sprint Prioritizer
- [`$product-trend-researcher`](product-trend-researcher/SKILL.md) - Trend Researcher

### Project Management

- [`$project-management-experiment-tracker`](project-management-experiment-tracker/SKILL.md) - Experiment Tracker
- [`$project-management-jira-workflow-steward`](project-management-jira-workflow-steward/SKILL.md) - Jira Workflow Steward
- [`$project-management-meeting-notes-specialist`](project-management-meeting-notes-specialist/SKILL.md) - Meeting Notes Specialist
- [`$project-management-project-shepherd`](project-management-project-shepherd/SKILL.md) - Project Shepherd
- [`$project-manager-senior`](project-manager-senior/SKILL.md) - Senior Project Manager
- [`$project-management-studio-operations`](project-management-studio-operations/SKILL.md) - Studio Operations
- [`$project-management-studio-producer`](project-management-studio-producer/SKILL.md) - Studio Producer

### Sales

- [`$sales-account-strategist`](sales-account-strategist/SKILL.md) - Account Strategist
- [`$sales-deal-strategist`](sales-deal-strategist/SKILL.md) - Deal Strategist
- [`$sales-discovery-coach`](sales-discovery-coach/SKILL.md) - Discovery Coach
- [`$sales-offer-lead-gen-strategist`](sales-offer-lead-gen-strategist/SKILL.md) - Offer & Lead Gen Strategist
- [`$sales-outbound-strategist`](sales-outbound-strategist/SKILL.md) - Outbound Strategist
- [`$sales-pipeline-analyst`](sales-pipeline-analyst/SKILL.md) - Pipeline Analyst
- [`$sales-proposal-strategist`](sales-proposal-strategist/SKILL.md) - Proposal Strategist
- [`$sales-coach`](sales-coach/SKILL.md) - Sales Coach
- [`$sales-engineer`](sales-engineer/SKILL.md) - Sales Engineer

### Scientific Agent Skills

- [`$adaptyv`](adaptyv/SKILL.md) - Adaptyv
- [`$aeon`](aeon/SKILL.md) - Aeon
- [`$anndata`](anndata/SKILL.md) - Anndata
- [`$arbor`](arbor/SKILL.md) - Arbor
- [`$arboreto`](arboreto/SKILL.md) - Arboreto
- [`$astropy`](astropy/SKILL.md) - Astropy
- [`$autoskill`](autoskill/SKILL.md) - Autoskill
- [`$benchling-integration`](benchling-integration/SKILL.md) - Benchling Integration
- [`$bgpt-paper-search`](bgpt-paper-search/SKILL.md) - Bgpt Paper Search
- [`$bids`](bids/SKILL.md) - Bids
- [`$biopython`](biopython/SKILL.md) - Biopython
- [`$bioservices`](bioservices/SKILL.md) - Bioservices
- [`$bulk-rnaseq`](bulk-rnaseq/SKILL.md) - Bulk Rnaseq
- [`$cellxgene-census`](cellxgene-census/SKILL.md) - Cellxgene Census
- [`$cirq`](cirq/SKILL.md) - Cirq
- [`$citation-management`](citation-management/SKILL.md) - Citation Management
- [`$clinical-decision-support`](clinical-decision-support/SKILL.md) - Clinical Decision Support
- [`$clinical-reports`](clinical-reports/SKILL.md) - Clinical Reports
- [`$cobrapy`](cobrapy/SKILL.md) - Cobrapy
- [`$consciousness-council`](consciousness-council/SKILL.md) - Consciousness Council
- [`$dask`](dask/SKILL.md) - Dask
- [`$database-lookup`](database-lookup/SKILL.md) - Database Lookup
- [`$datamol`](datamol/SKILL.md) - Datamol
- [`$deepchem`](deepchem/SKILL.md) - Deepchem
- [`$deeptools`](deeptools/SKILL.md) - Deeptools
- [`$depmap`](depmap/SKILL.md) - Depmap
- [`$dhdna-profiler`](dhdna-profiler/SKILL.md) - Dhdna Profiler
- [`$diffdock`](diffdock/SKILL.md) - Diffdock
- [`$dnanexus-integration`](dnanexus-integration/SKILL.md) - Dnanexus Integration
- [`$docx`](docx/SKILL.md) - Docx
- [`$esm`](esm/SKILL.md) - Esm
- [`$etetoolkit`](etetoolkit/SKILL.md) - Etetoolkit
- [`$exa-search`](exa-search/SKILL.md) - Exa Search
- [`$experimental-design`](experimental-design/SKILL.md) - Experimental Design
- [`$exploratory-data-analysis`](exploratory-data-analysis/SKILL.md) - Exploratory Data Analysis
- [`$flowio`](flowio/SKILL.md) - Flowio
- [`$fluidsim`](fluidsim/SKILL.md) - Fluidsim
- [`$generate-image`](generate-image/SKILL.md) - Generate Image
- [`$geniml`](geniml/SKILL.md) - Geniml
- [`$geomaster`](geomaster/SKILL.md) - Geomaster
- [`$geopandas`](geopandas/SKILL.md) - Geopandas
- [`$get-available-resources`](get-available-resources/SKILL.md) - Get Available Resources
- [`$gget`](gget/SKILL.md) - Gget
- [`$ginkgo-cloud-lab`](ginkgo-cloud-lab/SKILL.md) - Ginkgo Cloud Lab
- [`$glycoengineering`](glycoengineering/SKILL.md) - Glycoengineering
- [`$gtars`](gtars/SKILL.md) - Gtars
- [`$histolab`](histolab/SKILL.md) - Histolab
- [`$hugging-science`](hugging-science/SKILL.md) - Hugging Science
- [`$hypogenic`](hypogenic/SKILL.md) - Hypogenic
- [`$hypothesis-generation`](hypothesis-generation/SKILL.md) - Hypothesis Generation
- [`$imaging-data-commons`](imaging-data-commons/SKILL.md) - Imaging Data Commons
- [`$infographics`](infographics/SKILL.md) - Infographics
- [`$iso-13485-certification`](iso-13485-certification/SKILL.md) - Iso 13485 Certification
- [`$labarchive-integration`](labarchive-integration/SKILL.md) - Labarchive Integration
- [`$lamindb`](lamindb/SKILL.md) - Lamindb
- [`$latchbio-integration`](latchbio-integration/SKILL.md) - Latchbio Integration
- [`$latex-posters`](latex-posters/SKILL.md) - Latex Posters
- [`$liteparse`](liteparse/SKILL.md) - Liteparse
- [`$literature-review`](literature-review/SKILL.md) - Literature Review
- [`$markdown-mermaid-writing`](markdown-mermaid-writing/SKILL.md) - Markdown Mermaid Writing
- [`$market-research-reports`](market-research-reports/SKILL.md) - Market Research Reports
- [`$markitdown`](markitdown/SKILL.md) - Markitdown
- [`$matchms`](matchms/SKILL.md) - Matchms
- [`$matlab`](matlab/SKILL.md) - Matlab
- [`$matplotlib`](matplotlib/SKILL.md) - Matplotlib
- [`$medchem`](medchem/SKILL.md) - Medchem
- [`$modal`](modal/SKILL.md) - Modal
- [`$molecular-dynamics`](molecular-dynamics/SKILL.md) - Molecular Dynamics
- [`$molfeat`](molfeat/SKILL.md) - Molfeat
- [`$networkx`](networkx/SKILL.md) - Networkx
- [`$neurokit2`](neurokit2/SKILL.md) - Neurokit2
- [`$neuropixels-analysis`](neuropixels-analysis/SKILL.md) - Neuropixels Analysis
- [`$nextflow`](nextflow/SKILL.md) - Nextflow
- [`$omero-integration`](omero-integration/SKILL.md) - Omero Integration
- [`$onekgpd`](onekgpd/SKILL.md) - Onekgpd
- [`$open-notebook`](open-notebook/SKILL.md) - Open Notebook
- [`$opentrons-integration`](opentrons-integration/SKILL.md) - Opentrons Integration
- [`$optimize-for-gpu`](optimize-for-gpu/SKILL.md) - Optimize For Gpu
- [`$pacsomatic`](pacsomatic/SKILL.md) - Pacsomatic
- [`$paper-lookup`](paper-lookup/SKILL.md) - Paper Lookup
- [`$paperzilla`](paperzilla/SKILL.md) - Paperzilla
- [`$parallel-web`](parallel-web/SKILL.md) - Parallel Web
- [`$pathml`](pathml/SKILL.md) - Pathml
- [`$pathway-enrichment`](pathway-enrichment/SKILL.md) - Pathway Enrichment
- [`$pdf`](pdf/SKILL.md) - Pdf
- [`$peer-review`](peer-review/SKILL.md) - Peer Review
- [`$pennylane`](pennylane/SKILL.md) - Pennylane
- [`$phylogenetics`](phylogenetics/SKILL.md) - Phylogenetics
- [`$pi-agent`](pi-agent/SKILL.md) - Pi Agent
- [`$polars`](polars/SKILL.md) - Polars
- [`$polars-bio`](polars-bio/SKILL.md) - Polars Bio
- [`$pptx`](pptx/SKILL.md) - Pptx
- [`$pptx-posters`](pptx-posters/SKILL.md) - Pptx Posters
- [`$primekg`](primekg/SKILL.md) - Primekg
- [`$protocolsio-integration`](protocolsio-integration/SKILL.md) - Protocolsio Integration
- [`$pufferlib`](pufferlib/SKILL.md) - Pufferlib
- [`$pydeseq2`](pydeseq2/SKILL.md) - Pydeseq2
- [`$pydicom`](pydicom/SKILL.md) - Pydicom
- [`$pyhealth`](pyhealth/SKILL.md) - Pyhealth
- [`$pylabrobot`](pylabrobot/SKILL.md) - Pylabrobot
- [`$pymatgen`](pymatgen/SKILL.md) - Pymatgen
- [`$pymc`](pymc/SKILL.md) - Pymc
- [`$pymoo`](pymoo/SKILL.md) - Pymoo
- [`$pyopenms`](pyopenms/SKILL.md) - Pyopenms
- [`$pysam`](pysam/SKILL.md) - Pysam
- [`$pytdc`](pytdc/SKILL.md) - Pytdc
- [`$pytorch-lightning`](pytorch-lightning/SKILL.md) - Pytorch Lightning
- [`$pyzotero`](pyzotero/SKILL.md) - Pyzotero
- [`$qiskit`](qiskit/SKILL.md) - Qiskit
- [`$qutip`](qutip/SKILL.md) - Qutip
- [`$rdkit`](rdkit/SKILL.md) - Rdkit
- [`$research-grants`](research-grants/SKILL.md) - Research Grants
- [`$research-lookup`](research-lookup/SKILL.md) - Research Lookup
- [`$rowan`](rowan/SKILL.md) - Rowan
- [`$scanpy`](scanpy/SKILL.md) - Scanpy
- [`$scholar-evaluation`](scholar-evaluation/SKILL.md) - Scholar Evaluation
- [`$scientific-brainstorming`](scientific-brainstorming/SKILL.md) - Scientific Brainstorming
- [`$scientific-critical-thinking`](scientific-critical-thinking/SKILL.md) - Scientific Critical Thinking
- [`$scientific-schematics`](scientific-schematics/SKILL.md) - Scientific Schematics
- [`$scientific-slides`](scientific-slides/SKILL.md) - Scientific Slides
- [`$scientific-visualization`](scientific-visualization/SKILL.md) - Scientific Visualization
- [`$scientific-writing`](scientific-writing/SKILL.md) - Scientific Writing
- [`$scikit-bio`](scikit-bio/SKILL.md) - Scikit Bio
- [`$scikit-learn`](scikit-learn/SKILL.md) - Scikit Learn
- [`$scikit-survival`](scikit-survival/SKILL.md) - Scikit Survival
- [`$scvelo`](scvelo/SKILL.md) - Scvelo
- [`$scvi-tools`](scvi-tools/SKILL.md) - Scvi Tools
- [`$seaborn`](seaborn/SKILL.md) - Seaborn
- [`$shap`](shap/SKILL.md) - Shap
- [`$simpy`](simpy/SKILL.md) - Simpy
- [`$stable-baselines3`](stable-baselines3/SKILL.md) - Stable Baselines3
- [`$statistical-analysis`](statistical-analysis/SKILL.md) - Statistical Analysis
- [`$statistical-power`](statistical-power/SKILL.md) - Statistical Power
- [`$statsmodels`](statsmodels/SKILL.md) - Statsmodels
- [`$sympy`](sympy/SKILL.md) - Sympy
- [`$tamarind`](tamarind/SKILL.md) - Tamarind
- [`$tiledbvcf`](tiledbvcf/SKILL.md) - Tiledbvcf
- [`$timesfm-forecasting`](timesfm-forecasting/SKILL.md) - Timesfm Forecasting
- [`$torch-geometric`](torch-geometric/SKILL.md) - Torch Geometric
- [`$torchdrug`](torchdrug/SKILL.md) - Torchdrug
- [`$transformers`](transformers/SKILL.md) - Transformers
- [`$treatment-plans`](treatment-plans/SKILL.md) - Treatment Plans
- [`$umap-learn`](umap-learn/SKILL.md) - Umap Learn
- [`$usfiscaldata`](usfiscaldata/SKILL.md) - Usfiscaldata
- [`$vaex`](vaex/SKILL.md) - Vaex
- [`$venue-templates`](venue-templates/SKILL.md) - Venue Templates
- [`$what-if-oracle`](what-if-oracle/SKILL.md) - What If Oracle
- [`$xlsx`](xlsx/SKILL.md) - Xlsx
- [`$zarr-python`](zarr-python/SKILL.md) - Zarr Python

### Security

- [`$security-appsec-engineer`](security-appsec-engineer/SKILL.md) - Application Security Engineer
- [`$security-blockchain-security-auditor`](security-blockchain-security-auditor/SKILL.md) - Blockchain Security Auditor
- [`$security-cloud-security-architect`](security-cloud-security-architect/SKILL.md) - Cloud Security Architect
- [`$security-compliance-auditor`](security-compliance-auditor/SKILL.md) - Compliance Auditor
- [`$security-incident-responder`](security-incident-responder/SKILL.md) - Incident Responder
- [`$security-penetration-tester`](security-penetration-tester/SKILL.md) - Penetration Tester
- [`$security-architect`](security-architect/SKILL.md) - Security Architect
- [`$security-senior-secops`](security-senior-secops/SKILL.md) - Senior SecOps Engineer
- [`$security-threat-detection-engineer`](security-threat-detection-engineer/SKILL.md) - Threat Detection Engineer
- [`$security-threat-intelligence-analyst`](security-threat-intelligence-analyst/SKILL.md) - Threat Intelligence Analyst

### Spatial Computing

- [`$terminal-integration-specialist`](terminal-integration-specialist/SKILL.md) - Terminal Integration Specialist
- [`$xr-cockpit-interaction-specialist`](xr-cockpit-interaction-specialist/SKILL.md) - XR Cockpit Interaction Specialist
- [`$xr-immersive-developer`](xr-immersive-developer/SKILL.md) - XR Immersive Developer
- [`$xr-interface-architect`](xr-interface-architect/SKILL.md) - XR Interface Architect
- [`$macos-spatial-metal-engineer`](macos-spatial-metal-engineer/SKILL.md) - macOS Spatial/Metal Engineer
- [`$visionos-spatial-engineer`](visionos-spatial-engineer/SKILL.md) - visionOS Spatial Engineer

### Specialized

- [`$accounts-payable-agent`](accounts-payable-agent/SKILL.md) - Accounts Payable Agent
- [`$agentic-identity-trust`](agentic-identity-trust/SKILL.md) - Agentic Identity & Trust Architect
- [`$agents-orchestrator`](agents-orchestrator/SKILL.md) - Agents Orchestrator
- [`$automation-governance-architect`](automation-governance-architect/SKILL.md) - Automation Governance Architect
- [`$business-strategist`](business-strategist/SKILL.md) - Business Strategist
- [`$change-management-consultant`](change-management-consultant/SKILL.md) - Change Management Consultant
- [`$chief-financial-officer`](chief-financial-officer/SKILL.md) - Chief Financial Officer
- [`$specialized-chief-of-staff`](specialized-chief-of-staff/SKILL.md) - Chief of Staff
- [`$specialized-civil-engineer`](specialized-civil-engineer/SKILL.md) - Civil Engineer
- [`$corporate-training-designer`](corporate-training-designer/SKILL.md) - Corporate Training Designer
- [`$specialized-cultural-intelligence-strategist`](specialized-cultural-intelligence-strategist/SKILL.md) - Cultural Intelligence Strategist
- [`$customer-service`](customer-service/SKILL.md) - Customer Service
- [`$customer-success-manager`](customer-success-manager/SKILL.md) - Customer Success Manager
- [`$data-consolidation-agent`](data-consolidation-agent/SKILL.md) - Data Consolidation Agent
- [`$data-privacy-officer`](data-privacy-officer/SKILL.md) - Data Privacy Officer
- [`$specialized-developer-advocate`](specialized-developer-advocate/SKILL.md) - Developer Advocate
- [`$specialized-document-generator`](specialized-document-generator/SKILL.md) - Document Generator
- [`$esg-sustainability-officer`](esg-sustainability-officer/SKILL.md) - ESG & Sustainability Officer
- [`$specialized-french-consulting-market`](specialized-french-consulting-market/SKILL.md) - French Consulting Market Navigator
- [`$government-digital-presales-consultant`](government-digital-presales-consultant/SKILL.md) - Government Digital Presales Consultant
- [`$grant-writer`](grant-writer/SKILL.md) - Grant Writer
- [`$hr-onboarding`](hr-onboarding/SKILL.md) - HR Onboarding
- [`$healthcare-customer-service`](healthcare-customer-service/SKILL.md) - Healthcare Customer Service
- [`$healthcare-marketing-compliance`](healthcare-marketing-compliance/SKILL.md) - Healthcare Marketing Compliance Specialist
- [`$hospitality-guest-services`](hospitality-guest-services/SKILL.md) - Hospitality Guest Services
- [`$identity-graph-operator`](identity-graph-operator/SKILL.md) - Identity Graph Operator
- [`$specialized-korean-business-navigator`](specialized-korean-business-navigator/SKILL.md) - Korean Business Navigator
- [`$lsp-index-engineer`](lsp-index-engineer/SKILL.md) - LSP/Index Engineer
- [`$language-translator`](language-translator/SKILL.md) - Language Translator
- [`$legal-billing-time-tracking`](legal-billing-time-tracking/SKILL.md) - Legal Billing & Time Tracking
- [`$legal-client-intake`](legal-client-intake/SKILL.md) - Legal Client Intake
- [`$legal-document-review`](legal-document-review/SKILL.md) - Legal Document Review
- [`$loan-officer-assistant`](loan-officer-assistant/SKILL.md) - Loan Officer Assistant
- [`$ma-integration-manager`](ma-integration-manager/SKILL.md) - M&A Integration Manager
- [`$specialized-mcp-builder`](specialized-mcp-builder/SKILL.md) - MCP Builder
- [`$medical-billing-coding-specialist`](medical-billing-coding-specialist/SKILL.md) - Medical Billing & Coding Specialist
- [`$specialized-model-qa`](specialized-model-qa/SKILL.md) - Model QA Specialist
- [`$operations-manager`](operations-manager/SKILL.md) - Operations Manager
- [`$organizational-psychologist`](organizational-psychologist/SKILL.md) - Organizational Psychologist
- [`$personal-growth-mentor`](personal-growth-mentor/SKILL.md) - Personal Growth Mentor
- [`$specialized-pricing-analyst`](specialized-pricing-analyst/SKILL.md) - Pricing Analyst
- [`$real-estate-buyer-seller`](real-estate-buyer-seller/SKILL.md) - Real Estate Buyer & Seller
- [`$recruitment-specialist`](recruitment-specialist/SKILL.md) - Recruitment Specialist
- [`$report-distribution-agent`](report-distribution-agent/SKILL.md) - Report Distribution Agent
- [`$retail-customer-returns`](retail-customer-returns/SKILL.md) - Retail Customer Returns
- [`$sales-data-extraction-agent`](sales-data-extraction-agent/SKILL.md) - Sales Data Extraction Agent
- [`$sales-outreach`](sales-outreach/SKILL.md) - Sales Outreach
- [`$specialized-salesforce-architect`](specialized-salesforce-architect/SKILL.md) - Salesforce Architect
- [`$specialized-strategy-duel-agent`](specialized-strategy-duel-agent/SKILL.md) - Strategy Duel Agent
- [`$study-abroad-advisor`](study-abroad-advisor/SKILL.md) - Study Abroad Advisor
- [`$supply-chain-strategist`](supply-chain-strategist/SKILL.md) - Supply Chain Strategist
- [`$specialized-workflow-architect`](specialized-workflow-architect/SKILL.md) - Workflow Architect
- [`$zk-steward`](zk-steward/SKILL.md) - ZK Steward

### Support

- [`$support-analytics-reporter`](support-analytics-reporter/SKILL.md) - Analytics Reporter
- [`$support-executive-summary-generator`](support-executive-summary-generator/SKILL.md) - Executive Summary Generator
- [`$support-finance-tracker`](support-finance-tracker/SKILL.md) - Finance Tracker
- [`$support-infrastructure-maintainer`](support-infrastructure-maintainer/SKILL.md) - Infrastructure Maintainer
- [`$support-legal-compliance-checker`](support-legal-compliance-checker/SKILL.md) - Legal Compliance Checker
- [`$support-support-responder`](support-support-responder/SKILL.md) - Support Responder

### Testing

- [`$testing-api-tester`](testing-api-tester/SKILL.md) - API Tester
- [`$testing-accessibility-auditor`](testing-accessibility-auditor/SKILL.md) - Accessibility Auditor
- [`$testing-evidence-collector`](testing-evidence-collector/SKILL.md) - Evidence Collector
- [`$testing-performance-benchmarker`](testing-performance-benchmarker/SKILL.md) - Performance Benchmarker
- [`$testing-reality-checker`](testing-reality-checker/SKILL.md) - Reality Checker
- [`$testing-test-results-analyzer`](testing-test-results-analyzer/SKILL.md) - Test Results Analyzer
- [`$testing-tool-evaluator`](testing-tool-evaluator/SKILL.md) - Tool Evaluator
- [`$testing-workflow-optimizer`](testing-workflow-optimizer/SKILL.md) - Workflow Optimizer

## License

Original skill and tool content retains its source license and attribution. See [LICENSE](LICENSE).

Packaging scripts and the generated banner in this repository are provided under MIT unless otherwise noted.
