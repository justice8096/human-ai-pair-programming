# Deep dive — PR #59 and the Codex feedback loop

The cleanest single demonstration of AI-Human Pair Programming with
Cross-Vetting working as designed. An AI reviewer caught a subtle
correctness issue in an AI-proposed feature, the human noticed and
acted on it, and the AI proposer wrote a follow-up fix with a
mathematical sanity-check that the cure preserved the intent of the
original.

For the broader origin-session context, see
[`origin-sessions-pr56-pr61.md`](origin-sessions-pr56-pr61.md).
For the methodology this exemplifies, see
[`../METHODOLOGY.md`](../METHODOLOGY.md).

## Setup

[PR #58 — feat(guardrails): essential vs discretionary spending
split](https://github.com/justice8096/retirement-dashboard-angular/pull/58)
landed on 2026-04-25 at 08:50 UTC. It also touched
`src/app/lib/monte-carlo.ts` to add a per-trial Long-Term Care roll
that had been introduced in PR #56:

> Per-trial LTC roll. Resolves once at trial start; deterministic
> across years within the trial. willNeedLtc: 70% of 65+ Americans
> by Genworth.
>
> ```ts
> if (ltcSelfInsure && oldestAge0 != null && Math.random() < ltcProbability) {
>   const ltcStartAge = ltcStartAgeMin + Math.random() * (ltcStartAgeMax - ltcStartAgeMin);
>   ...
> }
> ```

Per-trial randomness is fine when you run *thousands* of trials and
look at the distribution. The Monte Carlo tool supports several modes,
though, and one of them — `historical-sequence` — runs as a *single*
deterministic path through historical returns. Adding a coin flip into
a single-path simulation is a category error.

## What the AI reviewer caught

Codex flagged this as a **P2 finding** during its automated review of
PR #58, posted as an inline comment on
`src/app/lib/monte-carlo.ts:583`:

> **Prevent random LTC shock in single-path historical mode**
>
> This new LTC roll adds randomness per run, but historical-sequence
> mode still executes as a single run, so enabling self-insure LTC
> turns the result into one random draw rather than a stable estimate.
> In practice, identical inputs can flip between "LTC happened" and
> "LTC didn't happen," causing success rate and percentiles to jump
> unpredictably instead of reflecting the configured LTC probability.

That is the finding distilled. It correctly identifies:

- **The mechanism** — `Math.random()` runs once per trial, and
  `historical-sequence` only runs one trial.
- **The user-visible symptom** — identical inputs producing different
  results across runs.
- **The semantic break** — the result fails to "reflect the configured
  LTC probability," even though it nominally uses it.

PR #58 also got a P1 finding on a different file (pre-Medicare
healthcare being excluded from the new essential-floor calculation), so
the cross-vet caught two real issues on the same PR.

## What happened next

PR #58 merged with the P2 still open — a deliberate decision to land
the feature and fix the regression in a follow-up rather than block on
it. About 30 minutes later, [PR #59 — fix(monte-carlo): stabilize LTC
self-insure in single-run
modes](https://github.com/justice8096/retirement-dashboard-angular/pull/59)
opened with this in its body:

> Addresses **Codex P2 review** on
> [#58](https://github.com/justice8096/retirement-dashboard-angular/pull/58)
> (which had already merged) — the per-trial LTC random roll became a
> coin flip in `historical-sequence` mode (`effectiveRuns === 1`),
> making identical inputs flip between "LTC happened" / "didn't"
> between runs.

That is the AI proposer (Claude Code) explicitly attributing the issue
to the Codex review. The audit trail names its source.

## The fix and its sanity-check

The fix switches LTC behaviour by mode: random per-trial roll when
multi-run, expected-value when single-run.

> When `effectiveRuns === 1`, switch to **expected-value LTC**:
> - Always-on shock at the midpoint start age
> - Per-year deduction scaled by `ltcProbability`
> - Cross-trial average of the random mode equals the per-year EV
>   deduction → preserves intent without the noise
>
> Multi-run modes (`normal` / `bootstrap` / `regime`) keep the
> per-trial roll since percentile spread benefits from the bimodal
> distribution.

The PR body then includes an explicit math sanity-check:

> Random mode, per-year deduction during LTC window (averaged across
> many trials):
> - `P(LTC) × cost_per_year = 0.7 × $108K = $75,600/yr`
>
> EV mode, per-year deduction during LTC window:
> - `cost_per_year × ltcProbability = $108K × 0.7 = $75,600/yr` ✓

Both arrive at the same `$75,600/yr` expected per-year deduction.
That equality is what makes the fix legitimate: random-mode and
EV-mode produce the same *mean*, so swapping based on
`effectiveRuns === 1` preserves the simulation's first moment while
killing the noise.

## Why this case is load-bearing

A few things distinguish this from a generic "AI fixes its own bug"
story:

1. **The reviewer found a non-trivial correctness issue**, not a style
   nit or a typo. The bug doesn't break compilation or visibly crash;
   it silently degrades to noise in one of several modes. That's the
   class of issue automated review is supposed to catch and human
   review tends to miss.
2. **The fix is mathematically justified, not just plausible-looking.**
   Without the sanity-check, "use EV when single-run" might still drift
   from the random-mode mean in subtle ways. The PR body forces the
   author to show the equality.
3. **The audit trail is complete.** PR #58 has the inline Codex
   comment. PR #59's body links back. Anyone walking the trail later
   can see exactly what was found, who acted on it, and how the cure
   was validated.

## Where the methodology still has gaps

This case is also an honest illustration of where the methodology
shows its limits:

- **Codex caught the symptom; the human had to decide the fix.**
  Codex's comment proposed no specific remedy. Switching to EV-mode
  was a design choice — it could equally have been "raise N to ≥1000
  in single-run mode," "warn-and-clamp," or "disable LTC in
  single-run." The cross-vet flagged the bug; it didn't pick the
  treatment.
- **The merge happened before the fix.** PR #58 shipped with the P2
  still open. That's defensible (the bug only affects one mode, the
  fix landed within an hour) but it relied on the human to keep
  context. In a larger team or a longer gap, that's exactly where
  open findings get forgotten.
- **One human is making every call.** The proposer-fixer pair is
  the same AI session. The reviewer is the same Codex. The approver
  is the same human. This is robust to single failures, not to
  correlated ones — see
  [`../docs/failure-modes.md`](../docs/failure-modes.md), modes #1
  and #7.

## Reproducing this trail

If you want to see the public artefacts directly:

- PR #58 review:
  https://github.com/justice8096/retirement-dashboard-angular/pull/58#discussion_r3140759700
- PR #59 fix:
  https://github.com/justice8096/retirement-dashboard-angular/pull/59
- The kernel file involved:
  `src/app/lib/monte-carlo.ts` in `retirement-dashboard-angular`
  (around line 583 at PR #58 commit
  `302617b`, line numbers drift on subsequent commits).
