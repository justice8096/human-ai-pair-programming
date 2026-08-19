# Claude briefing for this repo

## What this repo is

A methodology + working artifacts repo for **AI-Human Pair Programming with
Cross-Vetting** — see `README.md` and `METHODOLOGY.md`.

Spawned 2026-04-25 from extended pair-programming sessions on
`retirement-dashboard-angular` (PRs #56 → #61). The user is documenting and
formalizing the practice they noticed they were doing.

## How to work in this repo

This repo *is itself* an example of the methodology — your collaboration
here should embody what's documented in `METHODOLOGY.md`. Specifically:

1. **Propose freely** — you can suggest doc structure, additions, refactors.
   The user does the same. Either initiates.
2. **Cross-vet your own work** — when you propose a change, also flag the
   counter-arguments and weak points. Don't just sell the idea.
3. **The user is the approver** — never auto-commit / auto-push. Always
   leave the merge / publish action for the user (with one exception:
   if the user explicitly authorizes auto-merge for a specific class of
   change, e.g. "merge any PR that has CI green and Codex thumbs-up,
   for the next 2 weeks").
4. **Audit trail discipline** — when work spans multiple sessions,
   write summary notes (vault or in-repo `docs/sessions/`) so the next
   session has context.

## Cross-references

- Living methodology note (the one place to keep substantive thinking):
  `\\192.158.68.77\disk1\SecondBrainData\SoftwarePractices\AI-Human-Pair-Programming-Methodology.md`
- Adjacent regulatory references:
  `\\192.158.68.77\disk1\SecondBrainData\SoftwarePractices\AI-Regulations-*.md`,
  `\\192.158.68.77\disk1\SecondBrainData\SoftwarePractices\AI-Compliance-Evidence-Matrix-Poster.md`
- Origin sessions: `\\192.158.68.77\disk1\retirement-dashboard-angular` PRs #56–#61

## Open questions (carried forward from origin session)

1. Does the methodology degrade when proposer and reviewer share a model?
   Is genuine model-diversity required for the cross-vet to be load-bearing?
2. What's the right escalation when AI + AI both miss the bug?
3. Does adding more reviewers (`human + AI proposer + AI reviewer + 2nd human`)
   help, or is it diminishing returns?
4. What's the minimum competence baseline for the human reviewer?

## Initial scope

Repo is currently scaffolding. `docs/`, `examples/`, `templates/` subdirs
are placeholders. As the user explores the methodology, content will land
in those folders. Don't over-scaffold preemptively — let real artifacts
drive the structure.

## Style notes

- Minimal emoji (per user preference noted in retirement-dashboard work)
- Concise commit messages with `Co-Authored-By` trailer
- CC0 licensing per the project licensing strategy
- Markdown for docs; no preprocessor / static site generator unless the
  user asks
