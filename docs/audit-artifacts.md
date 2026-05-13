# Audit artifacts

What every project applying the AI-Human Pair Programming with Cross-
Vetting methodology should produce and retain. Organized by cadence:
some artifacts are per-instance (per PR), others are per-session,
per-project, per-period, or per-publication.

For the methodology itself, see [`../METHODOLOGY.md`](../METHODOLOGY.md).
For adoption-focused checklists, see
[`evidence-checklist.md`](evidence-checklist.md). For per-audit
report skeletons, see
[`../templates/audit-report-template.md`](../templates/audit-report-template.md).
For the operational template implied by the per-instance pair-review
table below, see
[`../templates/pair-review-template.md`](../templates/pair-review-template.md).

## Why cadences matter

Different audit questions need evidence at different time scales.
"Was this specific PR cross-vetted?" needs per-instance artifacts.
"Is the methodology still being followed?" needs per-period checks.
"What AI contributed to this article?" needs per-publication
attribution. Bundling all artifacts together produces an audit trail
that's either too noisy (everything per-PR) or too sparse (only
quarterly summaries).

The five cadences below are recommended; an org can collapse some
(e.g., merge per-period and per-project) but should not skip any
entirely.

## 1. Per-instance — per PR / commit / discrete work unit

| Artifact | Source | Automatic? | Retention |
|---------|--------|:----------:|-----------|
| PR thread (diff + reviews + resolutions) | Forge (GitHub / GitLab / etc.) | Yes | Lifetime of repo |
| AI proposer conversation transcript | Local AI-tool history (Claude Code / Cursor / etc.) | **Semi — needs export discipline** | Lifetime of repo, or 7 yr for regulated work |
| AI reviewer comments | Forge bot integration (Codex / CodeRabbit / etc.) | Yes | Lifetime of repo |
| Commit messages with `Co-Authored-By` trailers | Forge | Yes | Lifetime of repo |
| **Pair-review table (Sections A + B)** | **Authored per PR; both human and AI contribute** | **No — discipline required** | **Lifetime of repo** |

The pair-review table is the artifact that makes pair programming
structurally visible — see "The pair-review table" section below.

**Failure if missing:** the cross-vet trail isn't reconstructable.
The most-frequently-lost element in practice is the AI proposer
transcript — local tool history evicts old conversations by default.
An export discipline (or a scheduled archival job) should run weekly
or per-PR.

## 2. Per-session — per work session, typically per day

| Artifact | Source | Automatic? | Retention |
|---------|--------|:----------:|-----------|
| Session summary | Vault (Obsidian / similar) or repo `docs/sessions/` | No | Lifetime of project |
| Decision log entries (non-obvious calls only) | Same | No | Lifetime of project |
| Attribution notes — who/what introduced which idea | Same | No | Lifetime of project |
| Open-questions / what's-next list | Same | No | Until resolved |

The attribution-notes line is what answers per-session attribution
questions: when AI introduced a substantive analytical argument or
when the human introduced an observation that reframed the work, the
session note records it explicitly. This is the substrate the per-
publication attribution document later draws from.

**Failure if missing:** continuity across sessions fails; new
sessions repeat earlier work; per-publication attribution is
reconstructed (badly) from memory.

## 3. Per-project — running, single source of truth per project

| Artifact | Why | Owner | Storage |
|---------|-----|-------|---------|
| Methodology declaration | Auditor / contributor expectation-setting | Project | `CONTRIBUTING.md` |
| Model / version log | Reproducibility, deprecation defense, evidentiary authentication | Project | Single file (e.g., `docs/ai-tools-log.md`) |
| Vendor inventory | Change-management policy compliance, ToS tracking | Org or project | Either |
| Failure-mode incident log | Empirical evidence of methodology effectiveness; required for honest threats-to-validity in any publication | Project | `audits/methodology-incidents.md` |
| Critical-path category list | Defines when human-only review applies (security, financial, etc.) | Project | `CONTRIBUTING.md` |

**Failure if missing:** can't answer "what AI tools were in use when
this code was written" — which becomes load-bearing under TRAIGA-style
affirmative-defense claims and during model-deprecation events.

## 4. Per-period — quarterly recommended; varies by org

| Artifact | Why | Owner |
|---------|-----|-------|
| Reviewer competence assessment | Audit-readiness checklist item; spot-checks against rubber-stamping | Reviewer (self-assessment OK if documented) |
| Compliance check against [`evidence-checklist.md`](evidence-checklist.md) | Methodology drift detection | Project lead |
| Methodology drift check — are we still doing what we said? | Catches degradation before it accumulates | Project lead |
| AI tool inventory refresh | Vendor changes, ToS updates, new model versions | Org |

**Failure if missing:** methodology decays into rubber-stamping over
time without anyone noticing. This is failure-mode #3 (reviewer
competence drift in [`failure-modes.md`](failure-modes.md))
operationalized into a recurring control.

## 5. Per-publication — per article, talk, blog post, white paper

| Artifact | Why |
|---------|-----|
| AI contribution disclosure document | Direct response to the moral-attribution gap (see `failure-modes.md` if it lands as a documented mode) |
| Argument-by-argument attribution map | "Section §3.2 introduced via Claude 4.7 conversation [link]; refined collaboratively; final form approved by [human]" |
| Audit trail link for verification | Lets readers verify attribution honesty |
| Methodology compliance attestation | Confirms the publication itself was produced under the methodology |

