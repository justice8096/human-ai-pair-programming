# TODO

Open work items for `human-ai-pair-programming`. Append-only; cross
out items as they ship rather than deleting, so the trail is visible.

## Open

### 1. Sanitize and inline `D:\SecondBrainData\SoftwarePractices\AI-*` sources

**Why:** The `docs/` files (especially
[`docs/regulatory-mapping.md`](docs/regulatory-mapping.md)) reference
vault paths under `D:\SecondBrainData\SoftwarePractices\AI-*.md` that
only resolve on the original author's machine. For outside readers
(and for this repo to stand on its own as a CC0 artifact), the
substantive content of those notes should be sanitized — strip any
personal commentary or unpublished thinking — and brought into the
repo, either as additional `docs/` files or as appendix sections.

**Scope (to refine before doing):**
- Pick which vault notes to inline. `AI-Regulations-Global-Overview.md`
  and `AI-Compliance-Evidence-Matrix-Poster.md` are the highest-leverage
  candidates — they are referenced by every other `docs/` file.
- Decide structure: one `docs/regulations/` subdir mirroring the
  per-jurisdiction notes, or a single consolidated regulatory
  reference doc, or per-framework evidence sheets.
- Sanitize: remove personal annotations, strip vault-only frontmatter
  (`type:`, `tags:`, `related: [[wiki-links]]`), convert wiki-links
  to relative repo paths.
- Update `docs/regulatory-mapping.md` to link to the new in-repo
  files instead of `D:\SecondBrainData\...` paths. Same for any
  other doc that currently references vault paths.

**Defer until:** the planning / scaffolding work on the repo settles
and we know which vault content is actually load-bearing for outside
readers vs which can stay vault-only.

### 2. Research publication venue (CACM vs blog vs alternative) given attribution honesty

**Why:** During the 2026-04-25 article-planning session, a moral /
attribution issue surfaced: substantive intellectual contributions
to the article have come from both the human author and Claude (the
AI assistant), and conventional academic publication norms don't
provide good tools for honest attribution beyond a generic "AI was
used" disclosure. CACM Practice may not allow specific
contribution-by-contribution disclosure or AI co-authorship; a blog
or self-published venue may.

**Scope (to refine before doing):**
- Re-read CACM Practice author guidelines for current AI-disclosure
  / co-authorship policy
- Compare to other venues: ACM Queue (invitation only, but more
  flexible on AI), IEEE Software practitioner column, arXiv preprint
  + blog hybrid, self-hosted blog with optional later academic
  submission, Substack, Medium, methodology-focused journals
- Specifically check: does the venue accept attribution language
  like "Sections X and Y were drafted in collaboration with Claude
  4.7; see audit trail at [URL] for argument-by-argument
  attribution"
- Consider a hybrid approach: blog post with full transparency
  first; sanitized academic version as a follow-up if the practice
  matures

**Connects to:** the article's own §5 (where the analogy breaks)
section, which now needs to address the AI-attribution gap as a
substantive failure-mode of the intern analogy rather than a
peripheral concern.

### ~~3. Codify per-project audit-artifacts framework~~ — DONE 2026-04-25

**Resolved:** [`docs/audit-artifacts.md`](docs/audit-artifacts.md)
written with the five-cadence framework (per-instance / per-session
/ per-project / per-period / per-publication). The pair-review
table was also extracted into its own template at
[`templates/pair-review-template.md`](templates/pair-review-template.md)
with both Section A (AI notes about prompts) and Section B (human
notes about implementation), plus the `AI-readability concern`
type tag added later when PR #61 surfaced that dimension.
