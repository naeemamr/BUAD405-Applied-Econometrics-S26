########################################################################
# BUAD 405 Applied Econometrics - Summer '26
# Tutorial 3: Logistic Regression in R
# Dataset: Polish Companies Bankruptcy (4year.arff)
#
# Each question below appears TWICE:
#   [Q - as asked]   -> the official question, keeping the statistical/
#                        econometric terminology you need to learn.
#   [Q - in plain words] -> the same question translated into everyday
#                        language, so you can check you understood it
#                        before you write your answer.
#
# Answer both style prompts in your own words in the space provided.
# Code chunks are complete and should run start to finish; a short
# comment sits next to each new function telling you what it does.
########################################################################


# ============================================================
# Part A. Import and validate the ARFF file
# ============================================================

install.packages(c("foreign", "dplyr", "ggplot2", "broom",
                    "marginaleffects", "pscl", "pROC"))
# install.packages() -> downloads and installs R packages you don't have yet

library(foreign)      # load package that can read .arff files
library(dplyr)        # load package for data wrangling (filter, mutate, etc.)
library(ggplot2)       # load package for plotting

raw <- read.arff("data/4year.arff")
# read.arff() -> reads a Weka .arff data file into a normal R data frame

dim(raw)     # dim() -> tells you (rows, columns) of the data frame
names(raw)   # names() -> lists the column names
head(raw)    # head() -> shows the first few rows so you can eyeball the data

# The file contains 64 ratios followed by the class label.
names(raw)[1:64] <- paste0("X", 1:64)
# paste0() -> glues text together with no space, e.g. "X" + 1 = "X1"
names(raw)[ncol(raw)] <- "bankrupt"
# ncol() -> counts how many columns the data frame has

table(raw$bankrupt, useNA = "ifany")
# table() -> counts how many times each value occurs (here: 0s, 1s, NAs)
prop.table(table(raw$bankrupt))
# prop.table() -> turns those counts into proportions (share of the total)
colSums(is.na(raw))
# is.na() -> flags TRUE/FALSE for missing values; colSums() adds them up per column

# [Q - as asked] What does one row represent?
# [Q - in plain words] If you picked one single line of this spreadsheet,
#   what real-world "thing" does it describe?
# Your answer:


# [Q - as asked] Are the only outcome values 0 and 1?
# [Q - in plain words] When you look at the bankrupt column, does it ever
#   contain anything other than 0 or 1 (e.g. blanks, text, other numbers)?
# Your answer:


# [Q - as asked] What proportion of observations belongs to the bankruptcy class?
# [Q - in plain words] Out of all the companies, what percentage actually
#   went bankrupt?
# Your answer:


# [Q - as asked] Why is class balance especially important before using a
#   confusion matrix?
# [Q - in plain words] If almost none of the companies went bankrupt, why
#   could that trip up how we judge whether the model is "good"?
# Your answer:


# ============================================================
# Part B. Select and prepare the modelling variables
# ============================================================

df <- raw %>%
  transmute(
    bankrupt         = as.integer(as.character(bankrupt)),
    profitability    = X1,
    leverage         = X2,
    working_capital  = X3,
    current_ratio    = X4,
    asset_turnover   = X9,
    log_assets       = X29
  )
# %>% (pipe) -> takes what's on the left and feeds it into the next function
# transmute() -> builds a new data frame keeping/renaming only the columns listed
# as.character()/as.integer() -> convert the factor labels into real 0/1 numbers

summary(df)          # summary() -> quick min/mean/max/etc. for every column
colSums(is.na(df))   # same missing-value check, now on the trimmed dataset

model_df <- na.omit(df)
# na.omit() -> drops any row that has a missing value in any column
nrow(df) - nrow(model_df)
# nrow() -> counts how many rows a data frame has
table(model_df$bankrupt)
prop.table(table(model_df$bankrupt))

# [Q - as asked] How many observations were removed by complete-case analysis?
# [Q - in plain words] How many companies got dropped because they had at
#   least one blank/missing value?
# Your answer:


# [Q - as asked] Could missing-value deletion change the represented sample?
# [Q - in plain words] Could throwing away those rows accidentally make the
#   remaining companies look different from the full population (e.g. only
#   healthier or only better-reporting firms left)?
# Your answer:


# [Q - as asked] Why should the outcome remain numeric 0/1 for this exercise?
# [Q - in plain words] Why do we need "bankrupt" to be the numbers 0 and 1
#   instead of, say, the words "yes"/"no", for the model to work?
# Your answer:


# ============================================================
# Part C. Explore the outcome and predictors
# ============================================================

model_df %>%
  group_by(bankrupt) %>%
  summarise(across(profitability:log_assets,
                    list(mean = mean, median = median)))
# group_by() -> splits the data into groups (bankrupt = 0 vs 1)
# summarise() + across() -> applies mean()/median() to every ratio column
#   separately for each group

ggplot(model_df, aes(x = factor(bankrupt), y = profitability)) +
  geom_boxplot() +
  labs(x = "Bankruptcy status", y = "Net profit / total assets")
