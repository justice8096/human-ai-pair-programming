# Article — baseline paragraph draft

Draft text for the article's "baseline-of-sorts" paragraph (likely
landing in §3 — worked example, or as a brief framing in §6 —
failure modes). Honest about what the data shows and doesn't show.

For the underlying data, see
[`../audits/codex-findings-data-2026-04-25.md`](../audits/codex-findings-data-2026-04-25.md).

---

## Draft (~200 words, two paragraphs)

> Across the six origin PRs (#56-#61) merged on 2026-04-24 to
> 04-25, the AI reviewer (Codex) posted **eight inline findings: one
> P1 and seven P2.** Five PRs received findings; one (#60) was
> reviewed clean. Two findings are confirmed actioned in subsequent
> commits or follow-up PRs (PR #58's P2 → PR #59 with mathematical
> verification; PR #61's P2 → commit 0039ef4). The remaining six
> have unverified resolution status as of 2026-04-25 — they may have
> been silently fixed within their originating PRs before merge,
> deferred to follow-up work, or accepted-as-risk.
>
> This is not a controlled comparison. The data does not measure
> what a solo human reviewer would have caught on the same diffs,
> and there is no false-positive count for findings the human
> reviewer might have rejected as wrong. What the data does show is
> that the cross-vet generated **substantive review activity** —
> averaging 1.33 findings per PR with at least one finding of P1
> severity (a real correctness regression in newly-introduced
> code) — at a rate that suggests the AI reviewer was engaging,
> not rubber-stamping. The article's claim is about the
> **structure** of the methodology (asymmetric epistemic sources;
> audit-trail discipline; human as accountable approver), not about
> a measured catch rate. The data is illustrative, not probative.

---

## Why this framing

Three honesty constraints baked in:

1. **No "X% catch rate" claim.** Numerator without denominator.
   We have findings-found, not bugs-introduced. Without ground
   truth on the latter, claiming a rate would be overreach.
2. **No "would have missed without cross-vet" claim.** Untested.
   Solo human review on the same diffs might have caught the same
   findings, different findings, or more findings. The article
   doesn't pretend to know.
3. **Names the resolution-status gap.** Six of eight findings are
   unverified. The article says so explicitly rather than implying
   all eight were addressed.

## Where this paragraph lands in the article

Two viable placements:

- **Inside §3 (worked example, PR #59 deep dive)** — as a single
  paragraph immediately after the verbatim Codex P2 quote, framing
  the deep-dive as one instance of a broader pattern. Keeps §3
  self-contained.
- **In §6 (failure modes), under mode #2 (hallucination cascade)**
  — as evidence the cross-vet engaged substantively (so the failure
  mode is real but not the dominant pattern). Strengthens §6 but
  splits the data away from the worked example.

Recommendation: **§3**, because the data and the deep-dive use the
same source material and benefit from being adjacent.

## Counter-arguments to anticipate

A reviewer could push:

- **"1.33 findings per PR is low — solo review typically finds
  more."** Possibly true for skilled reviewers; depends on PR size
  and complexity. The article shouldn't claim 1.33 is *high*; just
  that it's *non-trivial*. If a reviewer wants more, that's fair —
  the methodology doesn't claim to replace careful human review,
  it claims to add a layer.
- **"P2 findings are minor."** Codex's P2 includes correctness
  issues (the LTC-shock case in PR #58 was P2 and was a real
  regression). Severity tags are not the same as importance. The
  article should note this in passing.
- **"The 6/8 unverified rate looks bad."** Honest answer: it
  reflects the audit-trail-completeness failure mode the article
  itself names. Resolution status decays into noise without active
  tracking — which is exactly why the
  [audit-artifacts framework](audit-artifacts.md) calls per-instance
  resolution tracking out as a per-PR artifact.

## Optional extension — verifying the 6 outstanding findings

If the article wants to strengthen the data, a 1-2 hour pass
through PR #56's two findings, PR #57's one, PR #58's P1, PR #59's
one, and PR #61's other — each PR's commit history between Codex
review and merge — would let the article say "X of 8 confirmed
actioned" with a higher X. Worth doing if drafting time allows;
not gating.
