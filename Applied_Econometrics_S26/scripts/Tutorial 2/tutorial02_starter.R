# ============================================================
# BUAD 405 Applied Econometrics - Summer '26
# Tutorial 2: Linear Regression in R
# Starter script - fill in the blanks marked ___
# ============================================================

# ---- Part A: Open, inspect and verify --------------------------------

dat <- read.csv("data/___")

# This tutorial needs ONE recent observation per country (cross-section),
# not the panel data from Tutorial 1. If not done already, uncomment and clean it up first:

# population arrived as text in Tutorial 1 - fix its class
#dat$population <- as.numeric(gsub(",", "___", dat$population))

# remove the duplicate row carried over from Tutorial 1
#dat <- dat[!duplicated(dat), ]

# keep only the most recent year, so each country appears once
#dat <- subset(dat, year == ___)

# create the log-transformed predictor used throughout this tutorial
dat$log_gdp_pc_ppp <- log(dat$___)

str(dat)
summary(dat)
colSums(is.na(dat))
sum(duplicated(dat$country_code))

# Answer in comments below:
# - What does one row represent?
#
# - Are all units and reference years comparable?
#
# - Which variables contain missing observations?
#
# - How many observations remain for a complete-case model?
#


# ---- Part B: Visualise the focal relationship ---------------------------

plot(youth_unemployment ~ log_gdp_pc_ppp, data = dat,
     xlab = "Log GDP per capita (PPP)",
     ylab = "___")
abline(lm(___ ~ log_gdp_pc_ppp, data = dat))

# Answer in comments below:
# - Describe the direction, form, and strength of the relationship.
#
# - Identify countries that deserve investigation.
#
# - Does this graph establish a causal relationship? Why not?
#


# ---- Part C: Estimate the first model -------------------------------------

m1 <- lm(youth_unemployment ~ ___, data = dat)
summary(m1)
confint(m1)

# Answer in comments below:
# - Interpret the slope in the variables' actual units.
#
# - Interpret its 95% confidence interval.
#
# - Is the intercept substantively meaningful?
#
# - What does R-squared describe?
#


# ---- Part D: Add theoretically justified controls -------------------------

# NOTE (TA): education_enrolment is not yet in global_development_intro.csv.
# Add it (e.g. World Bank SE.SEC.ENRR - secondary school enrolment, % gross)
# to data_prep.R and re-pull before this line will run. Placeholder below.

m2 <- lm(youth_unemployment ~ log_gdp_pc_ppp +
           education_enrolment + internet_use +
           government_effectiveness + region, data = ___)
summary(m2)
confint(m2)
anova(m1, m2)

# Answer in comments below:
# - Why was each control included?
#
# - How did the focal coefficient change?
#
# - What is the reference region?
#
# - Does the comparison establish that Model 2 is causally correct?
#


# ---- Part E: Use robust uncertainty estimates ------------------------------

library(lmtest)
library(sandwich)
coeftest(m2, vcov = vcovHC(m2, type = "___"))

# Answer in comments below:
# - Which conclusions are sensitive to the standard-error choice?
#
# - Why might residual variance differ across countries?
#


# ---- Part F: Inspect diagnostics -------------------------------------------

par(mfrow = c(2, 2))
plot(___)
par(mfrow = c(1, 1))

influence.measures(m2)
sort(cooks.distance(m2), decreasing = ___)[1:5]

# Answer in comments below:
# - Is there evidence of nonlinearity or changing variance?
#
# - Which observations are influential?
#
# - Should they be deleted automatically? Explain.
#
# - What additional model or data check would you run?
#


# ---- Part G: Compare and communicate ---------------------------------------
# Fill in the comparison table as comments (or a separate table/markdown file):
#
#                          Model 1    Model 2
# Focal coefficient
# Robust standard error
# 95% confidence interval
# Observations
# R-squared
# Main limitation
#
# Policy paragraph (<= 250 words): state the comparison, magnitude, and
# uncertainty; identify the population and period; avoid causal language;
# name one data or model limitation; identify one useful next analysis.
