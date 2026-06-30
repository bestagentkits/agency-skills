---
description: Static performance audit of AI-built code — find over-fetching, missing indexes, and caching opportunities, ranked by effort and impact
argument-hint: "<repo path or area; defaults to the whole repository>"
---

# /performance-audit-static -- Find What Won't Scale

A focused performance review for AI-built code. Agents optimize for "it works on my seed data," not "it holds at 100× the rows." This command finds the three failure modes that surface as data grows — over-fetching, missing indexes, and absent caching — and ranks fixes by effort and impact.

This is a static review of code and queries, not a load test.

## Invocation

```
/performance-audit-static
/performance-audit-static src/views
```

## Scope

Audit **$ARGUMENTS**. If empty, review the whole repository, prioritizing list and dashboard views, frequently hit endpoints, and large tables.

## The audit

### 1. Over-fetch in view payloads

Review components that render list or dashboard views. Identify fields fetched from the database but never used in the frontend, `SELECT *` on wide tables, missing pagination, absent lazy loading, and redundant loads. Suggest a minimal field set per component or route.

### 2. Missing or inefficient indexes

Review queries, filters, and RPCs used in production views. Identify missing or inefficient indexes based on sort, filter, and join conditions, focusing on large tables and hot endpoints. Give specific index definitions, not "add an index."

### 3. Caching opportunities

Review endpoints and data-access patterns for frequently called paths that return static or rarely changing data. Identify where frontend or backend caching helps, and specify the invalidation rule for each — caching without an invalidation plan is a correctness bug in waiting.

## Output

Report findings per view, route, or table:

```
Performance Audit: [scope]

<view / route / table>:
  - Finding: <what is slow or wasteful>
  - Recommendation: <specific change — field set, index definition, cache + invalidation>
  - Effort: Low | Medium | High
  - Priority: Low | Medium | High
  - Expected effect: <e.g. payload size, query time, load time>
```

End with what's already efficient (say it explicitly) and what needs runtime profiling to confirm. Optionally write the report to `/reports/performance_audit_{timestamp}.md`.

## Notes

- Rank by impact-per-effort — one missing index on a hot table usually beats ten micro-optimizations.
- Don't flag theoretical inefficiency with no growth path; flag what breaks as rows or traffic scale.
- This command covers performance only. For authorization, injection, and data-exposure risks, use `/security-audit-static`.
- For an end-to-end pass with documentation and a shipping packet, use `/ship-check`.
