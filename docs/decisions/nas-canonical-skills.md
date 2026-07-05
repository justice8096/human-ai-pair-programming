# Decision: NAS as canonical store for skill repos, minimal local footprint

- **Status:** Proposed (2026-07-05) — awaiting two inputs before execution
  (see [Open items](#open-items)).
- **Deciders:** user (approver) + AI (proposer/cross-vetter)
- **Context thread:** grew out of the `D:` → NAS path migration
  (`\\192.158.68.77\disk1\...`); see `TODO.md` and the commit that
  rewrote vault references.

## Decision

Make the NAS (`\\192.158.68.77\disk1\`) the **prime area** for the Claude
Code skill repos that currently live on `D:`. Keep only a **minimal
load-bearing core** checked out locally, so tooling still runs during a
NAS outage. The authoritative source of truth is **git**, not the share:
the NAS holds full checkouts; reconciliation is `git pull` / `git push`,
never file-copy.

This is the *NAS-prime / minimal-local* variant. It was chosen over the
more conservative *NAS-canonical / full-local* variant with eyes open —
see the cross-vet below.

## Why (the case for)

- Single, backed-up source of truth reachable from every machine.
- Local machine stays lean; skills are maintained in one place.
- The `D:` copies are already under git, so migration is `clone`, not a
  lossy file copy — history and remotes come along.

## Cross-vet (the case against — recorded, not hidden)

1. **This doubles down on the exact fragility we were routing around.**
   The whole thread started because *the NAS mapping keeps falling out*.
   Docs that merely *reference* a down NAS path degrade to a dead link
   (harmless). Skills that *execute from* a down NAS path break tooling
   mid-session. Higher blast radius.
2. **"Minimal local" is weakest exactly when you need it.** If the NAS is
   the thing that failed, a stripped local copy means reduced capability
   during the outage. The fallback must therefore be deliberately chosen,
   not whatever happens to be left behind.
3. **Running skills off a network share adds latency and a new failure
   mode** to every skill invocation, not just to backup/restore.

The conservative alternative (full local checkout on each machine, NAS as
canonical backup / git remote only) avoids all three at the cost of some
local disk. It was **not** chosen; disk savings and single-maintenance-point
were preferred. This record exists so a future session can reverse the call
knowingly if the outage pain outweighs the savings.

## Mitigations (mandatory, because the NAS is known-flaky)

1. **Git is the source of truth, not the mount.** "Prime" = canonical +
   backed-up, anchored to a git remote (GitHub or a bare repo on the NAS),
   not a single flaky share. Never reconcile by copying files.
2. **A named load-bearing core stays fully local, always.** Only the user
   can decide this set (see Open items). Everything outside it is NAS-only.
3. **Config resolves NAS-primary + local-core fallback, over UNC** —
   `\\192.158.68.77\disk1\...`, never a drive letter, so the core resolves
   even while the mapping is dropped.

## Layout

```
NAS (prime, full):
  \\192.158.68.77\disk1\skills\<repo>\        # full git checkout of every skill repo

Local (minimal, core only):
  <LocalCoreRoot>\<core-repo>\                 # full checkout of load-bearing repos only

Claude Code skills search path (settings.json), in order:
  1. \\192.158.68.77\disk1\skills\...   (primary — full set when NAS is up)
  2. <LocalCoreRoot>\...                 (fallback — always present)
```

Same-named skills resolve to the local core when the NAS is unreachable;
otherwise the full NAS set is available.

## Runbook

Migration + ongoing sync is handled by
[`scripts/sync-skills-to-nas.ps1`](../../scripts/sync-skills-to-nas.ps1)
(PowerShell / Windows). It:

- reads the explicit repo list from
  [`scripts/skill-repos.manifest`](../../scripts/skill-repos.manifest)
  (resolved under `-LocalBase`, default `D:\`) — an explicit manifest, not
  discovery, so the vault and other git dirs under `D:\` are never swept in,
- clones any repo not yet on the NAS, and `git pull --ff-only`s the rest,
- keeps full local checkouts of the core repos (`+`-marked in the manifest,
  or passed via `-CoreRepos`),
- reports (and, only with `-Prune`, removes) local working copies of
  non-core repos,
- warns and skips any manifest name not found on disk rather than failing.

Defaults to **dry-run**; pass `-Execute` to act. Never prunes without an
explicit `-Prune` flag.

## Open items

1. ~~**`D:` root / inventory**~~ — resolved. The repos sit directly under
   `D:\` (not a common parent), enumerated in
   [`scripts/skill-repos.manifest`](../../scripts/skill-repos.manifest)
   (22 repos as of 2026-07-05). `retirement` is a distinct skills-bearing
   repo, not the origin `retirement-dashboard-angular`.
2. **The load-bearing core** — which repos MUST stay fully local to survive
   a NAS outage. Still open; the single human judgement call the design
   hinges on. Mark them with `+` in the manifest (or pass `-CoreRepos`).
   Until set, `-Prune` removes nothing — every local copy is kept.
3. **Origin anchor** — whether the NAS clones should point their `origin`
   at a GitHub/remote URL rather than the local `D:\<repo>` path (see
   mitigation #1). The current script clones from the local path; if these
   repos have remotes, anchoring to them is cleaner.

## Consequences

- Skill invocation gains a dependency on NAS availability for anything
  outside the core. Track whether outages become painful in practice; if
  so, revisit and flip to the full-local variant.
- Two working copies (NAS + local core) means a sync discipline. Git makes
  it safe, but edits made locally during an outage must be pushed back
  before they can be considered canonical.
