<#
.SYNOPSIS
  Survey D: (max 3 levels deep) for directories that are Claude Code Skills,
  Plugins, or MCP-configured, emit a markdown table to the vault, and list
  which ones are not yet backed by a GitHub remote.

.DESCRIPTION
  Read-only except for writing the output markdown file. For each directory
  under -Root, down to -MaxDepth levels, it detects:
    * Skill   -> contains SKILL.md
    * Plugin  -> contains .claude-plugin\plugin.json
    * MCP     -> contains .mcp.json
  For every marker-bearing directory it finds the nearest ancestor holding a
  .git, reads that repo's origin remote, and flags "Needs GitHub" when there
  is no git repo at all, or a git repo whose origin does not point at GitHub.

  Heavy/noise directories (node_modules, .git internals, build outputs, the
  recycle bin, etc.) are pruned so the walk stays fast.

.PARAMETER Root
  Drive/folder to survey. Default D:\.

.PARAMETER MaxDepth
  How many levels below Root to descend. 3 = "max 3 levels in" (D:\a\b\c).

.PARAMETER VaultPath
  Where to write the markdown table. Default is the SoftwarePractices vault
  folder over UNC (so it resolves even when the NAS drive mapping is dropped).

.EXAMPLE
  .\survey-d-skills.ps1
  .\survey-d-skills.ps1 -Root D:\ -MaxDepth 3 -VaultPath '\\192.158.68.77\disk1\SecondBrainData\SoftwarePractices\D-skills-plugins-mcp-survey.md'
#>
[CmdletBinding()]
param(
    [string] $Root = 'D:\',
    [int]    $MaxDepth = 3,
    [string] $VaultPath = '\\192.158.68.77\disk1\SecondBrainData\SoftwarePractices\D-skills-plugins-mcp-survey.md'
)

$ErrorActionPreference = 'Stop'

$Skip = @(
    'node_modules', '.git', '.venv', 'venv', 'env', '__pycache__',
    'dist', 'build', 'out', '.next', '.nuxt', 'bin', 'obj', '.idea',
    '.vscode', '$Recycle.Bin', 'System Volume Information'
)

if (-not (Test-Path -LiteralPath $Root)) { throw "Root not found: $Root" }

# --- Walk directories up to MaxDepth, pruning noise -------------------------
function Get-SurveyDirs {
    param([string] $Start, [int] $Depth, [string[]] $Prune)
    $out   = New-Object System.Collections.Generic.List[string]
    $stack = New-Object System.Collections.Stack
    $stack.Push([pscustomobject]@{ Path = $Start; Depth = 0 })
    while ($stack.Count -gt 0) {
        $node = $stack.Pop()
        $out.Add($node.Path)
        if ($node.Depth -ge $Depth) { continue }
        try { $kids = Get-ChildItem -LiteralPath $node.Path -Directory -Force -ErrorAction Stop }
        catch { continue }
        foreach ($k in $kids) {
            if ($Prune -contains $k.Name) { continue }
            $stack.Push([pscustomobject]@{ Path = $k.FullName; Depth = ($node.Depth + 1) })
        }
    }
    return $out
}

# --- Nearest ancestor (inclusive) that holds a .git -------------------------
function Find-GitRoot {
    param([string] $Dir, [string] $StopAt)
    $cur = (Resolve-Path -LiteralPath $Dir).Path
    $stop = (Resolve-Path -LiteralPath $StopAt).Path
    while ($cur.Length -ge $stop.Length) {
        if (Test-Path -LiteralPath (Join-Path $cur '.git')) { return $cur }
        $parent = Split-Path $cur -Parent
        if (-not $parent -or $parent -eq $cur) { break }
        $cur = $parent
    }
    return $null
}

Write-Host "Surveying $Root (max depth $MaxDepth)..."
$dirs = Get-SurveyDirs -Start $Root -Depth $MaxDepth -Prune $Skip

$remoteCache = @{}
function Get-OriginRemote {
    param([string] $GitRoot)
    if ($null -eq $GitRoot) { return $null }
    if ($remoteCache.ContainsKey($GitRoot)) { return $remoteCache[$GitRoot] }
    $url = $null
    try { $url = (& git -C $GitRoot remote get-url origin 2>$null) } catch { }
    if ([string]::IsNullOrWhiteSpace($url)) { $url = $null } else { $url = $url.Trim() }
    $remoteCache[$GitRoot] = $url
    return $url
}

