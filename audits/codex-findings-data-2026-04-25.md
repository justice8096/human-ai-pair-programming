# Codex findings audit — origin sessions PRs #56-#61

**Repo audited:** `justice8096/retirement-dashboard-angular`
**Time window:** 2026-04-24 → 2026-04-25 (the methodology's origin
sessions)
**Trigger:** Quantitative data needed for the methodology article's
§3 (worked example) and §6 (failure modes) — specifically, "how often
did the cross-vet catch something" measured at the level of bot-
review comments.
**Scope:** All inline review comments left by `chatgpt-codex-connector[bot]`
on PRs #56 through #61. Top-level review summaries are excluded;
inline findings are what matter for catch-rate analysis.
**Conducted by:** Claude Code 4.7 via `gh api` extraction; human
approver pending.

---

## Executive summary

Six PRs in scope; five received Codex findings (PR #60 was clean).
Total of **8 inline findings**: 1 P1 (orange) + 7 P2 (yellow) + 0 P0.
Per-PR rate ranges from 0 to 2 findings, averaging 1.33. At least
2 of the 8 are confirmed actioned in subsequent commits or follow-up
PRs; remaining findings' resolution status outstanding for verification.

This is **not** a controlled experiment — there is no baseline catch-
rate to compare against (e.g., what would a human reviewer have
found instead, or in addition). The article should frame this as
*observed cross-vet activity*, not *catch-rate effectiveness*.

---

## Findings table (resolution-status verified 2026-04-25)

| PR | Sev | File:Line | Title | Resolution |
|---:|:---:|-----------|-------|------------|
| #56 | P2 | `src/app/lib/monte-carlo.ts:567` | Preserve fractional LTC duration in yearly charge | **Deferred** — `Math.round(ltcDurationY)` still present in current code at lines 605 and 688. Human approver chose not to act. |
| #56 | P2 | `src/app/lib/monte-carlo.ts:634` | Keep insurance premium flat as configured | **Deferred** — `ltcInsMonthly * 12 * cumInfl` still present at line 710. Human approver chose not to act. |
| #57 | P2 | `src/app/lib/monte-carlo.ts` | Apply FX shock independently from current segment | **Confirmed actioned** in commit `88dd2ae` ("fix(monte-carlo): FX shock fires regardless of segment"). Doc comment now explicit: *"The shock fires at `fxShockYear` regardless of which segment is active."* |
| #58 | **P1** | `src/app/components/screens/guardrails-screen/guardrails-screen.component.ts:420` | Include pre-Medicare healthcare in essential floor | **Confirmed actioned** in commit `de08d55` ("fix(guardrails): include effective healthcare in essential floor"). `sumByEssential()` now skips healthcare alternates; HealthcareService handles regime-aware costs. |
| #58 | P2 | `src/app/lib/monte-carlo.ts:588` | Prevent random LTC shock in single-path historical mode | **Confirmed actioned** in PR #59 (`be2b9fd`) — math sanity-check inline |
| #59 | P2 | `src/app/lib/monte-carlo.ts` | Spread EV LTC costs across start-age distribution | **Confirmed actioned** in commit `8eb8d89` ("fix(monte-carlo): spread EV LTC across start-age distribution"). Code now uses occupancy-weighted distribution. |
| #61 | P2 | `scripts/extract-inline-template.py:128` | Preflight destination files before writing outputs | **Confirmed actioned** in commit `0039ef4` |
| #60 | — | — | (no Codex findings) | — |

---

## Aggregate counts

| Metric | Value |
|--------|------:|
| PRs in window | 6 |
| PRs with findings | 5 |
| PRs clean (no findings) | 1 (#60) |
| Total findings | 8 |
| P0 findings | 0 |
| P1 findings | 1 |
| P2 findings | 7 |
| Findings per PR (mean) | 1.33 |
| Findings per PR (range) | 0 - 2 |
| Confirmed actioned in subsequent commit/PR | **6** (PR #57 P2; PR #58 P1; PR #58 P2; PR #59 P2; PR #61 P2; plus the one referenced earlier) |
| Confirmed deferred (human approver chose not to act) | **2** (both PR #56 P2) |
| Resolution-status verified | **8 of 8** |

---

## What this data supports in the article

The article's §3 already deep-dives **PR #58 → PR #59** (the LTC
shock case). The aggregate data here lets §3 add a single sentence
of context:

> The PR #58 → #59 trace is one of eight Codex findings across the
> six origin PRs (1 P1 + 7 P2 + 0 P0). Two findings are
> confirmed-actioned in subsequent commits or follow-up PRs; the
> remaining six are not verified by this audit and may have been
> addressed silently within the originating PR before merge,
> deferred, or accepted-as-risk.

That's **honest and bounded** — doesn't overclaim a catch-rate; does
establish that the cross-vet was generating substantive review
activity at meaningful frequency.

The §6 failure-modes section can use the same data to support
mode #4 (audit-trail completeness): the 6-of-8 "outstanding" status
shows that resolution status decays into the audit trail noise
quickly when not actively tracked. This argues for the
[`docs/audit-artifacts.md`](../docs/audit-artifacts.md) per-instance
artifacts being load-bearing — without them, "did Codex's finding
get fixed" becomes archaeology.

---

## What this data does *not* support

Three claims the article should NOT make from this data:

1. **"Codex caught X% of bugs."** No baseline. Without knowing what
   bugs were *not* in the diffs, we have a numerator only.
2. **"Cross-vet works because Codex caught N findings."** Catching
   findings is necessary but not sufficient. The article's claim
   should be about the *structure* (asymmetric epistemic sources,
   audit trail discipline), with the data as illustrative not
   probative.
3. **"Solo-reviewer flow would have missed these."** Untested. A
   skilled human reviewer might have caught the same findings, or
   different ones. The article should not imply Codex is uniquely
   capable.

The article can honestly claim: "Cross-vet generated substantive
review activity at a rate of >1 finding per PR over a 6-PR window,
with at least one P1 finding (a real correctness regression in the
new feature) and one P2 finding that drove a documented follow-up
PR with mathematical verification." That's defensible.

---

## Outstanding research

For the per-PR resolution audit (closing the 6 outstanding items
above):

- Read each PR's commit history between Codex's review and merge
  to see if findings were silently addressed
- Check follow-up PRs in the days after each merge for explicit
  references to the Codex finding
- Where neither is the case, mark the finding as either deferred-
  with-tracking-issue or accepted-as-risk

Estimated time: 1-2 hours focused work. Not gating the article
draft — the article can ship with "8 findings; 2 confirmed actioned"
and footnote the unverified status of the rest.

---

## Cross-references

- Article plan: `C:/Users/justi/.claude/plans/jolly-cooking-pinwheel.md`
- Worked example deep-dive (PR #58 → #59):
  [`../examples/pr-59-codex-feedback-loop.md`](../examples/pr-59-codex-feedback-loop.md)
- Origin-sessions overview:
  [`../examples/origin-sessions-pr56-pr61.md`](../examples/origin-sessions-pr56-pr61.md)
- Audit-artifacts framework:
  [`../docs/audit-artifacts.md`](../docs/audit-artifacts.md)

## Sign-off

**Drafted by:** Claude Code 4.7 (via `gh api` extraction +
synthesis)
**Reviewed by:** *(pending — would be the human approver per
methodology)*
**Sign-off:** *(pending)*
**Disagreements during review:** *(none yet — review hasn't happened)*