# ggplot()/aes() -> sets up a plot and which columns go on which axis
# factor() -> tells R to treat 0/1 as categories, not numbers, for the plot
# geom_boxplot() -> draws a box-and-whisker plot to compare the two groups
# labs() -> sets the axis labels

ggplot(model_df, aes(x = factor(bankrupt), y = leverage)) +
  geom_boxplot() +
  labs(x = "Bankruptcy status", y = "Total liabilities / total assets")

# [Q - as asked] Which ratios show the clearest raw differences?
# [Q - in plain words] Looking at the boxplots/table, which financial ratios
#   look most different between companies that went bankrupt and those that
#   didn't?
# Your answer:


# [Q - as asked] Why do raw group differences not establish that a ratio
#   causes bankruptcy?
# [Q - in plain words] Even if bankrupt and healthy companies look different
#   on a ratio, why can't we say that ratio "caused" the bankruptcy?
# Your answer:


# ============================================================
# Part D. Estimate logistic-regression models
# ============================================================

model1 <- glm(
  bankrupt ~ profitability,
  data = model_df,
  family = binomial(link = "logit")
)
# glm() -> fits a regression model; family = binomial(link="logit") tells it
#   to fit a LOGISTIC regression (outcome is 0/1, not a continuous number)

model2 <- glm(
  bankrupt ~ profitability + leverage + working_capital +
    current_ratio + asset_turnover + log_assets,
  data = model_df,
  family = binomial(link = "logit")
)

summary(model1)   # summary() -> prints coefficients, std errors, p-values, etc.
summary(model2)

# [Q - as asked] Which coefficients are positive or negative?
# [Q - in plain words] For each ratio in model2, does a higher value push
#   the bankruptcy odds up (+) or down (-)?
# Your answer:


# [Q - as asked] For H0: beta_j = 0, which predictors have p-values below 0.05?
# [Q - in plain words] Which ratios are "statistically significant" at the
#   usual 5% cutoff, meaning we're fairly confident their effect isn't just
#   noise?
# Your answer:


# [Q - as asked] Why should a logit coefficient not be interpreted directly
#   as a probability-point change?
# [Q - in plain words] Why can't you just read a coefficient of, say, 0.5
#   as "a 0.5 percentage-point change in the chance of bankruptcy"?
# Your answer:


# [Q - as asked] Does statistical significance establish causality?
# [Q - in plain words] Just because a ratio is significant, does that prove
#   it's actually causing bankruptcy?
# Your answer:


# ============================================================
# Part E. Convert results into interpretable quantities
# ============================================================

library(broom)              # tidy() -> turns model output into a clean data frame
library(marginaleffects)    # avg_slopes() -> computes average marginal effects

# Odds ratios
odds_ratios <- tidy(model2) %>%
  mutate(odds_ratio = exp(estimate))
# tidy() -> extracts coefficients/std.errors/p-values as a tidy table
# mutate() -> adds a new column; exp() -> exponentiates the logit coefficient
#   to turn it into an odds ratio
odds_ratios

# Average marginal effects in probability units
ame <- avg_slopes(model2, type = "response")
# avg_slopes(type = "response") -> average effect of each predictor on the
#   PREDICTED PROBABILITY (not the log-odds), averaged across all companies
ame

# Predicted probabilities for all observations
model_df$predicted_probability <- predict(model2, type = "response")
# predict(type = "response") -> converts the model's log-odds output into a
#   probability between 0 and 1 for every company
summary(model_df$predicted_probability)

# [Q - as asked] Interpret one odds ratio while holding the other included
#   variables constant.
# [Q - in plain words] Pick one ratio's odds ratio and explain, in plain
#   English, what it means for a company's bankruptcy odds, assuming
#   everything else about the company stays the same.
# Your answer:


# [Q - as asked] Interpret one average marginal effect in probability or
#   percentage-point terms.
# [Q - in plain words] Pick one marginal effect and say roughly how many
#   percentage points the bankruptcy probability moves when that ratio goes
#   up by one unit.
# Your answer:


# [Q - as asked] Why is an odds ratio not the same as a probability ratio?
# [Q - in plain words] Why can't you treat "odds ratio of 2" as "twice the
#   probability"?
# Your answer:


# [Q - as asked] Which measure is clearest for a non-technical banking
#   audience?
# [Q - in plain words] If you were explaining this to a bank manager who
#   isn't a statistician, would you use the odds ratio or the marginal
#   effect, and why?
# Your answer:


# ============================================================
# Part F. McFadden's pseudo-R^2
# ============================================================

library(pscl)          # pR2() -> computes pseudo-R^2 measures for glm models
pR2(model2)["McFadden"]
# pR2()["McFadden"] -> pulls out just the McFadden pseudo-R^2 value

# [Q - as asked] Do not interpret pseudo-R^2 as the percentage of variation
#   explained. What does it compare the fitted model with?
# [Q - in plain words] McFadden's number is NOT "percent of variance
#   explained" like ordinary R^2 -- so what baseline model is it actually
#   comparing our model against?
# Your answer:


# [Q - as asked] How does it help describe model fit without proving that
#   the model is correct?
# [Q - in plain words] What can this number tell us about how well the
#   model fits, and what can it NOT prove?
# Your answer:


