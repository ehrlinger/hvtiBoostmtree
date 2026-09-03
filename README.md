# hvtiBoostmtree: Boosted Multivariate Trees for Longitudinal Data

> ## 🔴 RETIRED (2026-09-03). Do not use for new work.
>
> This package is archived and read-only. It duplicated an upstream package that is
> actively published on CRAN, and it carries a correctness bug (below).
>
> ### Known bug in this package
>
> Fitting with `cv.flag = TRUE` leaves the stored terminal-node coefficients
> (`gamma`) divergent. The in-sample linear predictor and mean are refreshed only
> in the `else` branch of `if (cv.flag)` (`R/boostmtree.R:1308`), so with
> cross-validation enabled the working fit stays frozen at its initialization, the
> ridge penalty collapses, and the linear predictor accumulates unshrunk increments
> that grow linearly in `M`.
>
> Everything that reads the stored `gamma` returns values far outside the observed
> response range, silently: `predict(use.cv.flag = FALSE)`, `partialPlot()`,
> `marginalPlot()`, `muhat`, and `vimp()` on the non-cross-validated path.
> Cross-validated output was not directly corrupted, which is why the bug hid.
>
> ⚠️ **If you ran an analysis with this package using `cv.flag = TRUE`, audit it.**
> Archiving does not un-corrupt finished work.
>
> ### What to use instead
>
> The bug is present in CRAN `boostmtree` 2.0.0 as well (its
> `boostmtree_fit_tree.R` is byte-identical to the commit it was diagnosed on), so
> CRAN is not a safe migration target until upstream ships a fix. Use the patched
> fork:
>
> ```r
> remotes::install_github("ehrlinger/boostmtree_src",
>                         subdir = "boostmtree", ref = "v2.0.1-ccf")
> ```
>
> Reported upstream as
> [kogalur/boostmtree#2](https://github.com/kogalur/boostmtree/issues/2) and
> [#3](https://github.com/kogalur/boostmtree/pull/3). Once a fixed release reaches
> CRAN, prefer CRAN.

<!-- badges: start -->
[![R-CMD-check](https://github.com/ehrlinger/hvtiBoostmtree/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ehrlinger/hvtiBoostmtree/actions/workflows/R-CMD-check.yaml)
[![test coverage](https://codecov.io/gh/ehrlinger/hvtiBoostmtree/graph/badge.svg)](https://app.codecov.io/gh/ehrlinger/hvtiBoostmtree)
[![pkgdown](https://github.com/ehrlinger/hvtiBoostmtree/actions/workflows/pkgdown.yaml/badge.svg)](https://ehrlinger.github.io/hvtiBoostmtree/)
[![Lifecycle: superseded](https://img.shields.io/badge/lifecycle-superseded-blue.svg)](https://lifecycle.r-lib.org/articles/stages.html#superseded)
[![License: GPL (>= 3)](https://img.shields.io/badge/License-GPL%20(%3E%3D%203)-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Repo status: unsupported](https://www.repostatus.org/badges/latest/unsupported.svg)](https://www.repostatus.org/#unsupported)
<!-- badges: end -->

> **Fork notice:** `hvtiBoostmtree` is an internal-only fork of
> [kogalur/boostmtree](https://github.com/kogalur/boostmtree), branched
> at **v1.5.1** and diverging independently since. It was renamed from
> `boostmtree` to `hvtiBoostmtree` so it no longer collides with the
> upstream `boostmtree` package on CRAN. The fitting function is still
> `boostmtree()` — only the package name changed.

**hvtiBoostmtree** implements Friedman's (2001) gradient descent boosting algorithm for modeling longitudinal responses using multivariate tree base learners. Covariate-time interactions are captured via penalized B-splines (P-splines) with an adaptively estimated smoothing parameter. The package handles continuous, binary, nominal, and ordinal responses, and works equally well for cross-sectional data.

## Features

- Gradient boosting with multivariate tree base learners (powered by [randomForestSRC](https://cran.r-project.org/package=randomForestSRC))
- P-spline modeling of covariate × time interactions with adaptive smoothing
- Stochastic gradient descent with bootstrap sampling and OOB error estimation
- In-sample cross-validation for optimal stopping iteration selection
- Variable importance (VIMP) via permutation, including joint VIMP
- Partial and marginal dependence plots
- Supports **Continuous**, **Binary**, **Nominal**, and **Ordinal** longitudinal responses
- Parallel processing via the `parallel` package
- Missing covariate imputation (on-the-fly, via `randomForestSRC`)

## Installation

This fork is available from GitHub only:

```r
# install.packages("remotes")
remotes::install_github("ehrlinger/hvtiBoostmtree")
```

### Optional enhanced visualization

For ggplot2-based visualization workflows, install the suggested packages:

```r
remotes::install_github("ehrlinger/ggRandomForests")
remotes::install_github("ehrlinger/hvtiPlotR")
remotes::install_github("ehrlinger/hvtiRutilities")
```

## Quick Start

### Simulated continuous longitudinal data

```r
library(hvtiBoostmtree)

## Simulate training and test data (model 1: linear time × covariate interaction)
set.seed(42)
dta <- simLong(n = 100, ntest = 100, model = 1, family = "Continuous", q = 5)

## Fit the model
fit <- boostmtree(
  x  = dta$dtaL$features[dta$trn, ],
  tm = dta$dtaL$time[dta$trn],
  id = dta$dtaL$id[dta$trn],
  y  = dta$dtaL$y[dta$trn],
  family = "Continuous",
  M  = 200,
  cv.flag = TRUE   # enables OOB-based optimal stopping
)

print(fit)
plot(fit)
```

### Predict on held-out data

```r
pred <- predict(
  fit,
  x  = dta$dtaL$features[-dta$trn, ],
  tm = dta$dtaL$time[-dta$trn],
  id = dta$dtaL$id[-dta$trn],
  y  = dta$dtaL$y[-dta$trn]
)

print(pred)
plot(pred)
```

### Variable importance

```r
## Individual VIMP for all covariates
vimp_obj <- vimp.boostmtree(fit)
vimpPlot(vimp_obj)

## Joint VIMP for a pair of variables
vimp_joint <- vimp.boostmtree(fit, x.names = c("x1", "x2"), joint = TRUE)
```

### Partial and marginal dependence plots

```r
## Marginal plot (fast, unadjusted)
marginalPlot(fit, xvar.names = c("x1", "x2"))

## Partial dependence plot (slower, confounder-adjusted)
partialPlot(fit, xvar.names = "x1")
```

### Binary response — Atrial Fibrillation data

```r
data(AF, package = "hvtiBoostmtree")

fit_af <- boostmtree(
  x      = AF$feature,
  tm     = AF$time,
  id     = AF$id,
  y      = AF$y,
  family = "Binary",
  M      = 300,
  cv.flag = TRUE
)

print(fit_af)
plot(fit_af)

## Variable importance
vimp_af <- vimp.boostmtree(fit_af)
vimpPlot(vimp_af)
```

### Continuous response — Spirometry data

```r
data(spirometry, package = "hvtiBoostmtree")

fit_spi <- boostmtree(
  x      = spirometry$features,
  tm     = spirometry$time,
  id     = spirometry$id,
  y      = spirometry$y,
  family = "Continuous",
  M      = 300,
  cv.flag = TRUE
)

print(fit_spi)
marginalPlot(fit_spi, xvar.names = colnames(spirometry$features)[1:4])
```

## Key Functions

| Function | Description |
|---|---|
| `boostmtree()` | Fit a boosted multivariate tree model |
| `predict.boostmtree()` | Predict on new data |
| `print.boostmtree()` | Print model summary |
| `plot.boostmtree()` | Diagnostic plots (error curve, fitted values, residuals) |
| `vimp.boostmtree()` | Variable importance scores |
| `vimpPlot()` | Plot variable importance |
| `marginalPlot()` | Marginal dependence plots (fast) |
| `partialPlot()` | Partial dependence plots (adjusted) |
| `simLong()` | Simulate longitudinal data |

## Datasets

| Dataset | Subjects | Observations | Response | Description |
|---|---|---|---|---|
| `AF` | 228 | 7,949 | Binary | Atrial fibrillation presence/absence after surgical ablation |
| `spirometry` | 509 | 9,471 | Continuous | FEV1% after lung transplantation |

## Documentation

Full documentation is available at **<https://ehrlinger.github.io/hvtiBoostmtree/>**, including:

- [Reference manual](https://ehrlinger.github.io/hvtiBoostmtree/reference/)
- [Introduction vignette](https://ehrlinger.github.io/hvtiBoostmtree/articles/introduction.html)
- [Longitudinal analysis vignette](https://ehrlinger.github.io/hvtiBoostmtree/articles/longitudinal-analysis.html)

## Authors

- **Hemant Ishwaran** — original methodology
- **Amol Pande** — original methodology
- **Udaya B. Kogalur** — original implementation
- **John Ehrlinger** — current maintainer

## Citation

If you use **hvtiBoostmtree** in your research, please cite:

> Pande A., Li L., Rajeswaran J., Ehrlinger J., Kogalur U.B., Blackstone E.H., Ishwaran H. (2017).
> Boosted multivariate trees for longitudinal data.
> *Machine Learning*, 106(2): 277–305.
> doi: [10.1007/s10994-016-5597-1](https://doi.org/10.1007/s10994-016-5597-1)

```r
citation("hvtiBoostmtree")
```

## References

Friedman J.H. (2001). Greedy function approximation: a gradient boosting machine.
*Annals of Statistics*, 29(5): 1189–1232.

Friedman J.H. (2002). Stochastic gradient boosting.
*Computational Statistics & Data Analysis*, 38(4): 367–378.

Pande A., Li L., Rajeswaran J., Ehrlinger J., Kogalur U.B., Blackstone E.H., Ishwaran H. (2017).
Boosted multivariate trees for longitudinal data.
*Machine Learning*, 106(2): 277–305.
doi: [10.1007/s10994-016-5597-1](https://doi.org/10.1007/s10994-016-5597-1)

## License

GPL (>= 3) — see [LICENSE](LICENSE) for details.
