# Regulatory mapping

How AI-Human Pair Programming with Cross-Vetting fits into existing
regulatory and standards frameworks. This is a snapshot of the picture
as of 2026-04-25 — the regulatory landscape is moving and this should
be re-checked every 6-12 months.

For the methodology itself, see [`../METHODOLOGY.md`](../METHODOLOGY.md).
For jurisdiction-specific deep dives, see the adjacent vault notes
listed at the end of this file.

## Summary

No existing framework specifically targets this methodology — it's
newer than the regulations. But several frameworks have adjacent
provisions, and the methodology generally **exceeds** the floor those
frameworks set.

The reason is structural: most frameworks were written assuming
*one* layer of code review (typically a single human). This methodology
adds two more independent layers — an AI proposer and an AI cross-reviewer
— with the human still in the accountable approver seat. Three
independent perspectives is more than most "audited" software shops have.

## Framework-by-framework mapping

| Framework | Provision | How AI-Human pair-programming fits |
|-----------|-----------|------------------------------------|
| **NIST SSDF (SP 800-218)** | PW.7 — review/analyze human-readable code | Doubly satisfied (Codex pass + human review). NIST is silent on whether AI counts as "human" in human-readable, but the spirit is met. |
| **SOC 2 / ISO 27001** | Change management — segregation of duties (four-eyes) | Codex doesn't formally satisfy "four-eyes" since it's not a person. It is a defensible *additional* control on top of the human reviewer. Auditors want: human is the accountable approver. |
| **EU AI Act, Article 14** | Human oversight required for high-risk AI systems | Applies if you *ship* AI-generated code as part of a high-risk system. Methodology already satisfies; needs audit-trail documentation (PRs / review comments). |
| **ISO/IEC 42001 (2023)** | AI Management Systems for organizations using AI | Formalizing the cross-vetting workflow as written policy makes it certification-ready. Currently most teams running this methodology have only the informal version. |
| **NIST AI 600-1 (Generative AI Profile, 2024)** | Calls out human review and "human reasoning over AI outputs" | Maps cleanly. Methodology is an exemplar implementation. |
| **DO-178C (avionics) / IEC 62304 (medical) / ISO 26262 (automotive)** | Strict review requirements with role separation | The cross-vetting can serve as one review tier; a second human reviewer may still be required by the domain regulator. Don't assume AI cross-vet alone clears these bars. |
| **SOX IT controls (finance)** | Change approval, segregation of duties | AI as one of two reviewers is novel territory. Likely needs a human secondary approver for financially-material changes. |

## Where this exceeds the regulatory floor

Most enterprises today fall into one of two patterns:

- **Ban AI-generated code outright** — fearful of liability and
  training-data contamination
- **One human reviewer with no second check** — typical "lean" PR review

This methodology has:

- AI proposing changes
- Independent AI cross-reviewing (Codex / similar)
- Human reviewing both the AI's work and the AI reviewer's findings
- Full audit trail

Three independent perspectives, one accountable decision. That is
materially more rigorous than what the vast majority of software shops
operate, regulated or not.

## Where the regulations are heading (1-2 year horizon)

The methodology is not yet codified into a named framework, but several
in-flight efforts will likely overlap by 2027:

- **ISO/IEC 5339** — drafting AI-augmented SDLC standards
- **NIST SSDF v2** — being updated to address generative AI explicitly
- **EU AI Act Code of Practice** — implementation guidance landing
  through 2026
- **GDPR Article 22 analog for code** — automated decision-making in
  software development may attract analogous transparency rules
- **Several US states** workshopping AI-assisted developer disclosure
  rules (similar to deepfake disclosure laws)

Within 1-2 years this methodology will likely fit a named framework.
Until then, the prudent posture is to document the practice in your
own change-management policy and let the standards catch up.

## What this mapping does *not* cover

This document is about regulatory framework fit. It deliberately does
not cover:

- **Failure modes** of the methodology — see
  [`failure-modes.md`](failure-modes.md)
- **Audit-readiness checklist** — see
  [`evidence-checklist.md`](evidence-checklist.md)
- **Jurisdictional specifics** — see the adjacent vault notes below;
  they go deeper than this repo aims to

## Adjacent reading

The substantive jurisdictional analysis lives in the user's vault, not
this repo. These references resolve on the original author's machine and
may not be reachable for adopters; they are listed here as the
authoritative source of further detail rather than as drop-in
dependencies:

- `D:\SecondBrainData\SoftwarePractices\AI-Regulations-Global-Overview.md`
  — index covering 11 jurisdictions, with the EU AI Act / South Korea /
  US state law timelines through 2026
- `D:\SecondBrainData\SoftwarePractices\AI-Regulations-EU.md` —
  EU AI Act, phased applicability through Aug 2026
- `D:\SecondBrainData\SoftwarePractices\AI-Regulations-UnitedStates.md`
  — patchwork of state laws, no federal omnibus
- `D:\SecondBrainData\SoftwarePractices\AI-Regulations-{UK,Canada,China,Japan-SouthKorea,India-Singapore-ASEAN,Australia,NewZealand,Mexico-LatinAmerica,Africa}.md`
  — region-by-region detail
- `D:\SecondBrainData\SoftwarePractices\AI-Compliance-Evidence-Matrix-Poster.md`
  — visual taxonomy of 16 jurisdictions × 24 evidence categories;
  feeds [`evidence-checklist.md`](evidence-checklist.md)
- `D:\SecondBrainData\SoftwarePractices\AI-Compliance-Open-Source-Applicability.md`
  — applicability of these frameworks to open-source projects specifically
