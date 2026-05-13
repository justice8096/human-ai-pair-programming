<!--
  Audit report skeleton. Save as `audits/{audit-type}-{YYYY-MM-DD}.md`
  in the repo being audited. Replace {placeholders} before use.

  Examples of {audit-type}: complexity, cwe-mapping, sast-dast-scan,
  llm-compliance, accessibility, supply-chain, contribution-analysis.

  Source: https://github.com/{org}/human-ai-pair-programming
-->

# {Audit type, e.g. Complexity & Refactoring} Audit — {YYYY-MM-DD}

**Repo:** {repo-name}
**Trigger:** {what prompted this audit — scheduled cadence, recent
incident, regulatory deadline, post-feature-burst review}
**Scope:** {what is in scope — directories, file types, time window
of changes; explicitly note what is out of scope}
**Conducted by:** {names / tools — e.g. "Claude Code (proposer pass) +
human reviewer" so the audit's own cross-vet posture is documented}

---

## Executive summary

{Two to four sentences. What was found. Severity distribution. Whether
any item is blocking a release / merge. A reader who only reads this
section should walk away knowing the verdict.}

---

## Findings

For each finding, include severity, location, and recommended action.
Severity scale below; pick what fits — methodology origin repo uses
P0/P1/P2/P3, others use Critical/High/Medium/Low/Info.

### {Finding 1 short title} — {severity}

**Location:** `{path/to/file:line}` or repo-wide.
**Description:** {what the issue is, in plain language. Avoid jargon
the auditor's audience won't share.}
**Evidence:** {commit / PR / output that demonstrates the issue —
include enough that a reader can independently verify.}
**Recommendation:** {specific change. If a fix is being deferred, say
so explicitly and link to the tracking issue.}
**Status:** open / in-progress / fixed in PR #{N} / accepted-risk.

<!-- Repeat for each finding. -->

---

## Status table

| # | Finding | Severity | Status | Linked PR / issue |
|---|---------|---------:|--------|-------------------|
| 1 | {short title} | P{0/1/2/3} | {open / fixed} | #{N} |
| 2 | {short title} | P{0/1/2/3} | {open / fixed} | #{N} |

---

## Cross-vet record

The methodology asks audits themselves to declare their review trail.

- **Drafted by:** {AI tool / human / pair}
- **Reviewed by:** {independent reviewer — separate AI or second human}
- **Sign-off:** {human approver name + date}
- **Disagreements during review:** {summary, or "none"} — the
  methodology rewards surfacing dissent, not hiding it.

---

## Out of scope

{Items the auditor considered and explicitly chose not to cover, with
the reason. This protects the audit's reputation: an item not addressed
should be a deliberate decision, not an oversight.}

---

## Cross-references

- Prior audit: `audits/{audit-type}-{prior-YYYY-MM-DD}.md` (if any)
- Related PRs / issues: #{N}, #{N}
- Methodology: link to the cross-vetting methodology this audit
  follows
