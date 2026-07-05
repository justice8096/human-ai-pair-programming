<#
.SYNOPSIS
  Make the NAS the prime store for Claude Code skill repos, keeping only a
  load-bearing core checked out locally. Git-based; safe by default.

.DESCRIPTION
  Implements docs/decisions/nas-canonical-skills.md.

  For every git repo found under -LocalRoot:
    * if it is not yet on the NAS, clone it there (full checkout);
    * otherwise `git pull` the NAS copy to keep it current.
  Repos named in -CoreRepos are kept as full local checkouts (the offline
  fallback). Non-core repos are reported as prunable and, ONLY with -Prune,
  their local working copy is removed (they remain on the NAS + git origin).

  Source of truth is git: this script never copies files between locations,
  it clones/pulls. Nothing is removed unless you pass BOTH -Execute and
  -Prune.

.PARAMETER LocalRoot
  Parent folder on D: that currently holds the skill repos. REQUIRED.
  Example: D:\skills

.PARAMETER NasRoot
  Destination on the NAS. Defaults to the UNC path (not a drive letter, on
  purpose — survives the mapping dropping).

.PARAMETER CoreRepos
  Names (folder names) of the repos that MUST stay fully local as the
  offline fallback. Everything else becomes NAS-only.

.PARAMETER Execute
  Actually perform clones/pulls. Without it, the script only reports.

.PARAMETER Prune
  In addition to -Execute, remove local working copies of non-core repos.
  Requires a clean git state per repo; dirty repos are skipped and reported.

.EXAMPLE
  # See what would happen — changes nothing:
  .\sync-skills-to-nas.ps1 -LocalRoot D:\skills -CoreRepos deep-research,dataviz

.EXAMPLE
  # Clone/pull to the NAS, keep core local, leave non-core local copies in place:
  .\sync-skills-to-nas.ps1 -LocalRoot D:\skills -CoreRepos deep-research,dataviz -Execute

.EXAMPLE
  # Full intended end state: NAS prime, only core kept locally:
  .\sync-skills-to-nas.ps1 -LocalRoot D:\skills -CoreRepos deep-research,dataviz -Execute -Prune
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string] $LocalRoot,

    [string] $NasRoot = '\\192.158.68.77\disk1\skills',

    [string[]] $CoreRepos = @(),

    [switch] $Execute,

    [switch] $Prune
)

$ErrorActionPreference = 'Stop'

function Test-GitRepo {
    param([string] $Path)
    Test-Path (Join-Path $Path '.git')
}

function Get-GitClean {
    param([string] $Path)
    Push-Location $Path
    try {
        $status = git status --porcelain
        return [string]::IsNullOrWhiteSpace($status)
    }
    finally { Pop-Location }
}

if (-not (Test-Path $LocalRoot)) {
    throw "LocalRoot not found: $LocalRoot"
}

Write-Host "Local root : $LocalRoot"
Write-Host "NAS root   : $NasRoot"
Write-Host "Core repos : $([string]::Join(', ', $CoreRepos))"
Write-Host "Mode       : $(if ($Execute) { 'EXECUTE' } else { 'DRY-RUN' })$(if ($Prune) { ' +PRUNE' } else { '' })"
Write-Host ('-' * 60)

# NAS reachability check — do not proceed blind if the share is down.
if ($Execute -and -not (Test-Path $NasRoot)) {
    Write-Host "NAS root not reachable ($NasRoot). Create the share/folder and" -ForegroundColor Yellow
    Write-Host "ensure it is online before running with -Execute. Aborting." -ForegroundColor Yellow
    exit 1
}

$repos = Get-ChildItem -Path $LocalRoot -Directory | Where-Object { Test-GitRepo $_.FullName }
if (-not $repos) {
    Write-Host "No git repos found under $LocalRoot." -ForegroundColor Yellow
    exit 0
}

foreach ($repo in $repos) {
    $name    = $repo.Name
    $isCore  = $CoreRepos -contains $name
    $nasPath = Join-Path $NasRoot $name
    $tag     = if ($isCore) { '[core]' } else { '[nas-only]' }
    Write-Host "$tag $name"

    $clean = Get-GitClean $repo.FullName
    if (-not $clean) {
        Write-Host "    ! uncommitted changes — commit/push before migrating; skipping" -ForegroundColor Yellow
        continue
    }

    # 1) Ensure the NAS has a current full checkout.
    if (Test-Path (Join-Path $nasPath '.git')) {
        Write-Host "    NAS copy exists -> git pull"
        if ($Execute) {
            Push-Location $nasPath
            try { git pull --ff-only } finally { Pop-Location }
        }
    }
    else {
        Write-Host "    NAS copy missing -> git clone into $nasPath"
        if ($Execute) {
            git clone $repo.FullName $nasPath
        }
    }

    # 2) Handle the local working copy.
    if ($isCore) {
        Write-Host "    keep full local checkout (offline fallback)"
    }
    elseif ($Prune) {
        Write-Host "    prune local working copy (remains on NAS + origin)"
        if ($Execute) {
            Remove-Item -Recurse -Force $repo.FullName
        }
    }
    else {
        Write-Host "    non-core: local copy left in place (pass -Prune to remove)"
    }
}

Write-Host ('-' * 60)
Write-Host "Done.$(if (-not $Execute) { ' (dry-run — nothing changed)' })"
Write-Host ""
Write-Host "Next: point Claude Code at the NAS set (primary) + local core (fallback)."
Write-Host "See docs/decisions/nas-canonical-skills.md -> Layout."
