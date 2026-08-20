# hvtiBoostmtree

Boosted multivariate trees for longitudinal outcomes. Seven exports: `boostmtree()`,
`vimp.boostmtree()`, `marginalPlot()`, `partialPlot()`, `vimpPlot()`, `simLong()` and
`boostmtree.news()`.

⚠️ **This is an internal FORK of `kogalur/boostmtree`, branched at v1.5.1, and a live
`upstream` remote points at `cran/boostmtree`.** Most of `R/` is upstream's code in upstream's
style. That single fact drives most of the rules below, and it makes "surgical changes" mean
something stronger here than elsewhere: **a reformatting sweep would make any future upstream
pull unmergeable.**

This file is the operational contract and applies in full. It is tool neutral, so Codex and
any other agent read the same rules. Claude Code affordances live in `CLAUDE.md`, which
imports this file.

## Definition of done

- `devtools::test()` passes. The runner is `tests/testthat.R`.
- `devtools::check()` shows **no new errors, warnings or notes**. This package is slow to
  check — budget minutes, not seconds, and do not assume a fast local loop.
- `devtools::document()` has been run and `man/` and `NAMESPACE` are committed with the
  source change.
- New user-facing words are in `inst/WORDLIST` if the spelling gate flags them — after
  checking they are not simply misspelled.

## The automated gates

Seven workflows, the most in the family:

| workflow | fails on |
|---|---|
| `R-CMD-check.yaml` | `R CMD check` across platforms |
| `check-manual.yaml` | the PDF manual build |
| `lint.yaml` | `lintr::lint_package()` |
| `pkgdown.yaml` | the site build |
| `house-style.yaml` | the composed house style in `.claude/house-style.md` |
| `spelling.yaml` | spell check against `inst/WORDLIST` — **unique to this repo in the family** |
| `test-coverage.yaml` | coverage upload |

## Rules for this repo

- **Do not rename anything in upstream's code, and do not reformat it.** Three separate
  reasons, all live:
  1. `M`, `nu`, `K`, `pen.ord` and `lambda.max` are **formal arguments of the exported
     `boostmtree()`**, and `marginalPlot` / `partialPlot` / `vimpPlot` / `vimp.boostmtree` are
     exported functions. Renaming them breaks every caller.
  2. They are the notation of **Pande et al. (2017)**, which this package implements. `m` and
     `k` would sever that correspondence.
  3. The `upstream` remote is live. Reformatting ~950 lines makes a future upstream pull
     unmergeable.

  `object_name_linter` is therefore **OFF** — it flags 753 names, and they are the public API.
  The rule exists to keep *our* code consistent; upstream's naming is not ours to normalise.
- **`line_length_linter` is 120, chosen rather than conceded.** Upstream wraps wide (median
  89, max 155). 120 clears 106 of 111 offenders while still flagging the five genuinely
  unreadable lines — deliberately *not* a limit nothing can exceed. Do not raise it to silence
  the remaining five.
- **`object_usage_linter` is ON and its findings are trustworthy here**, because the package
  is installed in CI. Unlike some siblings, a "no visible global function" warning in this repo
  is worth investigating rather than dismissing.
- **Superassignment has been removed from live code.** The only `<<-` left is inside a comment
  in `R/generic.predict.boostmtree.R`. The design and plan for that work are in `inst/dev/`.
  Do not reintroduce `<<-`; it is a CRAN objection as well as a correctness one.
- **Roxygen markdown is NOT enabled** — `DESCRIPTION` has no `Roxygen: list(markdown = TRUE)`,
  so use `\code{}`, `\strong{}`, `\emph{}` and `\link{}`. Markdown lands literally in the
  `.Rd`.
  ⚠️ `hvtiPlotR`, `hvtiRdatasets`, `hvtiRtables`, `hvtiRbootstrap`, `hvtiRpropensity` and
  `hvtiverse` all *do* enable it. This repo is with `hvtiRutilities` and `hvtiRtemplates` on
  the other side.
- **`testthat` edition 3.** Test files are `test-*.R` with a hyphen; runner is
  `tests/testthat.R`.
- `VignetteBuilder` is **quarto**.

## Gotchas

- **`boostmtree.news()` is an exported function**, not just a NEWS file — it reads the package
  news at runtime. Changing `NEWS.md`'s structure can break it.
- **`DESCRIPTION`'s `Date:` is 2026-06-02** against version 2.0.1. Refresh it on the next bump.
- Checking is slow enough that it is tempting to skip. The spelling and manual gates in
  particular only run in CI, so a local `devtools::test()` proves less here than in a small
  package.
- `inst/dev/` holds design and plan documents for past refactors. They are history, not
  instructions — read them for *why*, not as a to-do list.

## Git and versioning

- **Never push to `main`.** Branch, then open a PR and let the maintainer merge.
- **`main` is protected by a GitHub ruleset, and nothing in this repo records that.** A clone
  shows no trace of it, so it is stated here. The ruleset is named `protect main`, is
  identical across all twelve hvtiverse repositories, and enforces four rules on the default
  branch: no deletion, no force-push, pull-request-only, and an **automatic Copilot code
  review** on every PR. A rejected push comes from the server, not a local hook.
  ⚠️ It currently requires **zero approvals**. `require_code_owner_review` is set but inert
  because no repository in the family has a `CODEOWNERS` file, so a PR can merge unreviewed.
- **The `upstream` remote is `cran/boostmtree`.** Never push to it. Fetch it to compare, and
  keep our divergence small enough that a comparison stays readable.
- ⚠️ **`gh` resolves the base from the upstream remote, so bare `gh pr create` FAILS here**
  with *"No commits between cran:master and ehrlinger:&lt;branch&gt;"*. It is trying to open a
  pull request against CRAN's mirror. Always be explicit:

  ```bash
  gh pr create --repo ehrlinger/hvtiBoostmtree --base main
  ```

  The same applies to `gh pr list`, `gh pr view` and `gh run` in this repo.
- Versions are **straight three digits** (`2.0.1`). Never a `.9000` suffix or a fourth digit.
- **Patch-digit bumps only**, as fixes land. Minor and major are the maintainer's decision.
- Bump `DESCRIPTION`, refresh its `Date`, and add the matching `NEWS.md` entry in the same
  commit.

## Change discipline

1. **Think before coding.** Do not assume, ask. If the request is ambiguous or a name, path
   or signature is uncertain, surface the confusion rather than running with a guess.
2. **Simplicity first.** Write the minimum that solves the stated problem.
3. **Surgical changes.** Stronger here than elsewhere: touching upstream's code costs a future
   merge. Confine changes to what the task requires, and prefer adding a file over editing one
   upstream owns.
4. **Goal-driven execution.** State what done looks like before starting, and use tests as the
   criterion.

## Prose

Documentation prose follows the house voice, composed into `.claude/house-style.md` and
checked by `house-style.yaml`. Note the spelling gate: prefer a real word to a coined one, and
add to `inst/WORDLIST` only what the domain genuinely requires.
