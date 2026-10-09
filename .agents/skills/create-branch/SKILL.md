---
name: create-branch
description: Create a branch for an assigned change from an up-to-date main, named as CONTRIBUTING.md "Names" sets. Use when starting a change, before its first commit; not for switching to a branch that exists.
---

# Create a branch

1. Check that the working tree is clean: `git status --short` prints nothing.
   Otherwise stop and ask the maintainer; never stash or discard changes.
2. Bring the base up to date: `git fetch origin main`.
3. Name: `<type>/<short-name>`, with a type from CONTRIBUTING.md, "Names".
4. Create the branch from the fetched main, without tracking it:
   `git switch --no-track -c <type>/<short-name> origin/main`.
5. Check: `git status --short --branch` shows the new branch and nothing else.
