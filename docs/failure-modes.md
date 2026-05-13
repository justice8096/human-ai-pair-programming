# Failure modes

Where this methodology breaks down, drifts, or gives a false sense of
rigor. Maintained as a living list; expand as practitioners hit new
modes in the wild.

For the methodology itself, see [`../METHODOLOGY.md`](../METHODOLOGY.md).
For the corresponding controls / mitigations, the
[`evidence-checklist.md`](evidence-checklist.md) is the operational
counterpart.

## The seven modes

### 1. Monoculture risk (proposer + reviewer share blind spots)

Both the AI proposer (e.g., Claude) and the AI reviewer (e.g., Codex)
are trained on largely overlapping corpora. If a wrong pattern is
common in their training data, both will treat it as correct. The
cross-vet does not detect it.

**Watch for:** finding the same idiom in multiple AI tools is *not*
evidence the idiom is correct. It may just be evidence the same
training data went into both. The methodology does not yet require
genuine model-diversity; this is open question #1 in
[`../CLAUDE.md`](../CLAUDE.md).

### 2. Hallucination cascade

The AI proposer suggests something subtly wrong. The AI reviewer fails
to flag it (either it agrees, or it focuses on different things). The
human, trusting the green CI + clean automated review, accepts.

**Watch for:** "the bot says it's fine" is a comfort signal, not a
correctness signal. If a change touches a non-obvious correctness
property (math, security, concurrency), the human needs to read it
themselves regardless of automated review status.

### 3. Reviewer competence drift

The human reviewer gets used to clicking accept. Over time, the
methodology degrades into "rubber-stamp by human" with extra steps. The
audit trail looks thorough; the actual review is shallow.

**Watch for:** a streak of accepts with no comments / no requested
changes is a yellow flag, not a green one. Sample your own review
behaviour every quarter — pull a random PR you approved and see if you
can still articulate *why*.

### 4. Audit-trail completeness

Conversation transcripts and PR threads are the evidence base. Default
tool behaviour evicts them — chat clients prune old conversations, IDEs
discard inline AI suggestions, draft PRs vanish on branch deletion. If
you didn't explicitly retain it, you don't have it.

**Watch for:** anything you can't reconstruct from a fresh `git clone`
+ public PR history is at risk. The
[`evidence-checklist.md`](evidence-checklist.md) lists what to retain
and where.

### 5. IP / copyright provenance

AI suggestions may contain verbatim training-data fragments. Vendor
ToS attempts to indemnify (Anthropic, OpenAI, Cursor each have their
own clauses), but no regulatory framework currently gates this. If the
AI-suggested code turns out to be copied, your repo carries the risk.

**Watch for:** suspiciously specific code that "just works" — e.g.,
named constants matching a known library's internals, or unusual
algorithms with no obvious derivation. When in doubt, rewrite from
specification rather than accepting verbatim.

### 6. Liability attribution

If an AI-suggested bug ships and causes harm, common-law product
liability still falls on whoever shipped it (the human, the org). The
AI vendor's ToS will not, in any current form, take that liability.
Contribution-attribution is murky enough that no court has cleanly
ruled on shared AI/human authorship yet.

**Watch for:** the "AI wrote it" defence does not work. Legally and
ethically, the merging human owns the change. Treat your sign-off
accordingly.

### 7. "AI competence" of the human reviewer is undocumented

The methodology assumes the human can spot AI hallucinations. No
framework requires you to demonstrate this skill, but the methodology
is unsafe without it. There is no industry-standard certification for
"can review AI-generated code competently."

**Watch for:** new joiners onboarded into the methodology without any
exposure to AI failure modes are at the highest risk. A short
internal "AI hallucinations I have seen" curriculum (real examples
from your own PRs) is more useful than a generic training course. This
is open question #4 in [`../CLAUDE.md`](../CLAUDE.md).

## Correlated failure: what if AI + AI + human all miss it?

Single-mode failures are what the methodology is designed for —
either the AI reviewer or the human will catch the AI proposer's
mistake. Correlated failures (all three miss) are the residual risk.
The retirement-dashboard origin sessions had several Codex catches that
the AI proposer missed, and several human catches that Codex missed —
but also at least one issue all three missed initially, surfaced only
on a later session's read-through.

The honest answer is that this methodology reduces but does not
eliminate residual risk. Domains with zero-tolerance for residual risk
(life-safety, financial-material) need a layer beyond what this
methodology provides — see the
[`regulatory-mapping.md`](regulatory-mapping.md) note on DO-178C / SOX.

## Out of scope for this document

- **Operational controls** that mitigate the modes above — those live
  in [`evidence-checklist.md`](evidence-checklist.md) as actionable
  items
- **Tooling defects** (a specific bug in Claude Code or Codex) — those
  are vendor problems, not methodology failure modes
