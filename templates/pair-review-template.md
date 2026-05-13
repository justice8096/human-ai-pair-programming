<!--
  Pair-review table — drop-in template for AI-Human Pair Programming
  with Cross-Vetting. One table per PR / discrete work unit. Both
  human and AI contribute; both sections must be non-empty for the
  pair-review to count.

  Save as PR description content, or as a per-PR file at
  `audits/pair-review-{PR-number}.md` (or equivalent), so the trail
  stays adjacent to the diff.

  Source: https://github.com/{org}/human-ai-pair-programming
-->

# Pair-review — {PR title or work-unit description}

**PR:** {link to PR or commit range}
**AI proposer:** {tool + version, e.g. Claude Code 4.7}
**AI reviewer:** {bot + version, e.g. Codex bot, n/a if none}
**Human approver:** {name}
**Date range:** {when this work happened}

---

## Section A — AI notes about human prompts / direction

What the AI flagged about the direction it was given. Captures the
ambiguity-resolution and prompt-interpretation work that conventional
review formats lose.

| Prompt / Direction | AI's note | Type | Resolution |
|--------------------|-----------|------|------------|
| {the prompt or instruction quoted or paraphrased} | {what AI flagged} | {Type} | {how it was resolved} |
| {next entry} | | | |

**Allowed values for Type:**
- `Ambiguity` — prompt could be read multiple ways; AI picked one
- `Multiple matches` — codebase has more than one applicable pattern
- `Conflict flag` — prompt conflicts with a prior instruction or
  documented convention
- `Risk flag` — proposed change touches a critical-path category
  (security, financial, life-safety, data-export)
- `Scope expansion` — fulfilling the prompt requires changes the
  prompt didn't name
- `AI-readability concern` — prompt or proposed approach has costs
  for AI's own future readability (file-load efficiency, context-
  window economy, single-file mental model). Use when the AI is
  flagging a constraint that exists because future AI sessions will
  read this code, not because human reviewers will.
- `Suggested refinement` — AI proposed a different direction than
  the prompt asked for, not covered by the more specific tags above

If you mark a row `Risk flag` or `Conflict flag`, the Resolution
column should explicitly name the human decision (e.g., "human
confirmed scope; second human reviewer added per critical-path
policy"). If you mark a row `AI-readability concern`, the Resolution
should name what the human chose between competing readability
optima (e.g., "narrowed scope to ≥200 LOC components — kept Angular
style rule but bounded its application").

---

## Section B — Human notes about AI implementation

Conventional code review, named explicitly as "human's notes on AI's
output" so the symmetry with Section A is visible.

| Implementation | Human's note | Type | Resolution |
|----------------|--------------|------|------------|
| {file:line or component / decision being commented on} | {what human flagged} | {Type} | {how it was resolved} |
| {next entry} | | | |

**Allowed values for Type:**
- `Style / convention` — codebase uses a different idiom
- `Logic` — correctness concern
- `Coverage gap` — missing test or edge case
- `Performance` — non-trivial perf impact
- `Security` — security-relevant concern
- `Disagreement-but-deferred` — human disagrees but accepts the
  AI's choice (e.g., "would have written it differently but this is
  fine")
- `Approved-as-is` — explicit positive note, useful for documenting
  that something was reviewed and intentionally left unchanged

If you have nothing substantive to put in Section B, the cross-vet
probably didn't engage. Either re-engage or note the work item didn't
need cross-vetting and explain why.

---

## Summary

**Cross-vet outcome:** {one sentence — what the cross-vet caught,
deferred, or confirmed}

**Critical-path category (if any):** {none / authentication / financial-
calculation / data-export / life-safety / other}

**Linked PRs / follow-up items:** {issues or PRs spawned from this
work; e.g., a Codex finding addressed in a follow-up PR}

---

## Notes on filling this template

- **Both sections must be non-empty.** If Section A has no entries,
  the AI didn't surface ambiguity or risk — re-read the conversation
  for things the AI flagged that didn't make it here. If Section B
  has no entries, the human didn't engage substantively with the
  output — review the diff again.
- **Substantive notes only.** "Nothing to add" / "looks fine" entries
  are noise. If a section is genuinely empty after honest review, say
  so in the Summary and explain why.
- **Granularity is per-PR.** Per-commit is too noisy; per-session
  aggregates too much. If a single PR has unusually broad scope,
  consider splitting the PR rather than splitting the table.
- **For multiple AI tools** (e.g., Claude Code as proposer + Codex
  as reviewer), subdivide Section B into "Notes on proposer" and
  "Notes on reviewer" — the methodology distinguishes the roles, the
  table should too.
- **Quoted material from public PR threads** (Codex findings, etc.)
  can be lifted verbatim — those are public. Internal reasoning
  conversations may need paraphrasing depending on org policy.