$rows = New-Object System.Collections.Generic.List[object]
foreach ($d in $dirs) {
    $isSkill  = Test-Path -LiteralPath (Join-Path $d 'SKILL.md')
    $isPlugin = Test-Path -LiteralPath (Join-Path $d '.claude-plugin\plugin.json')
    $isMcp    = Test-Path -LiteralPath (Join-Path $d '.mcp.json')
    if (-not ($isSkill -or $isPlugin -or $isMcp)) { continue }

    $gitRoot = Find-GitRoot -Dir $d -StopAt $Root
    $remote  = Get-OriginRemote -GitRoot $gitRoot
    $isGitHub = ($remote -and $remote -match 'github\.com')
    $needsGitHub = (-not $gitRoot) -or (-not $isGitHub)

    $rows.Add([pscustomobject]@{
        Directory   = $d
        Skill       = $isSkill
        Plugin      = $isPlugin
        Mcp         = $isMcp
        GitRoot     = $gitRoot
        Remote      = $remote
        NeedsGitHub = $needsGitHub
    })
}

# --- Build the markdown -----------------------------------------------------
$mark = { param($b) if ($b) { '✓' } else { '' } }
$rel  = { param($p) if ($p) { $p.Substring([Math]::Min($Root.Length, $p.Length)) } else { '' } }

$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine("# D: Skills / Plugins / MCP survey")
[void]$sb.AppendLine()
[void]$sb.AppendLine("- Root: ``$Root``  |  Max depth: $MaxDepth")
[void]$sb.AppendLine("- Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm')")
[void]$sb.AppendLine("- Marker-bearing directories found: $($rows.Count)")
[void]$sb.AppendLine()
[void]$sb.AppendLine("| Directory (under D:\) | Skill | Plugin | MCP | Git repo | Origin remote | Needs GitHub |")
[void]$sb.AppendLine("|---|:---:|:---:|:---:|---|---|:---:|")
foreach ($r in ($rows | Sort-Object Directory)) {
    $git = if ($r.GitRoot) { "``$(& $rel $r.GitRoot)``" } else { '_none_' }
    $rem = if ($r.Remote)  { $r.Remote } else { '_none_' }
    $ng  = if ($r.NeedsGitHub) { '**yes**' } else { 'no' }
    [void]$sb.AppendLine("| ``$(& $rel $r.Directory)`` | $(& $mark $r.Skill) | $(& $mark $r.Plugin) | $(& $mark $r.Mcp) | $git | $rem | $ng |")
}
[void]$sb.AppendLine()

# --- Section: repos needing GitHub (deduped by git root, else by dir) --------
$needing = $rows | Where-Object { $_.NeedsGitHub }
$byRepo  = $needing | Group-Object { if ($_.GitRoot) { $_.GitRoot } else { $_.Directory } }
[void]$sb.AppendLine("## Needs to be added to GitHub")
[void]$sb.AppendLine()
if ($byRepo.Count -eq 0) {
    [void]$sb.AppendLine("_None — every marker-bearing directory maps to a GitHub-remote repo._")
} else {
    [void]$sb.AppendLine("| Repo / directory | Reason |")
    [void]$sb.AppendLine("|---|---|")
    foreach ($g in ($byRepo | Sort-Object Name)) {
        $first = $g.Group[0]
        $reason = if (-not $first.GitRoot) { 'no git repo' } else { "git repo, non-GitHub origin ($($first.Remote))" }
        [void]$sb.AppendLine("| ``$(& $rel $g.Name)`` | $reason |")
    }
}
[void]$sb.AppendLine()

# --- Write to vault (and echo a local copy next to the script) --------------
$vaultDir = Split-Path $VaultPath -Parent
if (-not (Test-Path -LiteralPath $vaultDir)) {
    Write-Warning "Vault folder not reachable: $vaultDir (NAS mapping dropped?). Writing local copy only."
    $VaultPath = Join-Path $PSScriptRoot 'D-skills-plugins-mcp-survey.md'
}
$sb.ToString() | Set-Content -LiteralPath $VaultPath -Encoding UTF8
Write-Host "Wrote survey -> $VaultPath"
Write-Host "  marker dirs: $($rows.Count) | needing GitHub: $(($byRepo | Measure-Object).Count)"
