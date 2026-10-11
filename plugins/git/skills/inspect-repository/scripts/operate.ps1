[CmdletBinding()]
param([ValidateSet('status','branch','head','log','diff-summary')][string]$Operation='status',[string]$Workspace='.',[int]$Count=10,[switch]$Execute)
Set-StrictMode -Version Latest;$ErrorActionPreference='Stop'
$root=(Resolve-Path -LiteralPath $Workspace).Path
if($Count -lt 1 -or $Count -gt 100){throw 'Count must be 1..100'}
$cmd=@{status=@('status','--short','--branch');branch=@('branch','--show-current');head=@('rev-parse','HEAD');log=@('log',"-$Count",'--oneline','--decorate');'diff-summary'=@('diff','--stat')}[$Operation]
$display='git -C "'+$root+'" '+($cmd -join ' ')
if(-not $Execute){Write-Output ('dry run: '+$display);return}
if(-not(Get-Command git -ErrorAction SilentlyContinue)){throw 'git is not installed'}
& git -C $root rev-parse --is-inside-work-tree *> $null;if($LASTEXITCODE -ne 0){throw 'workspace is not a Git repository'}
& git -C $root @cmd
if($LASTEXITCODE -ne 0){throw "git operation failed: $LASTEXITCODE"}
return
