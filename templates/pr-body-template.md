<!--
  Methodology-aligned PR template. Lift into
  `.github/pull_request_template.md`. Delete sections that don't apply
  to a given PR.
  Source: https://github.com/{org}/human-ai-pair-programming
-->

## Summary
<!-- What this PR does and why. One or two sentences. -->

## Why now
<!-- The trigger: a Codex finding, a user report, an audit, scheduled
     cleanup. If this is a follow-up to a prior PR / review comment,
     link it here. -->

## Change type
- [ ] Bug fix
- [ ] Feature
- [ ] Refactor / cleanup
- [ ] Security
- [ ] Docs / audit
- [ ] Dependency bump
- [ ] Other

## Cross-vet trail
<!-- The methodology asks PRs to surface their cross-vet evidence.
     Fill in what applies; mark "n/a" for the rest rather than
     deleting the line. -->
- **Proposer:** {tool, e.g. Claude Code 4.7 / human / pair} —
  reasoning summarized in commit messages.
- **AI reviewer expected:** {bot name, e.g. Codex} — will run
  automatically on PR open.
- **Notable findings to address:** none yet, or list bot findings
  this PR is responding to (with PR links).
- **Critical-path category:** none, or
  {auth / financial / data-export / life-safety} — human-only
  review required.

## Pair-review summary
<!-- Both AI and human contribute. The full pair-review table goes
     either inline below or in a linked file (e.g.,
     `audits/pair-review-{PR-number}.md`). Both sections must be
     non-empty for the cross-vet to count.

     For the full template + standardized note types, see:
     templates/pair-review-template.md (in human-ai-pair-programming repo).
-->

**Section A — AI notes about human prompts / direction**

| Prompt / Direction | AI's note | Type | Resolution |
|--------------------|-----------|------|------------|
| {prompt} | {what AI flagged} | {Ambiguity / Multiple matches / Conflict flag / Risk flag / Scope expansion / Suggested refinement} | {how resolved} |

**Section B — Human notes about AI implementation**

| Implementation | Human's note | Type | Resolution |
|----------------|--------------|------|------------|
| {file:line or decision} | {human's note} | {Style / convention / Logic / Coverage gap / Performance / Security / Disagreement-but-deferred / Approved-as-is} | {how resolved} |

**Cross-vet outcome:** {one sentence — what the cross-vet caught,
deferred, or confirmed}

## Test plan
- [ ] Build / typecheck clean: `{build-command}`
- [ ] Tests pass: `{test-command}`
- [ ] Manual verification (describe):
- [ ] Browser / UI spot-check (if applicable):

## Trade-offs
<!-- Anything you intentionally chose against. The methodology
     rewards explicit dissent over silent compromise. Examples:
     "kept inline template instead of extracting because <200 LOC,"
     "used random-mode instead of EV-mode because individual-run
     visibility matters here." -->

## Breaking changes
- [ ] No breaking changes
- [ ] Breaking change — describe migration:

## Audit / compliance impact
<!-- If this touches security, accessibility, financial calculations,
     or any regulated path, name the audit / ADR / framework section
     that applies. -->

## Checklist
- [ ] No secrets added
- [ ] AI co-authorship disclosed in commit trailers if applicable
- [ ] PR thread retained per repo retention policy
- [ ] Critical-path exception (if any) named above with secondary
      human reviewer
- [ ] Pair-review table sections A and B both filled with substantive
      entries (not just "n/a" or "looks fine")
