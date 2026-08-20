# =============================================================
# Tutorial 6 -- Factor Analysis (FA) and SEM in R
# BUAD 405 -- Applied Econometrics | Summer '26
# Dataset: Egypt Findex survey microdata
# =============================================================


# ---------------------------------------------------------------
# 0. Before modelling: know your data
# ---------------------------------------------------------------
# - One row = one respondent (not one firm, not one country)
# - The survey WORDING defines the variable -- the short column name does not
# - Most raw yes/no items use 1 = Yes, 2 = No
# - Blanks are often questionnaire skip patterns, not random missingness
# - account_fin and account_mob are already constructed as 1/0
#
# TASK: open the Findex questionnaire (Findex survey-English.pdf) and read
# the exact wording of FIN2, FIN8, FIN9A, FIN25E2, FIN26A, FIN26B before
# touching the code below.

findex <- read.csv("Findex microdata.csv")   # load respondent-level survey data

vars <- c("account_fin","fin2","fin8","fin9a",
          "account_mob","fin25e2","fin26a","fin26b")

lapply(findex[vars], table, useNA = "ifany")  # frequency table per item, incl. NAs -- check coding


# ---------------------------------------------------------------
# 1. Recode into a clean 0/1 item set
# ---------------------------------------------------------------
# account_fin: has an account at a financial institution
# fin2       : has a debit/ATM card
# fin8       : typically keeps money in the account
# fin9a      : received account-balance information
# account_mob: has a mobile money account
# fin25e2    : made an in-store digital purchase
# fin26a     : made a bill payment using a phone/computer
# fin26b     : made an online purchase

library(psych)       # factor analysis, parallel analysis, tetrachoric correlations
library(GPArotation) # oblique/orthogonal rotation methods used by psych::fa()

yes01 <- function(x) ifelse(is.na(x), 0, ifelse(x == 1, 1, 0))  # recode 1=Yes -> 1, else/NA -> 0

items <- data.frame(
  account_fin          = as.numeric(findex$account_fin),  # already 0/1
  debit_card           = yes01(findex$fin2),               # recode raw 1/2/NA -> 0/1
  keeps_money          = yes01(findex$fin8),
  balance_information  = yes01(findex$fin9a),
  mobile_money         = as.numeric(findex$account_mob),   # already 0/1
  store_purchase       = yes01(findex$fin25e2),
  bill_payment         = yes01(findex$fin26a),
  online_purchase      = yes01(findex$fin26b)
)

# TASK: confirm each recoded column with table() against the raw column --
# do the counts of 1s make sense given the survey wording?


# ---------------------------------------------------------------
# 2. Factor analysis: how many latent constructs?
# ---------------------------------------------------------------
# Items are binary -> ordinary Pearson correlation understates their
# association. We use tetrachoric correlation instead (assumes an unobserved
# continuous variable underlies each yes/no answer).

Rtet <- tetrachoric(items)$rho   # tetrachoric correlation matrix for binary items

fa.parallel(Rtet, n.obs = nrow(items), fa = "fa", fm = "minres")
# ^ scree plot + parallel analysis: compares real eigenvalues to random-data
#   eigenvalues, to suggest how many factors to retain

efa <- fa(Rtet, nfactors = 2, n.obs = nrow(items),
          fm = "minres", rotate = "oblimin")   # extracts 2 factors, oblique rotation (factors may correlate)

print(efa$loadings, cutoff = .30, sort = TRUE)  # loading table, hides |loadings| < .30, groups by factor

# TASK: which items load together on Factor 1? On Factor 2? Name each factor
# from the shared meaning of its strongly-loading items (R does not name
# constructs for you). Flag any weak loading (<.30 on every factor) or any
# item that cross-loads notably on both factors.


# ---------------------------------------------------------------
# 3. SEM: measurement model + structural path
# ---------------------------------------------------------------
# Use the two labels you justified from the EFA above. The model below uses
# FormalEngagement and DigitalActivity as placeholder names -- rename them
# in your write-up if you chose different labels.

library(lavaan)   # fits the measurement + structural equation model

model <- '
  FormalEngagement =~ account_fin + debit_card + keeps_money + balance_information
  DigitalActivity  =~ mobile_money + store_purchase + bill_payment + online_purchase
  DigitalActivity  ~  FormalEngagement
'

fit <- sem(model, data = items, ordered = names(items),
           estimator = "WLSMV", std.lv = TRUE)
# ^ fits the SEM: ordered= treats items as categorical (correct for 0/1 data),
#   WLSMV = estimator suited to categorical indicators, std.lv = standardizes
#   the latent factors (mean 0, variance 1) so loadings are comparable

out <- standardizedSolution(fit)   # standardized estimates for every model path

out[out$op == "=~", ]  # measurement table: how strongly each item loads on its construct
out[out$op == "~",  ]  # structural table: FormalEngagement -> DigitalActivity (sign, size, p-value)

inspect(fit, "r2")     # R-squared: variance in DigitalActivity explained by FormalEngagement

fitMeasures(fit, c("cfi", "rmsea"))   # one overall fit check alongside R^2 (CFI ~1 good, RMSEA <.05 good)

# TASK: interpret the measurement table, the structural path (direction +
# strength), and R^2. Keep the language associational -- this is
# cross-sectional survey data, so the model does not by itself establish
# causality.


# ---------------------------------------------------------------
# 4. Mediation preview (concept only -- do NOT estimate here)
# ---------------------------------------------------------------
# Proposed chain for discussion:
#   Education -> Formal Account Engagement -> Digital Financial Activity
#
#   Path a          : Education -> Formal Account Engagement
#   Path b          : Formal Account Engagement -> Digital Financial Activity
#   Indirect effect : a * b
#   Direct effect   : Education -> Digital Financial Activity (with mediator included)
#
# TASK: identify plausible variable(s) for "Education" in the Findex data.
# You will ESTIMATE and INTERPRET this mediation model in Assignment 3 --
# only identify the paths here, do not fit anything yet.