**Failure if missing:** the methodology declares audit trails are
load-bearing; a publication that uses the methodology but doesn't
disclose this is internally inconsistent.

## The pair-review table

Per-instance artifact specific to this methodology. Two sections per
work item — each side fills the table about the other. Captures the
bidirectional nature of pair programming that conventional code-review
formats lose.

### Section A — AI notes about human prompts / direction

What the AI flagged about the direction it was given: ambiguity,
multiple interpretations, conflicts with prior instructions, risk
flags, scope expansions, suggested refinements.

| Prompt / Direction | AI's note | Type | Resolution |
|--------------------|-----------|------|------------|
| (the prompt or instruction) | (what AI flagged) | one of: `Ambiguity`, `Multiple matches`, `Conflict flag`, `Risk flag`, `Scope expansion`, `AI-readability concern`, `Suggested refinement` | (how it was resolved) |

The `AI-readability concern` type is specific to this methodology
and worth naming. AI proposers, when reading and writing code, have
their own future-readability constraints — file-load efficiency,
context-window economy, single-file mental model. These sometimes
conflict with conventions designed for human readability (the
classic example: extracting templates per Angular style guide rule
05-04 vs. keeping small components inline so future AI sessions
need fewer `Read` tool calls). When the AI flags a refinement based
on these constraints, the entry deserves its own type tag — not
because it's more important than `Suggested refinement`, but
because it's structurally distinct: the AI is reasoning about
future-AI use of the code, which is a different argument shape
than reasoning about correctness or code quality.

### Section B — Human notes about AI implementation

Conventional code review, named explicitly as "human's notes on AI's
output" so the symmetry with Section A is visible.

| Implementation | Human's note | Type | Resolution |
|----------------|--------------|------|------------|
| (the code / decision being commented on) | (what human flagged) | one of: `Style / convention`, `Logic`, `Coverage gap`, `Performance`, `Security`, `Disagreement-but-deferred`, `Approved-as-is` | (how it was resolved) |

For the drop-in template, see
[`../templates/pair-review-template.md`](../templates/pair-review-template.md).

### Why both sections matter

- **Mirrors familiar review formats.** Section B is exactly what code
  reviewers already do; Section A is the shape of requirements /
  design review. Adopters don't have to learn a new genre.
- **Forces AI's contributions to be visible.** AI conversations are
  long-form and lossy; the structured table is the durable artefact.
  Without Section A, AI's interpretation work disappears into noise.
- **Addresses moral attribution at the per-PR level.** The audit
  trail isn't just "AI was used"; it's "here are the specific calls
  AI made on the prompts, and here's how the human responded."
- **Symmetric form, asymmetric content.** Same table shape both
  directions, but Section A catches *prompt-level* concerns
  (which conventional review doesn't have a slot for) and Section B
  catches *implementation-level* concerns. The asymmetric epistemic
  structure (AI's external knowledge vs. human's internal tacit
  knowledge) shows up in *which* notes get written, not in the
  format itself.

### Failure modes specific to this artifact

- **Asymmetric filling.** If humans fill Section B but skip Section A,
  AI's contributions stay invisible — the exact failure mode the
  artifact was meant to fix. Tooling can enforce both sections being
  non-empty before merge; absent that, per-period drift checks should
  flag PRs with empty Section A.
- **Performative filling.** "Nothing to add" entries make the table
  noise. Substantive notes only — if neither side has anything to
  flag, the work item probably didn't need cross-vetting at all (or
  the cross-vet failed to engage).
- **Granularity drift.** Per-PR is the right grain. Per-commit is
  too noisy; per-session aggregates too much across unrelated work.
  Methodology adopters will be tempted to make this lighter; resist.
- **Multiple AI tools.** If a project has both an AI proposer
  (Claude Code) and an AI reviewer (Codex), Section B should
  subdivide: human's notes on proposer vs. human's notes on
  reviewer. Section A might also subdivide if multiple humans give
  prompts.

## Storage recommendations

For a single-repo project: everything in-repo under `docs/` and
`audits/` subdirs, with vault session notes as the cross-machine
continuity layer.

For multi-repo / multi-project orgs: a central audit-trail folder
per project (or a shared org-level one with project subfolders),
plus per-repo declaration files that point to it.

The strict requirement is **reconstructability from scratch**:
someone reading the repo + linked audit trail should be able to see
what AI was used, what the human approved, what was deferred, and
why — without needing to ask the original author.

## What this complements

| Artifact | Cadence | Where it lives |
|----------|---------|----------------|
| [`evidence-checklist.md`](evidence-checklist.md) | adoption-time + per-period | `docs/` |
| [`failure-modes.md`](failure-modes.md) | reference | `docs/` |
| [`regulatory-mapping.md`](regulatory-mapping.md) | reference | `docs/` |
| [`../templates/audit-report-template.md`](../templates/audit-report-template.md) | per-audit-report (a sub-type of per-period) | `templates/` |
| [`../templates/pair-review-template.md`](../templates/pair-review-template.md) | per-instance | `templates/` |
| [`../templates/CONTRIBUTING-snippet.md`](../templates/CONTRIBUTING-snippet.md) | per-project, declaration | `templates/` |
| [`../templates/pr-body-template.md`](../templates/pr-body-template.md) | per-instance, summary | `templates/` |

This file is the one place in the methodology that names which
artifacts exist, when, who owns them, and how long to keep them.
The other files supply the operational templates and the rationale
for each.
