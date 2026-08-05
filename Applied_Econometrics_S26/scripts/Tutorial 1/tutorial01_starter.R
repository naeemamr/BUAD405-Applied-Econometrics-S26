# ============================================================
# BUAD 405 Applied Econometrics - Summer '26
# Tutorial 1: Understanding Economic Data in R
# Starter script - fill in the blanks marked ___
# ============================================================

# ---- Part B: Import and inspect the dataset -----------------------

# Import the CSV file
development <- read.csv("data/___")

# Inspect the dataset
head(development)
dim(development)
names(development)
str(development)
summary(development)

# Answer in comments below:
# - How many rows and columns are present?
#
# - What does one row represent?
#
# - Which variables are numerical, categorical, and time variables?
#
# - Are any variables stored using an inappropriate class?
#


# ---- Part C: Check data quality -------------------------------------

# Missing values by variable
colSums(is.na(___))

# Duplicate rows
sum(duplicated(___))

# Inspect ranges
range(development$life_expectancy, na.rm = ___)
range(development$___, na.rm = TRUE)
range(development$___, na.rm = TRUE)

# Answer in comments below:
# - Which variable contains the most missing values?
#
# - Could zero be a valid value, or might it represent missing data?
#
# - Do any values appear impossible based on the variable definition?
#
# - Would deleting all incomplete rows change the countries or years represented?
#


# ---- Part D: Describe the sample -------------------------------------

# Select one year for a cross-country view
data_2020 <- subset(development, year == ___)

# Numerical summaries
summary(data_2020$gdp_per_capita_ppp)
summary(data_2020$___)
summary(data_2020$___)

# Counts by region
table(data_2020$___)

# Answer in comments below:
# - Why would it be misleading to calculate a single cross-country summary
#   using all years without first considering the repeated observations?
#


# ---- Part E: Visualise relationships -----------------------------------

# Distribution
hist(data_2020$youth_unemployment,
     main = "___",
     xlab = "Youth unemployment rate (%)")

# Cross-country relationship
plot(___ ~ gdp_per_capita_ppp,
     data = data_2020,
     xlab = "GDP per capita (constant PPP)",
     ylab = "___")

# Compare regions
boxplot(youth_unemployment ~ ___,
        data = data_2020,
        las = 2,
        ylab = "Youth unemployment rate (%)")

# Answer in comments below:
# - What is the broad relationship between income and life expectancy?
#
# - Are there countries that do not follow the broad pattern?
#
# - Does the graph demonstrate that increasing GDP per capita causes longer life?
#
# - Which regional comparison deserves further investigation?
#


# ---- Part F: Examine change over time ------------------------------------

# Replace Egypt with another country if instructed
egypt <- subset(development, country == "___")
plot(egypt$year, egypt$___,
     type = "b",
     xlab = "Year",
     ylab = "Life expectancy at birth")

# Answer in comments below:
# - Describe the direction of change.
#
# - Identify one reason why a visual time trend alone cannot establish
#   what caused that change.
#


# ---- Part G: Trace the data source ----------------------------------------
# Pick ONE indicator from the codebook and fill in below.
#
# Indicator name:
# Original provider:
# Definition:
# Unit:
# Geographic coverage:
# Time coverage:
# Observed, modelled, estimated, or mixed:
# One comparability limitation:


# ---- Part H: Communicate the preliminary evidence -------------------------
# Write a short briefing of no more than 150 words containing:
#   - One important pattern
#   - One difference across countries or regions
#   - One data-quality concern
#   - One statement that the evidence does not support
#   - One question for the next stage of analysis
#
# (write your briefing here as a comment, or in a separate text file)
