# Examples

Real cases of the AI-Human Pair Programming with Cross-Vetting
methodology in action. The examples here are drawn from public PRs
on `retirement-dashboard-angular`, the repo where the methodology
was first articulated.

## Why these examples exist

The methodology is short to describe (see
[`../METHODOLOGY.md`](../METHODOLOGY.md)) but easy to misread as
"some hand-wavy AI involvement." The examples make the concrete
shape visible: who proposed what, what the AI reviewer caught, what
the human caught, what slipped through.

## How to read them

Each example tries to answer four questions:

1. **Who proposed the change?** Human-initiated or AI-initiated?
2. **What did the AI reviewer (Codex) flag?** Quote the actual finding,
   not a paraphrase. Findings hide in inline review comments, not
   the top-level PR review.
3. **Who acted on the finding?** AI proposer (in a follow-up PR),
   human (in-line edit), or did it get accepted-as-risk?
4. **What did the human catch that the bots missed?** Or vice versa.
   This is where the cross-vet earns its keep.

## What's here

| File | Type | Why it's worth reading |
|------|------|------------------------|
| [`origin-sessions-pr56-pr61.md`](origin-sessions-pr56-pr61.md) | Overview | All six origin PRs in one table — what each did, whether Codex reviewed, what the cross-vet moments were. Best entry point. |
| [`pr-59-codex-feedback-loop.md`](pr-59-codex-feedback-loop.md) | Deep dive | The clearest single demonstration of the methodology working: Codex P2 finding on PR #58 → AI fix in PR #59 with explicit math sanity-check that EV-mode equals random-mode average. |
| [`pr-60-human-spots-dyscalculia-gate.md`](pr-60-human-spots-dyscalculia-gate.md) | Deep dive (counterpart to #59) | The opposite direction: human caught a long-standing dead-code dyscalculia gate (with silent inconsistency underneath) that neither AI proposer nor AI reviewer flagged across multiple prior PRs. Codex review on #60 was clean. Demonstrates the asymmetric-epistemic-source argument: the human supplies the unobservable internal layer. |
| [`pair-review-2026-04-25-article-planning.md`](pair-review-2026-04-25-article-planning.md) | Worked template application | The pair-review template ([`../templates/pair-review-template.md`](../templates/pair-review-template.md)) applied to the multi-hour planning session that produced the audit-artifacts framework and the template itself. Demonstrates Section A / Section B discipline; honest about post-hoc reconstruction limits. |

## What this directory will probably grow into

Over time, examples should accumulate as the practice meets new
situations. Patterns worth a dedicated example file:

- A finding that **all three perspectives missed** initially and
  surfaced later — the residual-risk case
- A finding where the **AI proposer disagreed with the AI reviewer**
  and the human had to adjudicate
- A change in a **critical-path category** (security, financial)
  where the methodology required a second human reviewer
- A multi-month **case study repo** that adopted the methodology cold
  and tracked the result

These are placeholders, not commitments. New examples land when there
is something genuinely novel to show, not on a calendar cadence.
