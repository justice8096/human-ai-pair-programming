# Cross-vet — article draft v2

**Article audited:** [`article/draft-2026-04-25.md`](../article/draft-2026-04-25.md)
**Word count:** 5,823 (CACM Practice cap: 6,000)
**Trigger:** The methodology requires the article be cross-vetted
under its own controls before submission — independent reviewer
read + literature sweep for prior work that confirms or challenges
the claims.
**Conducted by:** Claude Code 4.7 (acting in reviewer role rather
than proposer role); human approver pending.

---

## Executive summary

The article is in submission-ready shape with three pre-submission
priorities and several lower-priority polish items. The literature
sweep surfaced one major empirical finding (CodeRabbit's December
2025 study of 470 PRs) the article should engage with directly —
both because it strengthens the cross-vet rationale and because a
CACM reviewer is highly likely to ask why it's missing. No
disqualifying concerns identified.

---

## Literature sweep findings

### Agreement / convergence with the article's claims

| Finding | Source | What it confirms |
|---------|--------|------------------|
| 84% of developers now use AI coding tools | Index.dev statistics (2026) | The "missing middle" between autocomplete and autonomous is now mainstream practice |
| Cross-checking with multiple LLMs is a recommended practice | Sparkco AI, Logic Square, Refine | The article's cross-vet structure is consistent with emerging practitioner guidance |
| Trust gap: 33% trust AI output, 46% distrust | Multiple sources | Validates the article's audit-trail emphasis — practitioners themselves don't trust AI without cross-vet |
| AI-as-junior-associate is in informal use, especially in legal AI | Harvey, Legora, Stanford Legal Engineering paper | The trainee analogy is already circulating informally; the article's contribution is making it legally rigorous |
| Audit-trail tooling for AI is established | WitnessAI, Trail, Splunk, FireTail | The audit-trail-discipline argument fits an existing infrastructure conversation, not novel territory |

### Disagreement / counter-positioning

| Position | Source | How the article handles it |
|----------|--------|---------------------------|
| AI as autonomous junior associate ("tireless junior associates" running 24/7) | Harvey, Integrated Cognition | The article explicitly rejects this in §1 ("AI as autonomous agent" framing) — but should briefly acknowledge that this is the prevailing legal-AI marketing pitch, not just an academic strawman |
| AI governance audit trail is for deployed systems | WitnessAI, Trail, Swept AI | The article's audit-trail focus is on development-time cross-review, distinct from these. Worth a one-sentence distinction |
| Informal "AI is like an intern" usage already prevalent | Multiple legal-AI marketing sources | The article should acknowledge this rather than imply the analogy is novel — the contribution is the legal-structural rigor, not the metaphor |

### **The major finding the article must engage with**

**CodeRabbit, "State of AI vs Human Code Generation" (December 2025).**
Empirical study of 470 real-world GitHub pull requests, with 320
labeled as AI-coauthored and 150 as human-only. Findings:

- AI-authored PRs include ~10.83 issues each vs 6.45 for human-only
  PRs (**~1.7× more issues**)
- 1.4× more critical issues, 1.7× more major issues
- 1.75× more logic and correctness errors
- 1.64× more code quality / maintainability errors
- 1.57× more security findings
- 1.42× more performance issues
- Excessive I/O operations ~8× more common in AI-authored PRs

This is **direct empirical evidence on the methodology's central
question** (does cross-vet help?) from a peer-time-window source.
The article currently does not cite it.

**Two ways to engage:**

