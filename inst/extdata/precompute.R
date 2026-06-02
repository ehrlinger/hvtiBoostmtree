## Precompute expensive vignette objects and store as RDS files.
##
## Run this script once from the package root before building/checking:
##
##   Rscript inst/extdata/precompute.R
##
## The generated .rds files are gitignored (too large for GitHub, >100 MB).
## They are loaded locally for fast vignette/pkgdown builds when present;
## vignette compilation recomputes the fits when they are absent (e.g. on CI).

library(hvtiBoostmtree)

out_dir <- file.path("inst", "extdata")
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

## ── Spirometry (continuous) ─────────────────────────────────────────────────

data(spirometry, package = "hvtiBoostmtree")

set.seed(2024)
subjects  <- unique(spirometry$id)
n_train   <- floor(0.8 * length(subjects))
trn_subj  <- sample(subjects, n_train)
trn_idx   <- spirometry$id %in% trn_subj

message("Fitting spirometry model (M = 200, cv.flag = TRUE) …")
fit_spi <- boostmtree(
  x       = spirometry$features[trn_idx, ],
  tm      = spirometry$time[trn_idx],
  id      = spirometry$id[trn_idx],
  y       = spirometry$y[trn_idx],
  family  = "Continuous",
  M       = 200,
  nu      = 0.05,
  K       = 5,
  cv.flag = TRUE,
  verbose = TRUE
)
saveRDS(fit_spi, file.path(out_dir, "fit_spi.rds"))
message("  → saved fit_spi.rds")

## ── Atrial Fibrillation (binary) ────────────────────────────────────────────

data(AF, package = "hvtiBoostmtree")

set.seed(2024)
subjects_af <- unique(AF$id)
trn_af_subj <- sample(subjects_af, floor(0.75 * length(subjects_af)))
trn_af      <- AF$id %in% trn_af_subj

message("Fitting AF model (M = 200, cv.flag = TRUE) …")
fit_af <- boostmtree(
  x       = AF$feature[trn_af, ],
  tm      = AF$time[trn_af],
  id      = AF$id[trn_af],
  y       = AF$y[trn_af],
  family  = "Binary",
  M       = 200,
  nu      = 0.05,
  cv.flag = TRUE,
  verbose = TRUE
)
saveRDS(fit_af, file.path(out_dir, "fit_af.rds"))
message("  → saved fit_af.rds")

message("Done.  fit_spi.rds and fit_af.rds written to inst/extdata/ (gitignored, local use only).")
