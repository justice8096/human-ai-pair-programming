# Evidence checklist

A runnable checklist for adopting and auditing this methodology. Use it
when preparing for a SOC 2 / ISO 27001 / EU AI Act audit, or when
introducing the practice to a new repo and you want to make sure you
haven't skipped a load-bearing control.

For framework fit, see [`regulatory-mapping.md`](regulatory-mapping.md).
For what fails when controls slip, see
[`failure-modes.md`](failure-modes.md).

## Methodology controls

These are the controls the methodology declares. Evidence for each
should exist on disk or in a versioned system.

- [ ] **Human is named approver on every change** — branch protection
  enforces this; no auto-merge from AI proposer or AI reviewer.
  *Evidence:* repo branch protection settings; merge commits show
  human author.
- [ ] **Independent automated reviewer is configured** — different
  vendor / model from the proposer where possible.
  *Evidence:* CI config, bot user listed on PRs.
- [ ] **Conversation transcript retained** — proposer-side
  conversations are kept, not just the resulting commits.
  *Evidence:* exported conversation files, or in-tool history with a
  documented retention policy.
- [ ] **Critical-path exceptions documented** — security, financial,
  or life-safety changes have a stricter review path declared.
  *Evidence:* `CONTRIBUTING.md` or equivalent names the categories and
  the stricter path.
- [ ] **AI tool inventory in change-management policy** — the
  proposer and reviewer tools are listed, not assumed.
  *Evidence:* policy doc with current tool versions and vendors.

## Audit-readiness items

These come from the vault note's pragmatic readiness checklist and
extend the controls above with operational follow-through.

- [ ] **One-page methodology document exists** — names the controls
  (cross-vetting, audit trail, accountable human approver) in plain
  language. (This repo's [`../METHODOLOGY.md`](../METHODOLOGY.md) is
  a starting point; copy and adapt.)
- [ ] **AI tools and their roles are documented in change-management
  policy** — not just "we use AI" but "Claude Code is the proposer,
  Codex is the reviewer, here are their access scopes."
- [ ] **PR + AI conversation transcripts are retained** — with a
  declared retention period (recommend: lifetime of the codebase, or
  at minimum 7 years for financially-regulated work).
- [ ] **Escalation criteria are defined** — when does human-only
  review become mandatory? Examples: changes to
  authentication / authorization, changes to financial calculations,
  changes to data-export paths.
- [ ] **Periodic competence assessment of human reviewers** —
  informal is fine, but auditors will ask. Recommend: quarterly
  spot-check where the reviewer pulls a random PR they approved and
  re-justifies the decision.
- [ ] **Vendor due diligence on AI tools** — ToS reviewed for IP
  indemnification, training-data provenance claims, and data-handling
  terms. Re-check on every major vendor version change.

## Adopting in a new repo (minimum viable)

If this is the first time setting up the methodology somewhere, the
short list is:

- [ ] Use an AI coding assistant (Claude Code, Cursor, Copilot, etc.)
- [ ] Enable an independent automated PR reviewer (Codex, CodeRabbit,
  Anthropic Cloud Code Review, etc.)
- [ ] Require human approval on every merge (branch protection, no
  exceptions for AI bots)
- [ ] Drop a methodology declaration into `CONTRIBUTING.md` — the
  [`../templates/CONTRIBUTING-snippet.md`](../templates/CONTRIBUTING-snippet.md)
  is a starting point
- [ ] Decide a retention plan for PR threads and AI conversation
  transcripts

The full checklist above can be deferred until first audit.

## Where this checklist falls short

This is a methodology-level checklist. It does not substitute for:

- Domain-specific controls (DO-178C, IEC 62304, SOX) — those still
  apply on top
- Jurisdictional compliance (EU AI Act Article 14, China algorithm
  filing, etc.) — see [`regulatory-mapping.md`](regulatory-mapping.md)
  and the adjacent vault notes referenced there
- Standard secure-SDLC items (SAST, DAST, SBOM, dependency review) —
  those are pre-existing; this methodology adds to them, doesn't
  replace them