# ============================================================
# Part G. Confusion matrix and threshold choice
# ============================================================

classification_metrics <- function(actual, probability, threshold) {
  predicted <- ifelse(probability >= threshold, 1, 0)
  # ifelse() -> classifies as bankrupt (1) if predicted probability clears
  #   the chosen threshold, otherwise not bankrupt (0)
  cm <- table(Predicted = predicted, Actual = actual)
  # table() -> cross-tabulates predicted vs actual into a confusion matrix
  TN <- cm["0", "0"]
  FN <- cm["0", "1"]
  FP <- cm["1", "0"]
  TP <- cm["1", "1"]
  c(
    threshold = threshold,
    accuracy  = (TP + TN) / sum(cm),
    precision = TP / (TP + FP),
    recall    = TP / (TP + FN)
  )
}
# function(...) { ... } -> a custom function we define ourselves so we can
#   reuse the same accuracy/precision/recall calculation at different
#   thresholds without retyping it

p_hat <- predict(model2, type = "response")
classification_metrics(model_df$bankrupt, p_hat, 0.50)
classification_metrics(model_df$bankrupt, p_hat, 0.10)
table(Predicted = ifelse(p_hat >= 0.10, 1, 0),
      Actual = model_df$bankrupt)

# [Q - as asked] How does lowering the threshold change precision and recall?
# [Q - in plain words] If we make it "easier" for the model to flag a
#   company as bankrupt (lower cutoff), what happens to how often we're
#   right (precision) versus how many real bankruptcies we catch (recall)?
# Your answer:


# [Q - as asked] Why can accuracy be misleading when bankruptcy is uncommon?
# [Q - in plain words] If only a small fraction of companies actually go
#   bankrupt, why could a model that "always guesses non-bankrupt" still
#   look accurate?
# Your answer:


# [Q - as asked] In a bank-screening context, which is more costly: a false
#   negative or a false positive?
# [Q - in plain words] For a bank, is it worse to miss a company that's
#   actually about to go bankrupt, or to wrongly flag a healthy company as
#   risky?
# Your answer:


# [Q - as asked] Why should the threshold reflect the intended application?
# [Q - in plain words] Why shouldn't we just always use 0.50 as the cutoff,
#   no matter what the model is being used for?
# Your answer:


# ============================================================
# Part H. ROC curve and AUC
# ============================================================

library(pROC)   # roc()/auc() -> tools for building ROC curves and computing AUC
roc_object <- roc(model_df$bankrupt, p_hat, levels = c(0, 1))
# roc() -> computes the true-positive/false-positive rate at every possible
#   threshold, ready to be plotted or summarised
auc(roc_object)
# auc() -> summarises the whole ROC curve into a single "area under curve" number

plot(roc_object,
     main = "ROC curve: Polish-company bankruptcy model",
     col = "black",
     lwd = 2)
# plot() -> draws the ROC curve; lwd sets the line thickness
abline(a = 0, b = 1, lty = 2, col = "grey50")
# abline() -> adds the diagonal reference line representing "random guessing"

# [Q - as asked] What does an AUC of 0.50 represent?
# [Q - in plain words] If the AUC were exactly 0.50, would the model be
#   doing any better than flipping a coin?
# Your answer:


# [Q - as asked] Does the model discriminate better than chance?
# [Q - in plain words] Based on the AUC you got, is this model actually
#   telling bankrupt and non-bankrupt companies apart better than random
#   guessing?
# Your answer:


# [Q - as asked] Why does a high AUC not prove causality or correct
#   probability estimates?
# [Q - in plain words] Even if the AUC looks great, why doesn't that mean
#   the model's predicted probabilities are "correct," or that we've found
#   what causes bankruptcy?
# Your answer:


# ============================================================
# Part I. Communicate the evidence
# ============================================================

# [Q - as asked] Prepare a 180-word briefing for a bank credit-risk or
#   financial-stability team. Include:
#   - the dataset, forecasting horizon and unit of observation;
#   - the bankruptcy rate and one important descriptive pattern;
#   - one adjusted association expressed using an odds ratio or marginal effect;
#   - the McFadden pseudo-R^2, AUC and chosen threshold;
#   - one limitation and one appropriate next analysis;
#   - a clear statement that the results are associations and screening
#     evidence, not causal effects.
#
# [Q - in plain words] Write a short (~180-word) memo for bank staff who
#   are not statisticians. Say what the data is and covers, how common
#   bankruptcy was, one clear pattern you found, one result stated simply
#   (using the odds ratio or marginal effect), how well the model performs
#   (pseudo-R^2, AUC, the cutoff you used), one weak point of the analysis
#   and what you'd check next, and a plain reminder that this shows
#   correlations useful for screening -- not proof of what causes
#   bankruptcy.
#
# Your briefing:



########################################################################
# Data Source
# Tomczak, S. (2016). Polish Companies Bankruptcy [Dataset].
# UCI Machine Learning Repository. https://doi.org/10.24432/C5F600 (CC BY 4.0).
########################################################################
