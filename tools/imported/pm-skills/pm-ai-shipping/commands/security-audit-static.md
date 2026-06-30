---
description: Static security audit of AI-built code — map trust boundaries, cross-reference documented intent, self-refute every finding, and report only evidence-backed risks
argument-hint: "<repo path or area; defaults to the whole repository>"
---

# /security-audit-static -- Audit the Code You Already Have

A focused, self-contained security audit for AI-built code. It keeps a small, durable engine — map the boundaries, check intent against implementation, refute before reporting — and refuses to emit anything it can't back with cited evidence.

This is a review, not a guarantee: it produces code-review findings, not confirmed exploits.

> Method adapted from the public, Apache-2.0 `security-guidance` plugin in Anthropic's
> `claude-plugins-official` repository. Not affiliated with or endorsed by Anthropic.

## Invocation

```
/security-audit-static
/security-audit-static supabase/functions
```

## Scope

Audit **$ARGUMENTS**. If empty, audit the whole repository, prioritizing request handlers, auth, data access, background jobs, and anything that renders, fetches, executes, logs, or stores user-controlled data. For non-trivial scopes, fan out with parallel subagents — one per function/module cluster, each running the mapping and inspection (steps 1–3); then merge candidates and run the self-refute (step 4) yourself over the full set.

## The audit (small engine, strong constraint)

### 1. Map entry points to trust boundaries and sinks

Optimize for recall first — read every file in scope in full, then grep for handler, route, RPC, and shared-helper names to find callers and downstream sinks. Reading the file that contains the bug is what prevents missing it.

Entry points: HTTP/RPC handlers, edge/serverless functions, webhooks, queue consumers, upload handlers, auth callbacks, cron-triggered endpoints. Sinks: raw SQL / query filters, shell/exec, `eval` / `new Function` / dynamic imports, HTML render and templates, outbound fetches, filesystem paths, IAM/role writes, logs and analytics, deserializers (incl. YAML/XML and archive extraction), response headers / cache-control, and **LLM prompts and tool calls** (prompt injection). For every value reaching a sink, decide whether an attacker can influence it and trace it back to its source.

### 2. Inspect the four high-value paths

Authorization, data access, session/identity, and input→output encoding. Compare sibling handlers — if one enforces a check another omits, the omission is a finding. Follow cross-file flows; input in module A reaching a dangerous operation in module B is where the real bugs hide.

### 3. Cross-reference intended vs. implemented

Apply the **intended-vs-implemented** skill against `/documentation/*.md`. A rule documented but not enforced in code is a finding on its own. If the docs are absent, note it and recommend `/document-app` first — an intent audit needs intent on record.

### 4. Self-refute every candidate

For each finding, try to disprove it. Default to **keep** unless you find cited evidence (file + line) for one of: a real sanitizer/encoder/validator/authorization check stops the exploit *at the sink*; the sink is non-dangerous (typed, hardcoded, isolated, schema-decoded); a frontend gate is independently re-enforced on the backend; an unvalidated credential is immediately forwarded to an upstream system that validates it; a config/flag gates the path and users can't influence it per request; or the path isn't reachable in production.

Name the **attacker** and the **victim**: refute if the only victim is the attacker on their own machine/account/tenant/data and no shared system or privilege boundary is crossed; keep if the impact reaches other users, tenants, shared infrastructure, billing, email reputation, secrets, or compliance-sensitive data. **Never apply attacker-equals-victim refutation to SSRF/outbound-network sinks, shared billing or quota sinks, data-exposure findings, cross-tenant or cross-principal flows, or server-side execution/rendering** — those harm someone other than the attacker by definition. Never refute a finding merely because the code is pre-existing — pre-existing bugs are the point. Do not speculate.

### 5. Report only what survives

## High-miss checklist (technology-shaped, not stack-specific)

Apply these — they're where AI-built apps most often fail:

- **Service-role / disabled-RLS boundaries** — if the DB client bypasses row-level security, *every* authorization decision must be in code; flag queries missing the org/owner filter.
- **Auth-provider drift** — claims from an external identity provider (e.g. Clerk) trusted without verifying how they map to data scope.
- **Gate/action field mismatch** — permission checked on one ID, action performed on an independent ID never proven to belong to it.
- **Forgeable request signals** — endpoints gated by `?source=cron`, `?bot=1`, guessable headers, or unsigned webhook-like payloads instead of real auth. Raise severity when the endpoint mutates data, sends email, or triggers paid usage.
- **Output encoding vs. input validation** — user data interpolated into HTML, `<title>`, attributes, JSON-LD, SQL, or Markdown must be encoded for *that* sink; input validation doesn't count. (XSS, CSP gaps.)
- **SSRF / renderer abuse** — attacker-influenced URLs, HTML, SVG, or Markdown reaching an outbound fetch or a renderer (headless browser, PDF/OG-image generator).
- **Parser / validator differentials** — the validator accepts a value the consumer interprets differently: unanchored regex, `startsWith`/substring allowlists, URL-parser disagreement, encoding/case/slash/path-normalization mismatch, or validation on one representation and execution on another.
- **Fail-open paths** — error, `catch`, timeout, cancellation, cache-miss, stale-cache, feature-flag, or boundary-value branches that default to *allow*. AI code loves a permissive fallback.
- **Secrets / PII to observability** — credentials, tokens, emails, or sensitive data reaching logs, traces, analytics, or error bodies; check error branches especially.
- **Public-data-only violations** — SPA/SEO bot routes or "public" endpoints over-fetching private fields.

## Output

Group surviving findings by file, sorted by severity, in the standard format:

```
Security Audit: [scope]

<file>:
  N. [SEVERITY] [Category] <location>
     Risk Level: Critical | High | Medium | Low
     Attack Scenario: <attacker -> sink -> impact, step by step>
     Impact: <what data or functionality is compromised>
     Solution: <concrete code change>
```

End with: the root-cause theme across findings; **what is well-built — say it explicitly**; and what you could not verify and the user should double-check. Optionally write the report to `/reports/security_audit_{timestamp}.md`.

## Notes

- Don't report generic hardening with no concrete impact, outdated deps without a reachable path, or test/mock code unless it ships. Logic and authorization bugs with no classic sink still count.
- This command covers security only. For over-fetching, indexes, and caching, use `/performance-audit-static`.
- For an end-to-end pass that documents first and produces a shipping packet, use `/ship-check`.
