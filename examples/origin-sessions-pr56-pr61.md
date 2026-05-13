# Origin sessions — `retirement-dashboard-angular` PRs #56 to #61

The six PRs that crystallized the AI-Human Pair Programming with
Cross-Vetting methodology. Merged 2026-04-24 → 2026-04-25 by a single
human (justice8096) working with Claude Code as the AI proposer and
Codex as the AI reviewer.

For the standout case study, see
[`pr-59-codex-feedback-loop.md`](pr-59-codex-feedback-loop.md). For the
methodology itself, see [`../METHODOLOGY.md`](../METHODOLOGY.md).

## Overview table

| PR | Title | Initiated by | What it did | Codex review? | Cross-vet outcome |
|----|-------|-------------|-------------|:-------------:|-------------------|
| [#56](https://github.com/justice8096/retirement-dashboard-angular/pull/56) | feat(monte-carlo): Long-Term Care planning | Human (todo list item) | Bernoulli LTC roll (70% probability per Genworth 2024), $108K/yr cost, 2.4yr median stay; modes for self-insure / insurance / both. | Yes (COMMENTED) | Findings addressed inline. |
| [#57](https://github.com/justice8096/retirement-dashboard-angular/pull/57) | feat(monte-carlo): FX stress test | Human | Deterministic one-time FX shock (`fxShockYear`, `fxShockPct`). Lets retirees abroad bracket a sudden currency move. | Yes (COMMENTED) | Findings addressed inline. |
| [#58](https://github.com/justice8096/retirement-dashboard-angular/pull/58) | feat(guardrails): essential vs discretionary spending split | Human (todo list #24) | Added `essential: boolean` to `COST_CATEGORIES`; surfaced dynamic essential floor alongside the static Guyton-Klinger 3% rule. | Yes — **two findings** | P1: pre-Medicare healthcare excluded from essential floor (regression for pre-65 households). P2: per-trial LTC roll becomes a coin flip in single-run modes. P2 → fix landed in PR #59. |
| [#59](https://github.com/justice8096/retirement-dashboard-angular/pull/59) | fix(monte-carlo): stabilize LTC self-insure in single-run modes | AI (in response to PR #58 Codex P2) | Switched to expected-value LTC when `effectiveRuns === 1`. Multi-run modes keep the per-trial roll. | Yes (COMMENTED) | The clearest cross-vet moment in the session. See dedicated deep dive. |
| [#60](https://github.com/justice8096/retirement-dashboard-angular/pull/60) | refactor: extract shared currency / FIRE / location / scenario helpers | AI (audit-driven) | Three dedup passes: extract FIRE/Guardrail constants, extract `CurrencyFormatService` facade, move `locMonthlyCost` to `LocationService`. Also fixed a dead-code dyscalculia gate inconsistency. | Yes | Human deferred "audit #2 (god-component split)" to a later session — explicit scope discipline. |
| [#61](https://github.com/justice8096/retirement-dashboard-angular/pull/61) | refactor: extract inline templates + styles for 6 god components | AI (audit-driven) | Extracted ~3,500 LOC of inline templates / styles from 6 components. Kept components under 200 LOC inline (single-file mental model). | Yes (COMMENTED) | Human surfaced the trade-off explicitly: extraction adds "2 reads instead of 1" for AI agents. Cross-vet acknowledged the cost. |

## What jumps out from the table

### The methodology actually catches things

PR #58 had a P1 and a P2 from Codex, both substantive. The P1
(healthcare exclusion) was directionally wrong in exactly the cases
where the new feature was supposed to help — pre-65 households where
healthcare is one of the largest non-discretionary costs. Without
Codex, that ships. With Codex, the human sees it before merge.

### The cross-vet survives an out-of-order merge

PR #58 merged before its Codex P2 was addressed. The methodology
didn't fail — PR #59 was opened explicitly to address the deferred
finding, with the math sanity-check inline. The audit trail is intact:
follow PR #58 → see P2 → follow link to PR #59 → see fix + reasoning.

### Human scope decisions are visible

PR #60 explicitly defers the god-component split. PR #61 explicitly
keeps small components inline. These are human judgment calls that
the AI proposer wouldn't have made unprompted — they show up in the PR
bodies as documented dissent.

### Codex isn't infallible

The exploration of the audits in `retirement-dashboard-angular` shows
findings the human caught that Codex didn't (e.g., the dead-code
dyscalculia gate fixed in PR #60 was human-spotted during refactor).
The cross-vet works in both directions; treating Codex as ground truth
would have missed real issues.

## What's missing from this overview

- Quotes from individual Codex findings — those live in the inline
  review threads on each PR. The deep dive
  [`pr-59-codex-feedback-loop.md`](pr-59-codex-feedback-loop.md) has
  the verbatim quotes for the standout case.
- Conversation transcripts — the proposer-side AI conversations are
  retained in the user's local Claude Code history, not in the public
  PR record. This is one of the audit-trail gaps called out in
  [`../docs/failure-modes.md`](../docs/failure-modes.md) (mode #4).
- Time spent — none of these PRs has a recorded "hours" number. The
  whole sequence shipped in roughly 24 hours of elapsed time, much of
  it interactive.
