<#
.SYNOPSIS
  Make the NAS the prime store for the D: skill/project repos, keeping only a
  load-bearing core checked out locally. Git-based; safe by default.

.DESCRIPTION
  Implements docs/decisions/nas-canonical-skills.md.

  The set of repos is read from an explicit manifest (default
  scripts/skill-repos.manifest) rather than discovered, so the vault and any
  other git dirs sitting under D:\ are never swept in. Each manifest entry is
  a repo folder name resolved under -LocalBase. A '+' prefix marks a repo as
  load-bearing core.

  For every repo in the manifest:
    * if it is not yet on the NAS, clone it there (full checkout);
    * otherwise `git pull --ff-only` the NAS copy to keep it current.
  Core repos are kept as full local checkouts (the offline fallback).
  Non-core repos are reported as prunable and, ONLY with -Prune, their local
  working copy is removed (they remain on the NAS + git origin).

  Source of truth is git: this script never copies files between locations,
  it clones/pulls. Nothing is removed unless you pass BOTH -Execute and
  -Prune. Names not found on disk are warned and skipped, not fatal.

.PARAMETER LocalBase
  Folder the repo names resolve under. Default D:\ (the repos sit directly
  under it).

.PARAMETER ManifestPath
  Path to the repo manifest. Default: skill-repos.manifest next to this script.

.PARAMETER NasRoot
  Destination on the NAS. Defaults to the UNC path (not a drive letter, on
  purpose — survives the mapping dropping).

.PARAMETER CoreRepos
  Extra repo names to treat as core, unioned with any '+'-marked manifest
  entries. The load-bearing set that MUST stay fully local for offline use.

.PARAMETER Execute
  Actually perform clones/pulls. Without it, the script only reports.

.PARAMETER Prune
  In addition to -Execute, remove local working copies of non-core repos.
  Requires a clean git state per repo; dirty repos are skipped and reported.

.EXAMPLE
  # See what would happen — changes nothing:
  .\sync-skills-to-nas.ps1

.EXAMPLE
  # Clone/pull everything to the NAS, keep all local copies in place:
  .\sync-skills-to-nas.ps1 -Execute

.EXAMPLE
  # Full intended end state: NAS prime, only core kept locally:
  .\sync-skills-to-nas.ps1 -CoreRepos claude-skills,claude-obsidian-sync -Execute -Prune
#>
[CmdletBinding()]
param(
    [string] $LocalBase = 'D:\',

    [string] $ManifestPath = (Join-Path $PSScriptRoot 'skill-repos.manifest'),

    [string] $NasRoot = '\\192.158.68.77\disk1\skills',

    [string[]] $CoreRepos = @(),

    [switch] $Execute,

    [switch] $Prune
)

$ErrorActionPreference = 'Stop'

function Get-GitClean {
    param([string] $Path)
    Push-Location $Path
    try {
        $status = git status --porcelain
        return [string]::IsNullOrWhiteSpace($status)
    }
    finally { Pop-Location }
}

if (-not (Test-Path $ManifestPath)) {
    throw "Manifest not found: $ManifestPath"
}
if (-not (Test-Path $LocalBase)) {
    throw "LocalBase not found: $LocalBase"
}

# Parse the manifest: strip inline comments, honour '+' as a core marker.
$manifest = Get-Content $ManifestPath | ForEach-Object {
    $line = ($_ -replace '#.*$', '').Trim()
    if ([string]::IsNullOrWhiteSpace($line)) { return }
    $core = $false
    if ($line.StartsWith('+')) { $core = $true; $line = $line.TrimStart('+').Trim() }
    [pscustomobject]@{ Name = $line; Core = $core }
} | Where-Object { $_ }

$coreSet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
foreach ($m in $manifest) { if ($m.Core) { [void]$coreSet.Add($m.Name) } }
foreach ($c in $CoreRepos) { [void]$coreSet.Add($c) }

Write-Host "Local base  : $LocalBase"
Write-Host "Manifest    : $ManifestPath ($($manifest.Count) repos)"
Write-Host "NAS root    : $NasRoot"
Write-Host "Core repos  : $(if ($coreSet.Count) { [string]::Join(', ', $coreSet) } else { '(none marked — nothing will be pruned)' })"
Write-Host "Mode        : $(if ($Execute) { 'EXECUTE' } else { 'DRY-RUN' })$(if ($Prune) { ' +PRUNE' } else { '' })"
Write-Host ('-' * 60)

# NAS reachability check — do not proceed blind if the share is down.
if ($Execute -and -not (Test-Path $NasRoot)) {
    Write-Host "NAS root not reachable ($NasRoot). Bring the share online before" -ForegroundColor Yellow
    Write-Host "running with -Execute. Aborting." -ForegroundColor Yellow
    exit 1
}

$missing = @()
foreach ($repo in $manifest) {
    $name      = $repo.Name
    $isCore    = $coreSet.Contains($name)
    $localPath = Join-Path $LocalBase $name
    $nasPath   = Join-Path $NasRoot $name
    $tag       = if ($isCore) { '[core]' } else { '[nas-only]' }

    if (-not (Test-Path (Join-Path $localPath '.git'))) {
        Write-Host "[missing] $name — no git repo at $localPath; skipping" -ForegroundColor Yellow
        $missing += $name
        continue
    }

    Write-Host "$tag $name"

    if (-not (Get-GitClean $localPath)) {
        Write-Host "    ! uncommitted changes — commit/push before migrating; skipping" -ForegroundColor Yellow
        continue
    }

    # 1) Ensure the NAS has a current full checkout.
    if (Test-Path (Join-Path $nasPath '.git')) {
        Write-Host "    NAS copy exists -> git pull --ff-only"
        if ($Execute) { Push-Location $nasPath; try { git pull --ff-only } finally { Pop-Location } }
    }
    else {
        Write-Host "    NAS copy missing -> git clone into $nasPath"
        if ($Execute) { git clone $localPath $nasPath }
    }

    # 2) Handle the local working copy.
    if ($isCore) {
        Write-Host "    keep full local checkout (offline fallback)"
    }
    elseif ($Prune) {
        Write-Host "    prune local working copy (remains on NAS + origin)"
        if ($Execute) { Remove-Item -Recurse -Force $localPath }
    }
    else {
        Write-Host "    non-core: local copy left in place (pass -Prune to remove)"
    }
}

Write-Host ('-' * 60)
if ($missing.Count) {
    Write-Host "Not found on disk (check names in the manifest): $([string]::Join(', ', $missing))" -ForegroundColor Yellow
}
Write-Host "Done.$(if (-not $Execute) { ' (dry-run — nothing changed)' })"
Write-Host ""
Write-Host "Next: point Claude Code at the NAS set (primary) + local core (fallback)."
Write-Host "See docs/decisions/nas-canonical-skills.md -> Layout."
