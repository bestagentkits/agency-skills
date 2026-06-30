<p align="center">
  <img src="assets/agency-skills-banner.png" alt="Agency Skills banner" width="100%">
</p>

# Agency Skills

Codex skills converted at source commit `24485830cd4b3c63a4a357b0664d9dedbab9653a`.
This repository packages the Agency Agents roster as Codex-compatible skills. Each source agent becomes a standalone skill folder with:
- `SKILL.md` containing Codex skill frontmatter and the original specialist instructions
- `agents/openai.yaml` containing UI metadata for skill lists and default prompts

## Install

Clone this repository into a Codex skills directory or copy selected skill folders into your existing skills path.

```bash
git clone https://github.com/bestagentkits/agency-skills.git
```

To use a skill, invoke it by name in Codex, for example:

```text
Use $engineering-backend-architect to review this API design.
```

## Claude Code Plugin Marketplace

This repo also ships an Anthropic Claude Code plugin marketplace catalog at `.claude-plugin/marketplace.json`.

```text
/plugin marketplace add https://github.com/bestagentkits/agency-skills.git
/plugin install agency-skills@agency-skills
```

The marketplace entry uses `strict: false` with an explicit `skills` list, so the root skill folders are the single source of truth.

## Source Conversion

The conversion is reproducible from a local checkout of the source agent corpus:

```bash
SOURCE_DIR=/tmp/agency-source
ruby scripts/convert-agents-to-skills.rb "$SOURCE_DIR" .
ruby scripts/generate-plugin-marketplace.rb .
```

The converter selects Markdown files with source frontmatter containing both `name` and `description` from canonical source divisions in `divisions.json`. Documentation, examples, `integrations/` generated outputs, and strategy files are not converted.

## Skill Index

### Academic

- [`$academic-anthropologist`](academic-anthropologist/SKILL.md) - Anthropologist
- [`$academic-geographer`](academic-geographer/SKILL.md) - Geographer
- [`$academic-historian`](academic-historian/SKILL.md) - Historian
- [`$academic-narratologist`](academic-narratologist/SKILL.md) - Narratologist
- [`$academic-psychologist`](academic-psychologist/SKILL.md) - Psychologist

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
- [`$engineering-sre`](engineering-sre/SKILL.md) - SRE (Site Reliability Engineer)
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

### GIS

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

### Paid Media

- [`$paid-media-creative-strategist`](paid-media-creative-strategist/SKILL.md) - Ad Creative Strategist
- [`$paid-media-ppc-strategist`](paid-media-ppc-strategist/SKILL.md) - PPC Campaign Strategist
- [`$paid-media-auditor`](paid-media-auditor/SKILL.md) - Paid Media Auditor
- [`$paid-media-paid-social-strategist`](paid-media-paid-social-strategist/SKILL.md) - Paid Social Strategist
- [`$paid-media-programmatic-buyer`](paid-media-programmatic-buyer/SKILL.md) - Programmatic & Display Buyer
- [`$paid-media-search-query-analyst`](paid-media-search-query-analyst/SKILL.md) - Search Query Analyst
- [`$paid-media-tracking-specialist`](paid-media-tracking-specialist/SKILL.md) - Tracking & Measurement Specialist

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

Original agent content is licensed under MIT. See [LICENSE](LICENSE).

Converted agent content retains its original attribution. Packaging scripts and the generated banner in this repository are provided under the same MIT license unless otherwise noted.
