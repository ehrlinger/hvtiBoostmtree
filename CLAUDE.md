@AGENTS.md

# Claude Code specifics

[`AGENTS.md`](AGENTS.md), imported above, is the operational contract and applies in full. It
is written to be tool neutral so that Codex and other agents read the same rules. Only the
Claude Code affordances live here.

## Before you touch code

`AGENTS.md` says to orient before editing. In Claude Code the way to do that is the codemap:
it lives in the Obsidian vault under `Claude/repomaps/` and is read via the `read-codemap`
skill (`/codemap hvtiBoostmtree`). If the codemap looks stale, say so and offer to refresh it
(`/regenerate-codemap`) rather than working from a guess.

If the vault is not available, say so rather than staying quiet about it, then orient from the
repo itself — `NAMESPACE`, then `R/boostmtree.R` for the main entry point.

## Working against upstream

This is a fork with a live `upstream` remote at `cran/boostmtree`. Before proposing a change
to a file `R/` inherited from upstream, it is worth seeing what upstream has:

```bash
git fetch upstream
git diff upstream/master -- R/<file>.R
```

A large existing diff means our version has already moved; a small one means a reformat here
is expensive. Either way, say which you found rather than editing blind — `AGENTS.md`'s
no-renaming and no-reformatting rules exist to keep that diff readable.

## Prose

`AGENTS.md` points at the composed house style. In Claude Code, apply the `ehrlinger-writing`
skill instead: it carries the same voice, reader persona and project context, kept in sync
from the vault sources `.claude/house-style.md` is composed from. For documentation
*structure*, the `r-package-style` skill is the companion.
