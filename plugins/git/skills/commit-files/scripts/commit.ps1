[CmdletBinding()]
param([string]$Workspace='.',[Parameter(Mandatory=$true)][string[]]$Paths,[Parameter(Mandatory=$true)][string]$Message,[switch]$Apply)
Set-StrictMode -Version Latest;$ErrorActionPreference='Stop'
$root=(Resolve-Path -LiteralPath $Workspace).Path
if([string]::IsNullOrWhiteSpace($Message)-or $Message.Length -gt 200){throw 'Message must be 1..200 characters'}
if(-not $Paths.Count){throw 'At least one path is required'}
$rels=@();foreach($p in $Paths){if([IO.Path]::IsPathRooted($p)-or $p -match '(^|[\\/])\.\.([\\/]|$)'){throw "path must be workspace-relative: $p"};$full=[IO.Path]::GetFullPath((Join-Path $root $p));$prefix=[IO.Path]::GetFullPath($root);if(-not $prefix.EndsWith([IO.Path]::DirectorySeparatorChar)){$prefix+=[IO.Path]::DirectorySeparatorChar};if(-not $full.StartsWith($prefix,[StringComparison]::OrdinalIgnoreCase)){throw "path escapes workspace: $p"};if(-not(Test-Path -LiteralPath $full)){throw "path does not exist: $p"};$rels+=$p}
$quoted=($rels|ForEach-Object{'"'+$_+'"'}) -join ' '
$add='git -C "'+$root+'" add -- '+$quoted;$commit='git -C "'+$root+'" commit -m "'+($Message.Replace('"','\"'))+'"'
if(-not $Apply){Write-Output ('dry run: '+$add);Write-Output ('dry run: '+$commit);return}
if(-not(Get-Command git -ErrorAction SilentlyContinue)){throw 'git is not installed'}
& git -C $root rev-parse --is-inside-work-tree *> $null;if($LASTEXITCODE -ne 0){throw 'workspace is not a Git repository'}
& git -C $root add -- @rels;if($LASTEXITCODE -ne 0){throw "git add failed: $LASTEXITCODE"}
& git -C $root commit -m $Message;if($LASTEXITCODE -ne 0){throw "git commit failed: $LASTEXITCODE"}
return
