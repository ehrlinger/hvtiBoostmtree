# Changelog

## hvtiBoostmtree 2.0.1

### Bug Fixes

- [`vimpPlot()`](https://ehrlinger.github.io/hvtiBoostmtree/reference/vimpPlot.md)
  no longer over-supplies bar labels. The internal
  [`graphics::text()`](https://rdrr.io/r/graphics/text.html) calls
  passed `rep(xvar.names, 3)` — three labels for every bar — which
  triggered a `'labels' truncated to length ...` warning and could
  mislabel bars. Labels now correspond one-to-one with the plotted bars.
- [`plot.boostmtree()`](https://ehrlinger.github.io/hvtiBoostmtree/reference/plot.boostmtree.md)
  now draws the optimal-iteration reference line for every class of a
  multiclass (Nominal/Ordinal) prediction object. The internal
  [`abline()`](https://rdrr.io/r/graphics/abline.html) calls indexed an
  already-scalar `Mopt` as `Mopt[q]`, yielding `NA` (and a silently
  missing line) for the second and later classes.

## hvtiBoostmtree 2.0.0

### Breaking Changes

- Package renamed from `boostmtree` to `hvtiBoostmtree` (internal-only
  fork; the original `boostmtree` name remains with the upstream CRAN
  package). The
  [`boostmtree()`](https://ehrlinger.github.io/hvtiBoostmtree/reference/boostmtree.md)
  function and S3 methods are unchanged — usage is now
  [`library(hvtiBoostmtree); boostmtree(...)`](https://ehrlinger.github.io/hvtiBoostmtree/).
- Minimum R version bumped to 4.1.0.
- Maintainership transferred to John Ehrlinger. Original authors
  (Ishwaran, Pande, Kogalur) remain as authors.

### New Features

- Added `ggRandomForests`, `hvtiPlotR`, and `hvtiRutilities` as optional
  suggested dependencies for enhanced ggplot2-based visualization
  workflows.
- Added two vignettes: *Introduction to boostmtree* and *Longitudinal
  Data Analysis with boostmtree*.
- pkgdown documentation site fully restructured with reference index,
  articles, and sidebar badges.
- `BugReports` field added to DESCRIPTION pointing to GitHub Issues.

### Documentation

- Comprehensive README rewritten with full badge set, installation
  instructions, quick-start examples, and reference citations.
- `NEWS.md` introduced (in addition to `inst/NEWS`) for pkgdown
  changelog rendering.

------------------------------------------------------------------------
