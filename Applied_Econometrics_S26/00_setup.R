# ============================================================
# BUAD 405 Applied Econometrics - Summer '26
# 00_setup.R
#
# Run this ONCE, right after opening the project for the
# first time. It installs (if needed) and loads every R
# package used across the course, so later tutorials just
# assume these are already available.
#
# Safe to re-run any time - it skips anything already installed.
# ============================================================

required_packages <- c(
  # ---- Data import / handling ----
  "readxl",       # reading the .xlsx codebooks
  "dplyr",        # data wrangling (filter, mutate, group_by, summarise)
  "tidyr",        # reshaping data (pivot_longer/wider)

  # ---- Visualisation ----
  "ggplot2",      # used from Tutorial 2 onward for cleaner plots

  # ---- Core econometrics ----
  "lmtest",       # coeftest(), hypothesis tests on regression models
  "sandwich",     # robust / clustered standard errors
  "car",          # linearHypothesis(), VIF, general regression diagnostics
  "AER",          # instrumental variables (ivreg) and applied econometrics datasets
  "plm",          # panel data models (fixed effects, random effects)

  # ---- Reporting ----
  "broom",        # tidy() model output into data frames
  "modelsummary", # regression tables for reports/knitted output
  "knitr",        # used when knitting .Rmd files to PDF/HTML
  "rmarkdown"     # required to knit .Rmd files (e.g. expected_outputs docs)
)

# Install anything missing, then load everything
new_packages <- required_packages[!(required_packages %in% installed.packages()[, "Package"])]

if (length(new_packages) > 0) {
  cat("Installing", length(new_packages), "package(s):",
      paste(new_packages, collapse = ", "), "\n\n")
  install.packages(new_packages)
} else {
  cat("All required packages are already installed.\n\n")
}

invisible(lapply(required_packages, function(pkg) {
  library(pkg, character.only = TRUE)
}))

cat("\nSetup complete. Loaded packages:\n")
cat(paste(" -", required_packages), sep = "\n")
cat("\nYou're ready to start the tutorial script.\n")
