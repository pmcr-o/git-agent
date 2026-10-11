---
name: inspect-repository
description: "Inspect a workspace Git repository using read-only status, branch, HEAD, log, and diff-summary operations."
---
# inspect-repository
Route: `@git-agent /git:inspect-repository`.

Default is dry-run and prints the exact Git command. `-Execute` runs only the selected read-only operation. Agent and terminal use the same `scripts/operate.ps1`. No mutation and no network access.
