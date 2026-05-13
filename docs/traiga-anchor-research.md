# TRAIGA anchor research — for article §4

Research notes for the article's §4 ("The emerging duty of care for AI
use — TRAIGA + NIST AI RMF as the concrete legal anchor"). Compiled
2026-04-25.

**Verification status:** Primary source verified 2026-04-25. The
verbatim text of Sec. 552.105 was retrieved from the official
Texas Legislature Online bill text at
`capitol.texas.gov/tlodocs/89R/billtext/html/HB00149F.HTM` (HB 149
final/enrolled version). The corrections this verification triggered
in the article and these notes are recorded below.

## Citation summary (verified 2026-04-25 against primary source)

| Item | Citation |
|------|----------|
| Bill | Texas H.B. 149, 89th Legislature (2025) — short-titled "Texas Responsible Artificial Intelligence Governance Act" (TRAIGA) |
| Codification | Texas Business & Commerce Code, Chapter 552 |
| Cure-period provision | **Tex. Bus. & Comm. Code § 552.104** (Notice of Violation; Opportunity to Cure) |
| Civil-penalty / injunction provision | **Tex. Bus. & Comm. Code § 552.105** (Civil Penalty; Injunction) |
| Rebuttable presumption | **§ 552.105(c)** ("There is a rebuttable presumption that a person used reasonable care as required under this chapter.") |
| Discovery-and-cure defense | **§ 552.105(e)** — four qualifying discovery mechanisms in (e)(2)(A)-(D) |
| NIST-specific qualifying mechanism | **§ 552.105(e)(2)(D)** — internal review process plus substantial NIST AI 600-1 (or similar framework) compliance |
| Effective date | January 1, 2026 |
| Primary-source URL | `capitol.texas.gov/tlodocs/89R/billtext/html/HB00149F.HTM` |

**Earlier draft of these notes (and most secondary commentary)
mis-cited the section as "546.103" or "552.105(2)(D)" without the
(e) wrapper. The correct citation is § 552.105(e)(2)(D), as
confirmed against the bill text URL above.**

## Verbatim statutory language (verified against primary source)

**§ 552.105(c) — Rebuttable presumption (verbatim):**

> "There is a rebuttable presumption that a person used reasonable
> care as required under this chapter."

**§ 552.105(e) — Discovery-and-cure defense (verbatim, full):**

> "A defendant in an action under this section may not be found
> liable if:
>
> (1) another person uses the artificial intelligence system
> affiliated with the defendant in a manner prohibited by this
> chapter; or
>
> (2) the defendant discovers a violation of this chapter through:
>
> (A) feedback from a developer, deployer, or other person who
> believes a violation has occurred;
>
> (B) testing, including adversarial testing or red-team testing;
>
> (C) following guidelines set by applicable state agencies; or
>
> (D) if the defendant substantially complies with the most recent
> version of the 'Artificial Intelligence Risk Management
> Framework: Generative Artificial Intelligence Profile' published
> by the National Institute of Standards and Technology or another
> nationally or internationally recognized risk management
> framework for artificial intelligence systems, an internal
> review process."

## Important corrections from primary-source verification

What secondary sources got wrong (or smoothed over) and how the
article was updated:

| Secondary-source claim | Actual statute | Article correction |
|------------------------|----------------|---------------------|
| "Section 546.103" | The discovery-and-cure defense is in § 552.105(e); subsection (e)(2)(D) names NIST AI 600-1. The "546.103" reference appears to track a bill section number from an earlier internal numbering, not the codified Tex. Bus. & Comm. Code section | Article cites § 552.105(e) and § 552.105(e)(2)(D) |
| "Demonstrable compliance with NIST AI RMF constitutes an affirmative defense" | NIST compliance is **not itself** the defense. The defense is for *discovery* of violations through any of four mechanisms; (D) is one mechanism (internal review process), and NIST compliance is what *qualifies* the internal review process under (D) | Article reframes as discovery-and-cure architecture |
| "NIST AI Risk Management Framework (AI RMF 1.0)" | Statute names **"Artificial Intelligence Risk Management Framework: Generative Artificial Intelligence Profile"** specifically — i.e., NIST AI 600-1, not the base AI RMF | Article cites NIST AI 600-1 |
| "Or similar standards" | Statute language is broader: "another nationally or internationally recognized risk management framework for artificial intelligence systems" — explicitly covers ISO/IEC standards and international frameworks | Article preserves the broader scope |

The defense activates on **documented alignment across all four
NIST AI RMF functions**:

1. **GOVERN** — policies, roles, accountability structures
2. **MAP** — context of use, system-by-system risk identification,
   affected populations
3. **MEASURE** — testing protocols, performance metrics, bias
   monitoring, benchmarks
4. **MANAGE** — incident response, remediation history, lifecycle
   management, ongoing monitoring

Statutory framework permits affirmative defenses in three trigger
circumstances:

1. Third-party misuse of AI in ways TRAIGA prohibits
2. Violations discovered through testing or good-faith audits
3. Substantial compliance with NIST AI RMF or "similar recognized
   standards"

