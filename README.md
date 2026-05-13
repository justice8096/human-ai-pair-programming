# human-ai-pair-programming

A methodology repo + working artifacts for **AI-Human pair programming with cross-vetting** — a development practice where AI and human both propose ideas, AI tools cross-review each other (e.g. Codex reviewing Claude's PRs), and the human is the accountable approver.

Spawned from extended pair-programming sessions on `retirement-dashboard-angular`
(2026-04-24 → 2026-04-25), where the practice crystallized through 6 merged PRs
with multiple Codex findings caught inline.

## Why this exists

Most discussion of "AI in software development" sits at one of two extremes:
- **AI as autocomplete** — human drives, AI suggests tokens
- **AI as autonomous agent** — AI ships unsupervised

The practice documented here sits in the middle: **augmented intelligence with
genuine cross-vetting**. Both parties propose ideas. Both parties (and ideally
a separate AI reviewer) review proposals. The human is the accountable approver
with full audit trail.

This is closer to how XP pair programming actually works in practice — except
one of the pair is non-human, and a third independent AI reviewer often joins
the loop on PR submission.

## Repo structure

```
human-ai-pair-programming/
├── README.md                            (this file)
├── METHODOLOGY.md                       one-page methodology spec
├── CLAUDE.md                            briefing for AI sessions in this repo
├── TODO.md                              open work items for the methodology
├── article/                             draft article(s) describing the methodology
├── audits/                              data audits (e.g., Codex findings sweep)
├── docs/
│   ├── regulatory-mapping.md            how the practice fits known frameworks
│   ├── failure-modes.md                 where the methodology breaks down
│   ├── evidence-checklist.md            audit-readiness checklist
│   ├── audit-artifacts.md               five-cadence framework for audit trail
│   ├── workflow-figure.md               Mermaid diagram of the cross-vet flow
│   ├── traiga-anchor-research.md        legal-anchor research notes
│   ├── article-baseline-draft.md        article draft fragment: baseline paragraph
│   └── article-threats-to-validity.md   article draft fragment: threats section
├── examples/
│   ├── README.md                        catalog
│   ├── origin-sessions-pr56-pr61.md     overview of origin PRs
│   ├── pr-59-codex-feedback-loop.md     deep dive: AI catches AI's bug
│   ├── pr-60-human-spots-dyscalculia-gate.md   deep dive: human catches what bots miss
│   └── pair-review-2026-04-25-article-planning.md  the pair-review template applied to a real session
└── templates/
    ├── README.md                        index
    ├── CONTRIBUTING-snippet.md          drop-in methodology declaration
    ├── pr-body-template.md              PR description structure
    ├── pair-review-template.md          per-PR pair-review table (Sections A + B)
    └── audit-report-template.md         per-audit skeleton
```

The structure expanded beyond the original placeholder set as the
methodology was articulated and an article draft was prepared. The
[TODO.md](TODO.md) file tracks remaining work items, including the
sanitize-and-inline pass on the vault-source references in `docs/`
and the publication-venue research for the article.

## Key references

- Source vault note (living document):
  `D:\SecondBrainData\SoftwarePractices\AI-Human-Pair-Programming-Methodology.md`
- Origin sessions: `retirement-dashboard-angular` PRs #56 through #61
- Adjacent reading:
  `D:\SecondBrainData\SoftwarePractices\AI-Regulations-*.md`,
  `D:\SecondBrainData\SoftwarePractices\AI-Compliance-Evidence-Matrix-Poster.md`

## License

CC0 1.0 Universal (per project licensing strategy — utility / methodology
extracts use CC0 to maximize reusability).
