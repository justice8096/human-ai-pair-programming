# Deep dive — PR #60 and what the human caught that the bots missed

The counterpart to the [PR #59 case
study](pr-59-codex-feedback-loop.md). Where #59 showed the AI
reviewer catching a bug the AI proposer introduced, #60 shows the
**human catching a long-standing inconsistency that no AI flagged** —
including, crucially, the AI proposer that wrote the code in the
first place and the AI reviewer (Codex) that left the PR clean of
findings.

For methodology context, see
[`../METHODOLOGY.md`](../METHODOLOGY.md). For the broader origin-
session context, see
[`origin-sessions-pr56-pr61.md`](origin-sessions-pr56-pr61.md).

## Setup

[PR #60 — refactor: extract shared currency / FIRE / location /
scenario helpers](https://github.com/justice8096/retirement-dashboard-angular/pull/60)
landed on 2026-04-25 as a deduplication pass following the audit
that came out of the PR #56-#59 feature burst. It was an explicitly
non-feature change: extract three shared helpers (`fire-math.ts`
constants, `CurrencyFormatService`, `LocationService` methods) and
migrate the six biggest screens onto them.

Codex reviewed the PR and posted **no findings**. That makes #60
the only PR in the origin-session window that came back clean from
the AI reviewer.

But the human, while doing the refactor, found something the
methodology's two AI tiers had not flagged across multiple prior
PRs — long-standing dead code with a silent correctness inconsistency
underneath it.

## What the human spotted

From the PR body:

> **Removing the dead-code dyscalculia gate in `fmt()` wrappers**
> (long-standing inconsistency where the dyscalculia branch added
> `'/mo'` suffix but the fallback didn't):
>
> - Lump-sum displays now consistent across dyscalculia on/off
> - `fees-screen.fmtUsd` now consistent at 2 decimal precision in
>   both modes (was rounding to whole dollars in dyscalculia mode
>   only)

Three distinct findings nested in that paragraph:

1. **The dyscalculia-gate code was dead.** Every screen had its own
   thin `fmt()` wrapper doing
   `dyscalculia.isEnabled() ? formatCurrency(x) : '$' + ...`. But
   `DyscalculiaService.formatCurrency` already handles the disabled
   case internally — the per-screen check was redundant.
2. **The dead code carried a silent inconsistency.** The dyscalculia
   branch suffixed values with `'/mo'`; the fallback branch didn't.
   Result: lump-sum displays disagreed across modes for years
   without anyone noticing.
3. **One screen had a precision regression.** `fees-screen.fmtUsd`
   rounded to whole dollars in dyscalculia mode only — silently
   different precision than the other modes.

None of these were caught by the AI proposer (which had been
reading and writing the code repeatedly across PRs #56-#59) or by
Codex (which had reviewed each of those PRs without flagging).

## Why neither AI tier caught it

This is the article-relevant question. The methodology's claim is
that AI proposer + AI reviewer + human approver are
*complementarily* useful — bringing different epistemic sources to
the review. PR #60 is the case where the asymmetry shows up.

**The AI proposer didn't catch it** because:

- The dead code was *consistent* with adjacent code (every screen
  had its own `fmt()` wrapper). Pattern-matching on consistency
  doesn't surface dead code that's uniformly distributed.
- The inconsistency between dyscalculia branches required reading
  *across* the conditional and noticing a divergence the conditional
  was supposed to bridge. AI-proposer attention was on *adding*
  features, not on *auditing* prior conventions.

**The AI reviewer didn't catch it** because:

- The reviewer was reading diffs, not full files. The dead code was
  pre-existing in the files being touched but wasn't being modified
  — so it didn't appear in the diff Codex reviewed.
- "Dead code that's consistent with surroundings" is the exact
  pattern automated review tools tend to miss, because their
  reasoning is local-to-the-diff.

**The human caught it** because:

- Refactoring requires reading the full file, not just the diff. The
  human encountered every `fmt()` wrapper while doing the extraction
  pass, and the inconsistency surfaced when reading them in
  sequence.
- The human had **internal context** — knowledge that
  `DyscalculiaService.formatCurrency` already handled the disabled
  case, which made the per-screen gate redundant. This is exactly
  the "unobservable internal layer" that the methodology's
  asymmetric epistemic structure attributes to the human role.

## What this case demonstrates

Three things worth pulling out for the article:

1. **The cross-vet works in both directions.** PR #59 showed AI
   catching what humans might miss (subtle correctness issue in
   single-run mode). PR #60 shows humans catching what AIs miss
   (dead code with silent inconsistency that's invisible to local-
   diff review). Neither tier alone is sufficient.

2. **Codex review being clean is not the same as the code being
   clean.** The methodology's failure-mode #2 (hallucination
   cascade — AI proposer wrong, AI reviewer fails to flag, human
   accepts) is structurally identical to "long-standing pre-existing
   issue, AI reviewer doesn't see it because it's not in the diff."
   Both surface only when the human engages substantively, not just
   procedurally.

3. **Refactor PRs are where pre-existing-bug detection happens.**
   New-feature PRs introduce code in isolation; refactor PRs require
   reading the surrounding code. The methodology should expect
   different finding distributions between these two PR types — and
   the article's failure-modes section can name "refactor PRs as the
   pre-existing-bug discovery surface" as a positive characteristic
   of the methodology, not a failure.

## What this case does *not* demonstrate

Honesty for the article:

- **It's a sample of one.** One refactor PR finding three
  pre-existing issues isn't a rate. The article should not generalize
  to "human reviewers catch X% of bugs that bots miss."
- **The human's "internal context" advantage is partially
  toolable.** Future AI proposers with full-codebase context and
  refactor-aware reasoning may close some of the gap. The asymmetric
  epistemic structure isn't permanently human-favored on this kind
  of finding.
- **Codex's "clean review" was technically correct** for the diff it
  reviewed. The pre-existing dead code wasn't being changed by PR
  #60. A reviewer applying strict diff-locality rules would mark
  this PR clean too — Codex isn't worse than a strict human reviewer
  in that mode.

## Reproducing this trail

If you want to see the public artefacts directly:

- PR #60:
  https://github.com/justice8096/retirement-dashboard-angular/pull/60
- The PR body's "Behavior fixes" section calls out the dead-code
  gate explicitly, so the discovery is documented at merge time.
- The commit `46c9531` ("refactor: extract CurrencyFormat /
  location-cost / scenario helpers") contains the actual
  removal-and-fix.

## Connection to the methodology's epistemic structure

This case is the cleanest evidence the article has for the
asymmetric-epistemic-source argument from the
[methodology spec](../METHODOLOGY.md). The human's contribution to
PR #60 wasn't external-knowledge review (Codex would have caught
that). It was internal-knowledge review — knowing that
`DyscalculiaService.formatCurrency` already handled the disabled
case, knowing the codebase's history of `'/mo'` suffix
conventions, and bringing the refactor-induced reading of full
files together with that internal context.

The methodology's "human approver" role is doing exactly what the
asymmetric-epistemic-source argument predicts: supplying the
unobservable internal layer that the AI tiers can't access. PR #60
is the case where that layer was load-bearing.
