# Article — threats-to-validity section draft

Draft for the article's threats-to-validity / honesty section
(targets §5.5 or as a dedicated late-article section before the
forward-look). Pulls together the limits the article should name
explicitly rather than burying.

For section sizing: ~600 words; can compress to 400 if space is
tight, or expand to 900 if reviewers want more rigor.

---

## Draft prose

### Threats to validity

This article presents an articulated methodology with illustrative
data and a structural legal framing. It does not present a
controlled study. Several limits are worth naming explicitly so
that readers can calibrate the claims appropriately.

**Single-practitioner evidence base.** The methodology was
articulated from extended pair-programming sessions on a single
repository (`retirement-dashboard-angular`), by a single
practitioner, using a single AI proposer (Claude Code) and AI
reviewer (Codex bot) pair, over a 24-48 hour time window
(2026-04-24 to 04-25). The six origin PRs and eight Codex findings
analyzed in §3 and §6 are not a sample drawn from a broader
distribution — they are the entire population of a brief,
specific working session. Any claim about "what works" should be
read as "what worked for this practitioner in this window," with
generalization treated as a hypothesis to be tested by other
adopters.

**Structural-not-doctrinal legal framing.** The "AI as paid code
intern" analogy presented in §1 and §4 is a *structural* fit between
AI use and existing supervised-trainee law. No court has explicitly
adopted this framing for AI in software development. Existing
precedent supports specific elements (work-for-hire for paid
interns; respondeat superior; trainee standard of care from
*Jistarri v. Nappi*; German BGB Erfüllungsgehilfen) but the
synthesis is the article's claim, not a citable doctrine. Competing
framings exist and are noted in §4.5: *defective product*
(in defamation cases), *delegated agent* (Workday line in employment
discrimination), and *Kovel-style professional agent* (rejected in
*US v. Heppner*). The article's contribution is to argue the
trainee framing fits code review specifically — not to claim it has
been judicially adopted.

**Data is illustrative, not probative.** The §3 data on Codex
findings (eight inline findings across six PRs; one P1, seven P2;
two confirmed actioned, six with unverified resolution status) is
observational and bounded. It supports the claim that the cross-vet
engaged substantively. It does not support claims about catch rate
relative to a solo-reviewer baseline (no comparison), false-positive
rate (uncounted), or comparative effectiveness (no controlled
condition). Readers wanting empirical grounding for the
methodology's effectiveness should treat this article as motivation
for that study, not as the study itself.

**Self-reference and authorship.** This article was produced under
the methodology it describes, with substantive intellectual
contributions from both the human author and Claude (the AI
proposer). The audit trail captures attribution at the per-section
and per-argument level (see [REPO]/audits and the project's
session note). Readers concerned about AI involvement in the
article's own claims can examine that trail directly. The article
takes the position that disclosing this is more honest than the
conventional alternative of treating AI involvement as invisible.

**Evolutionary instability.** Three forces will likely change the
picture within 1-2 years and may invalidate specific claims:

- **Model and vendor changes** — The specific AI tools (Claude Code
  4.7; Codex bot via GitHub) that produced the origin-session data
  will be superseded. The methodology's structural claims survive
  this; specific tool-behavior claims may not.
- **Regulatory development** — TRAIGA's affirmative defense (Tex.
  Bus. & Comm. Code Ch. 552, eff. 2026-01-01) is untested in
  litigation. The EU AI Act enters its high-risk phase in 2026.
  ISO/IEC 5339 and NIST SSDF v2 are in draft. The article's legal
  anchors will likely tighten or shift; the methodology will need
  to update accordingly.
- **AI capability shifts** — If AI tools acquire substantial
  internal-corporate knowledge (via fine-tuning, RAG, persistent
  context), the asymmetric-epistemic-source argument (§1.5) weakens.
  The methodology then has to rest more on the legal-structural
  argument and less on the epistemic-complementarity one.

**Adoption-context untested.** The methodology has not been
validated at organizational scale (multi-team, multi-jurisdiction,
or under formal audit). The pair-review template, audit-artifacts
framework, and per-publication attribution practice work on a
single-practitioner, single-repo basis; their behavior in larger
contexts (rate limits on AI tools, coordination across reviewers,
audit-trail aggregation) is conjectural.

---

## What this section accomplishes

It pre-empts the most likely reviewer pushbacks by naming them
first. CACM Practice editorial standards reward this honesty —
"practicality and rigor" includes acknowledging where the article's
claims are bounded.

It also gives the article a clean answer to the inevitable "is
this an experience report or an empirical study?" question:
**experience report**, with structured legal framing, illustrative
data, and bounded claims.

## What this section does *not* try to address

- **Future research design** — the article doesn't propose a
  controlled study or a comparative trial. That would be a
  follow-up academic paper, not a CACM Practice piece.
- **Counter-claims to specific failure modes** — those live in §6,
  paired with the modes themselves.
- **Detailed jurisdictional limits beyond the named cases** —
  exhaustive cross-jurisdictional treatment would inflate the
  article past its word budget. The
  [`regulatory-mapping.md`](regulatory-mapping.md) doc points to
  the adjacent vault notes for readers who want depth.

## Connection to other sections

- §1.5 (epistemic complementarity) — the "AI capability shifts"
  paragraph above directly addresses what could weaken §1.5's
  argument; cross-reference suggested.
- §4 (TRAIGA + NIST AI RMF) — the "evolutionary instability"
  paragraph notes that the legal anchor is recent and untested,
  which §4 should foreshadow rather than be surprised by.
- §6 (failure modes) — overlaps with mode #1 (monoculture), mode
  #4 (audit-trail completeness), and mode #7 (reviewer competence).
  The threats-to-validity section is the article's "we know these
  modes apply to this article specifically" attestation.
