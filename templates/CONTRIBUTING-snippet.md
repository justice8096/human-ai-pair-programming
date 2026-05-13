<!--
  Drop-in CONTRIBUTING.md section for repos adopting AI-Human Pair
  Programming with Cross-Vetting. Replace {placeholders} before use.
  Source: https://github.com/{org}/human-ai-pair-programming
-->

## How changes are reviewed in this repo

This repo follows the **AI-Human Pair Programming with Cross-Vetting**
methodology. In short:

1. **Either AI or human can propose a change.** A proposal is a PR
   with a clear summary, scoped changes, and tests where applicable.
2. **An AI assistant ({proposer-tool}, e.g. Claude Code, Cursor)
   may have written or co-written the change.** That is expected and
   not a reason to reject. Generated content is marked in commit
   trailers.
3. **An independent automated reviewer ({reviewer-bot}, e.g. Codex,
   CodeRabbit, Anthropic Cloud Code Review) reviews every PR.** Its
   findings are visible in the PR thread.
4. **A human is the accountable approver.** No AI bot can self-merge.
   Branch protection enforces this. The merging human owns the change
   regardless of who or what proposed it.
5. **Conversation transcripts and PR threads are retained for
   {retention-period}.** They are evidence the cross-vet happened.

## What this means for you as a contributor

- **You may use AI to help write your contribution.** Disclose it in
  the PR body (e.g., a `Co-Authored-By` trailer). You do not need to
  defend the use; you do need to make it visible.
- **Read automated review findings before requesting human review.**
  If the bot flagged something, address or explicitly justify each
  point. "The bot was wrong because X" is a valid response — but
  state it.
- **Don't rubber-stamp.** If you are the human reviewer, your job is
  not to ratify the bot's verdict. Read the change and form your own
  view. The methodology fails when reviewers click accept on autopilot.

## Critical-path exceptions

The following categories require **human-only review** in addition
to (or in place of) the AI cross-vet:

- {category-1, e.g. authentication / authorization changes}
- {category-2, e.g. financial-calculation changes}
- {category-3, e.g. data-export / PII-handling changes}

For these, name the secondary human reviewer in the PR body and wait
for their explicit sign-off before merging.

## Further reading

- The methodology this repo follows:
  [METHODOLOGY.md in human-ai-pair-programming](https://github.com/{org}/human-ai-pair-programming/blob/main/METHODOLOGY.md)
- Failure modes to watch for:
  [docs/failure-modes.md](https://github.com/{org}/human-ai-pair-programming/blob/main/docs/failure-modes.md)
- Audit-readiness checklist:
  [docs/evidence-checklist.md](https://github.com/{org}/human-ai-pair-programming/blob/main/docs/evidence-checklist.md)
