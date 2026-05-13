# Templates

Drop-in artifacts for adopting the AI-Human Pair Programming with
Cross-Vetting methodology in your own repo. All templates are CC0 —
copy, adapt, delete what doesn't fit.

## What's here

| Template | Purpose |
|----------|---------|
| [`CONTRIBUTING-snippet.md`](CONTRIBUTING-snippet.md) | Drop-in section for `CONTRIBUTING.md` declaring the methodology so contributors and auditors know the practice. |
| [`pr-body-template.md`](pr-body-template.md) | PR description structure that surfaces the cross-vet trail (proposer reasoning, automated review, human decision). Lift into `.github/pull_request_template.md`. |
| [`pair-review-template.md`](pair-review-template.md) | Per-PR pair-review table. Two sections: AI notes about human prompts (Section A) and human notes about AI implementation (Section B). Makes pair programming structurally visible in the audit trail. |
| [`audit-report-template.md`](audit-report-template.md) | Skeleton for `audits/{type}-{YYYY-MM-DD}.md` files. Mirrors the pattern used in the methodology's origin repo. |

## How to use these

1. **Pick the templates you need** — you do not need all four. The
   minimum viable adoption is just the `CONTRIBUTING-snippet.md`
   declaration; everything else is process polish.
2. **Copy file contents into your repo** — these are starting points,
   not packages. Adjust language, links, and tooling references to
   match your stack.
3. **Replace `{placeholder}` markers** — every template uses
   curly-brace placeholders for things you must localize (repo name,
   reviewer bot, retention period).
4. **Reference back to this repo if useful** — link to
   [`../METHODOLOGY.md`](../METHODOLOGY.md) so the practice is
   traceable to its source.

## Caveats

- These templates assume **GitHub** as the forge. If you're on GitLab,
  Gerrit, or somewhere else, the file paths and terminology will
  differ but the structure should still apply.
- They assume **English** prose. Translate as needed — the structure
  carries the methodology, not the specific wording.
- They are intentionally minimal. If your org needs heavier audit
  artefacts (signed commits, full SBOMs, etc.), layer those on top —
  these templates do not displace existing controls.
