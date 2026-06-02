# Changelog

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
