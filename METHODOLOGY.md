# AI-Human Pair Programming with Cross-Vetting — One-Page Spec

Version 0.1 (2026-04-25). Living document.

## Definition

A development workflow where:

1. **Both AI and human propose ideas** — code changes, refactors, designs.
2. **Both AI and a second AI cross-review proposals** — typically the proposer
   AI plus an independent automated reviewer (e.g. Codex on GitHub PRs).
3. **The human is the accountable approver** — final merge / deploy / ship
   decision rests with the human.
4. **Full audit trail** — PR comments, commits, AI conversation transcripts.

## Required controls

| # | Control | Why |
|---|---------|-----|
| 1 | Human is named approver on every change | Liability + regulatory compliance |
| 2 | Independent automated reviewer (different vendor / model preferred) | Avoid monoculture risk where proposer + reviewer share blind spots |
| 3 | Conversation transcript retained | Audit evidence; future debugging |
| 4 | Critical-path exceptions documented | Some changes (security, financial) require human-only or extra-human review |
| 5 | AI tool inventory in change-management policy | SOC 2 / ISO 27001 expect known tooling |

## Workflow

```
Human or AI:    propose change
AI:             implement (with verification: build, lint, test, browser preview)
AI:             open PR / submit for review
2nd AI (Codex): independent automated review
AI:             address findings (may surface to human if disputable)
Human:          review the AI's reasoning + automated findings + any human-spotted issues
Human:          merge / approve
```

## Where it differs from existing practices

| Practice | Comparison |
|----------|------------|
| **XP pair programming** | One pair member is AI; cycle includes async PR review by a third (AI) party |
| **One-human PR review** | Adds AI proposer + AI reviewer as additional perspectives |
| **Solo development with AI autocomplete** | Adds independent cross-vetting; no auto-merge |
| **Autonomous AI agents** | Human is mandatory in approval loop; no ship-without-review |

## Where it fits regulatory frameworks

See `docs/regulatory-mapping.md` for detail. Summary: no framework specifically
targets this methodology yet, but it generally **exceeds** the floor set by
NIST SSDF, SOC 2, ISO 27001, and EU AI Act Article 14 (when applicable).

## Where it breaks down

See `docs/failure-modes.md`. Top risks:

1. **Monoculture** — proposer + reviewer share training-data blind spots
2. **Hallucination cascade** — AI proposer's wrong suggestion goes unflagged
   by AI reviewer, human accepts both
3. **Reviewer competence drift** — human gets used to clicking accept
4. **Audit-trail completeness** — conversation history needs explicit
   retention; default tool behavior may evict it

## Minimum viable adoption

To adopt this methodology in your repo:

- [ ] Use an AI coding assistant for proposals (Claude Code, Cursor, etc.)
- [ ] Enable an independent automated PR reviewer (Codex bot, CodeRabbit,
      Anthropic Cloud Code Review, etc.)
- [ ] Require human approval on every merge (branch protection)
- [ ] Document this practice in your repo's `CONTRIBUTING.md` or equivalent
- [ ] Retain PR threads and AI conversation transcripts