A separate **60-day cure period** exists under TRAIGA's enforcement
provisions, distinct from the Section 546.103 affirmative defense
itself.

## Why this is the article's strongest legal hook

Three reasons §4 should anchor on TRAIGA + NIST AI RMF rather than
the broader emerging-duty-of-care discussion:

1. **It's active law as of 2026-01-01**, not aspirational guidance.
   The article can name a specific statutory section that took
   effect during the time window the methodology was being
   articulated.
2. **It maps cleanly to the cross-vet methodology.** The
   methodology's structure (proposer → independent reviewer → human
   approver → audit trail) is recognizably a MEASURE + MANAGE
   practice with elements of GOVERN. Adopters running the
   methodology are already substantially aligned with NIST AI RMF —
   the article makes the alignment explicit.
3. **It pre-empts the "AI compliance is unsettled" framing.** Other
   jurisdictions (EU AI Act high-risk categories, NIST AI 600-1
   guidance, US state-level patchwork) supply context, but Texas
   gives the article a concrete answer to "what counts as
   compliance today."

## Mapping the methodology onto NIST AI RMF functions

The article's §4 should include a table like this:

| NIST AI RMF function | Methodology element that satisfies it |
|----------------------|----------------------------------------|
| **GOVERN** | Methodology declaration in `CONTRIBUTING.md`; named human approver per change; critical-path category list |
| **MAP** | Per-PR critical-path category check; risk-flag entries in pair-review Section A; failure-mode incident log per project |
| **MEASURE** | AI reviewer (Codex / equivalent) automated review on every PR; pair-review tables capturing what was caught vs. missed; quantitative review-comment-action rates |
| **MANAGE** | Audit trail with model versions, prompt logs, vendor inventory; periodic competence assessments; remediation tracked through follow-up PRs (the PR #58 → PR #59 pattern) |

This mapping argues that **a project running the methodology has,
substantially, already done the work TRAIGA's affirmative defense
requires** — without having framed it that way.

## Article §4 draft outline

Working from the plan-file outline plus the research above:

1. **Paragraph 1:** Frame the question — AI use in software
   development sits in an emerging duty-of-care landscape. Most of
   that landscape is guidance (NIST AI 600-1, Lawfare, Harvard JOLT).
   But Texas has codified a specific answer.
2. **Paragraph 2:** Quote / paraphrase Section 546.103 — affirmative
   defense for substantial NIST AI RMF compliance, in effect since
   2026-01-01.
3. **Paragraph 3:** Show the four NIST AI RMF functions and how the
   methodology maps onto them (table above).
4. **Paragraph 4:** Cross-jurisdictional anchor — reference the
   German BGB Erfüllungsgehilfen treatment of interns as
   non-personally-liable vicarious agents, to establish the
   methodology's structure isn't novel-to-Texas but recognized in
   civil-law jurisdictions too.
5. **Paragraph 5:** Limits of the legal anchor — TRAIGA is one
   jurisdiction; "similar recognized standards" language is
   untested; affirmative defense doesn't pre-empt liability, only
   provides a defense after enforcement begins. Honest about scope.

Target length: ~800 words for §4.

## Open questions / outstanding research

The major verification gap is now closed. Remaining items:

- **Texas AG enforcement record** — has the AG brought any
  TRAIGA-based actions since 2026-01-01 effective date? If yes,
  those become precedent for how (e)(2)(D) is interpreted.
- **Texas AG guidance under (e)(2)(C)** — has the AG issued
  guidelines that adopters should follow? This is one of the four
  qualifying discovery mechanisms.
- **"Nationally or internationally recognized" interpretation** —
  no Texas court has interpreted this language. ISO/IEC 42001 is
  the obvious candidate; ISO/IEC 5339 (in draft) and EU AI Act
  implementation guidance are plausible.
- **Other states tracking TRAIGA's structure** — California,
  Colorado, New York all have AI legislation in motion. Whether
  any adopt similar discovery-and-cure architectures matters for
  cross-jurisdictional applicability.

## References (for the article's bibliography)

- **Texas H.B. 149**, 89th Legislature (2025), short-titled "Texas
  Responsible Artificial Intelligence Governance Act"
- **Tex. Bus. & Comm. Code Ch. 552** (Artificial Intelligence
  Protection), effective January 1, 2026
- **NIST AI Risk Management Framework**, Generative AI Profile
  (NIST AI 600-1)
- **Latham & Watkins**, "Texas Signs Responsible AI Governance Act
  Into Law" (2025)
- **Norton Rose Fulbright**, "The Texas Responsible AI Governance
  Act: What your company needs to know before January 1"
- **Greenberg Traurig**, "TRAIGA: Key Provisions of Texas's New
  Artificial Intelligence Governance Act" (June 2025)
- **Skadden**, "Texas Charts New Path on AI With Landmark
  Regulation" (June 2025)
- **Ropes & Gray**, "Navigating TRAIGA: Texas's New AI Compliance
  Framework" (June 2025)
- **ABA Business Law Today**, "Texas Enters the AI Sandbox with
  TRAIGA: Implications for Business Trials" (July 2025)