1. **As supporting evidence.** The 1.7× finding strengthens the
   case for cross-vet structurally — if AI-authored PRs introduce
   more defects, the second AI reviewer + human approver layer is
   not optional polish, it's necessary risk management. The
   methodology's claim that the cross-vet generates substantive
   review activity (1.33 findings/PR in the article's data)
   becomes more meaningful when paired with CodeRabbit's defect
   rate.

2. **As a tension to address.** A skeptical reader could read the
   1.7× number as "why use AI at all if it produces 1.7× more
   bugs?" The article should preempt this by noting that the
   cross-vet is precisely how the methodology metabolizes that
   defect surplus into reviewable findings rather than shipped
   bugs.

**Recommended placement:** §3 (worked example), as a
two-sentence engagement with the CodeRabbit data immediately
after the article's own 1.33-findings-per-PR observation. Both
data points then sit together: AI introduces more defects (per
CodeRabbit), and the cross-vet generates findings against them
at a non-trivial rate (per the article's own data).

---

## Reviewer-style critical concerns

Reading the article fresh as if I were a CACM Practice editor or
peer reviewer.

### High priority — fix before submission

1. ~~**TRAIGA verbatim quote is from secondary sources.** §4 includes
   a quote attributed to TRAIGA Section 546.103 that comes from
   txaims.com and similar secondary commentary. A CACM reviewer
   will ask for the verbatim codified statutory text from
   `statutes.capitol.texas.gov`. The article flags this internally
   but it must be resolved before submission. **Severity: high; cost
   to fix: ~30 min.**~~ **RESOLVED 2026-04-25.** Primary source
   verified at
   `capitol.texas.gov/tlodocs/89R/billtext/html/HB00149F.HTM`.
   Secondary sources had been imprecise in three substantive ways:
   wrong section number (cited 546.103 or 552.105(2)(D) instead of
   § 552.105(e)(2)(D)); wrong framework name (cited AI RMF 1.0
   instead of the Generative AI Profile / NIST AI 600-1
   specifically); and wrong architecture (described as
   compliance-as-immunity rather than discovery-and-cure with NIST
   compliance qualifying one of the discovery mechanisms). Article
   §4 rewritten to track the verified statutory language.

2. **No engagement with CodeRabbit's 1.7× finding.** Same December
   2025 time window as the article's origin sessions. A reviewer
   actively researching the topic will surface this within minutes.
   Not engaging with it will read as either ignorance of the
   literature or selective citation. **Severity: high; cost to fix:
   ~1 hour to write the engagement paragraph.**

3. ~~**References list is a working list, not formatted.** CACM
   Practice expects ACM citation style. **Severity: high (formal
   submission requirement); cost: ~1 hour.**~~ **RESOLVED
   2026-04-25.** References reformatted in ACM Reference Format,
   numbered [1]-[18], grouped by source type (statutes,
   standards, case law, scholarly commentary, empirical evidence,
   supplementary materials). Verified citations via web search:
   *Hubay v. Mendez* now cited as 500 F. Supp. 3d 438 (W.D. Pa.
   2020); *Jistarri v. Nappi* as 549 A.2d 210, 378 Pa. Super.
   583 (1988); Lawfare article author corrected from
   "Schneier/Roth" (the AI's prior incorrect guess) to **Bryan H.
   Choi** (2024); Harvard JOLT article author confirmed as
   **Nanda Min Htin** (2026); RAND report lead author **Mary L.
   Cummings**. The Lawfare correction is exactly the kind of
   error the methodology's primary-source verification discipline
   is designed to catch — AI-generated drafts had attributed the
   article to plausible-sounding authors who hadn't actually
   written it. Three references ([13]-[15]) now cited inline in
   §4 to maintain alignment between body mentions and reference
   list.

### Medium priority — strengthens the article

4. **The authorship note above the abstract is genuinely novel
   and could be seen as gimmicky or as profound.** CACM Practice's
   tolerance is unknown. Two possible mitigations: (a) move the
   authorship note to a footnote on the abstract or to the end
   of §7 where attribution is discussed substantively; (b) leave
   it where it is and accept that some reviewers will find it
   striking and others won't. The current placement bets on the
   striking-not-gimmicky reading. Worth checking with the venue
   editor before final submission. **Severity: medium; cost: zero
   to inquire, hours to relocate if needed.**

5. ~~**Six of eight Codex findings have unverified resolution
   status.** The article calls this out honestly but a reviewer
   might say "verify them and resubmit." Doing the verification
   pass (~1-2 hours) would let the article say "X of 8 confirmed
   actioned" with a higher X and remove the visible weakness.
   **Severity: medium; cost: ~1-2 hours.**~~ **RESOLVED
   2026-04-25.** All eight findings now have verified resolution
   status: **6 actioned, 2 deferred** (both PR #56 P2 — human
   approver visibly chose not to act). Verification was via
   inspection of current code at the original finding locations
   plus commit-history matching of post-review commits to finding
   subject. Article §3 updated to report 6/8 actioned with the
   2 deferrals named explicitly — a stronger claim than the
   previous "2/8 confirmed; 6/8 unverified" framing, and one that
   demonstrates the methodology preserves human judgment over
   bot deference.

6. **Pair-review template referenced but not shown inline.** §2.1
   and §7 advocate for the template; the reader sees only the
   structure, not the actual template. CACM Practice often
   accepts inline figures and small code listings. Including the
   template (or a simplified version) inline would be more
   actionable for adopters. **Severity: medium; cost: ~30 min;
   adds words but article has headroom under the 6,000 cap.**

7. ~~**The "AI as intern" framing should briefly acknowledge informal
   prior use.** Industry sources (legal-AI marketing especially)
   already use the analogy casually. The article's contribution is
   structural-legal rigor, not the metaphor itself. A one-sentence
   acknowledgment positions the article correctly without
   diminishing its claim. **Severity: medium; cost: 5 minutes.**~~
   **RESOLVED 2026-04-25.** Two-sentence acknowledgment added
   to §1: *"The 'AI as intern' metaphor is already in informal
   circulation — legal-tech vendors describe their tools as
   'tireless junior associates'; engineering blogs treat AI
   assistants as 'code interns.' My contribution is not the
   metaphor itself but the structural mapping onto trainee-
   supervision law and the operational methodology that goes with
   it."*

### Lower priority — polish

8. **Terminology drift around "the AI."** Article uses "the AI" /
   "the AI proposer" / "the AI tool" / "Claude Code" variably.
   Could be tightened to consistent usage. **Severity: low; cost:
   30 min careful read.**

9. **Some "the article" reflexive uses survived the prose pass.**
   E.g., §5: "My claim is specifically about *paid* interns" — fixed.
   But other places may still use "the article" where "I" or
   "this piece" reads more naturally. **Severity: low; cost: 15
   min careful read.**

10. **§3 closing data paragraph could move into §6 (failure
    modes).** The 6/8 unverified rate is currently in §3's broader
    context paragraph. It's also exactly an example of failure mode
    #4 (audit-trail completeness). The article briefly notes the
    cross-reference; could move the data outright. **Severity: very
    low; cost: 15 min; might not improve the article (placement
    where it is provides important context for §3's own claims).**

### Concerns that DON'T need addressing

These are predictable reviewer points the article already handles:

- **N=1 evidence base** — explicitly named in §5 and §8.
- **Single AI vendor pair** — explicitly named.
- **Structural-not-doctrinal legal framing** — explicitly named in §4
  and §5.
- **Methodology hasn't been validated at scale** — explicitly named
  in §8.
- **Self-reference to producing the article under the methodology**
  — handled in the authorship note and the pair-review example file.

---

## Strengths a reviewer should acknowledge

For honest balance:

1. **Legal anchor is fresh and concrete.** TRAIGA went into effect
   January 1, 2026; the article cites it within four months. Most
   AI-methodology articles still rely on aspirational frameworks.
2. **Cross-jurisdictional confirmation via German BGB.** The
   Erfüllungsgehilfen treatment of interns is a strong civil-law
   parallel that hardens the structural argument.
3. **Two case studies in opposite directions.** PR #59 (AI catches
   AI's bug) and PR #60 (human catches what bots miss) work as
   paired evidence — the methodology's value isn't all in one
   direction.
4. **PR #61 third-axis case.** AI-readability concern as a
   distinct review category is a genuinely new contribution to the
   pair-programming-with-AI literature.
5. **Honesty section in §5.** Naming where the analogy breaks is
   stronger than the conventional "limitations" section in most
   methodology pieces.
6. **Authorship note.** Whether or not it's the right move
   tactically, it's intellectually honest and consistent with the
   methodology the article describes.
7. **Pair-review template.** The Section A / Section B structure
   with standardized type tags is actionable in a way most
   methodology proposals aren't.

---

## Recommended action plan, prioritized

**Before submission (must-do, ~3-4 hours total):**

1. Engage with CodeRabbit's 1.7× finding in §3 (~1 hour)
2. First-source verify the TRAIGA quote in §4 (~30 min)
3. Format References per ACM style (~1-2 hours)

**Before submission (should-do, ~2 hours):**

4. Verify the 6 outstanding Codex finding resolutions to tighten
   §3's data (~1-2 hours)
5. Add brief acknowledgment of informal "AI as intern" use in §1
   (~5 min)

**Optional polish (~1-2 hours):**

6. Decide authorship-note placement (consult venue or commit to
   current placement)
7. Inline pair-review template (or simplified version) in §2.1
   or §7
8. Terminology consistency pass on "the AI" / proposer / tool

**Skip:**

- Restructuring (article structure works)
- Adding more case studies (three is the right number)
- Removing the authorship note or self-reference

---

## Cross-vet summary for the audit trail

| Section | Outcome |
|---------|---------|
| Literature sweep | 1 major finding to engage with (CodeRabbit), 3 areas of agreement noted, 2 of disagreement to position against |
| Reviewer pass | 3 high-priority pre-submission items, 4 medium-priority, 3 low-priority polish |
| Disqualifying concerns | None |
| Article shape | Submission-ready after 3-4 hours of revision |

## Sign-off

**Drafted by:** Claude Code 4.7 (in reviewer role)
**Reviewed by:** *(pending — would be the human approver per
methodology)*
**Sign-off:** *(pending)*
**Disagreements during review:** *(none yet — review hasn't happened)*

The methodology requires the human approver to read this cross-vet
and either accept the recommendations, reject them with reasoning,
or request another iteration. The audit trail captures that
decision regardless of which path is chosen.
