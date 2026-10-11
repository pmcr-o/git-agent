---
name: commit-files
description: "Create a bounded local Git commit from explicit workspace-relative paths. Dry-run by default; Apply stages only named paths and commits locally. Never pushes."
---
# commit-files
Route: `@git-agent /git:commit-files`.

Pass explicit workspace-relative paths and a commit message. Default prints exact `git add -- ...` and `git commit -m ...` commands. `-Apply` is required for mutation. This skill never pushes, resets, checks out branches, or stages unnamed files.
