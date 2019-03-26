# Additional Bootstrap BCa Examples
#
# The main topics of this workshop are (1) the ideas underlying
# bootstrapping and (2) the use of the BCa (bias corrected and
# accelerated bootstrap) in elementary situations. This file contains
# examples of the BCa bootstrap in use.
#
# 2018.03.04
# Matthew D. Turner
# mturner46@gsu.edu

# Setup

library(boot)
set.seed(1)          # For exact reproducibility of examples



## Correlations
#
# Example: the CD4 data set -- CD4 cell counts at baseline and one
# year later for HIV patients on treatment. Expectation was that
# treatment would lead to **increased CD4 counts at one year**, not
# usually seen in HIV patients.

data(cd4)
head(cd4)

plot(cd4$baseline, cd4$oneyear, pch = 16)

# Are the patients improving? If they are, they should have higher CD4
# levels at one year relative to baseline. How do we visualize this?

plot(cd4$baseline, cd4$oneyear, ylim=c(0,7), xlim=c(0,7), pch = 16)
abline(a = 0, b = 1, lwd = 3, col = "red")  # 45 degree line

# Analysis of the correlation from normal theory models:

cor(cd4$baseline, cd4$oneyear)
cor.test(cd4$baseline, cd4$oneyear)

# Writring a function for boot. We always need a "wrapper function"
# for calling the boot procedure. This is tedious, but it allows us to
# use **anything** as our statistic of interest. If this was done for
# us, we would only be able to use that the designers gave us, or we
# would have to constantly rename our data. So this is a good, if
# tedious, comprimise.

# The model function is:
# usualfunction = function(d,i){
#     do_something(d[i])
# }
#

bootcorf = function(cd4,i){               # Because this function is
  cor(cd4$baseline[i], cd4$oneyear[i])    # only used for cd4, we can
}                                         # make "d" into "cd4"

# Important note for correlations and other data with multiple
# variables: we keep the rows of the matrix together. That is, we
# sample rows, and always use the corresponding baseline and oneyear
# numbers. If we broke that connection, the results would be
# meaningless.

b = boot(cd4, bootcorf, 2000)
boot.ci(b)

cor.test(cd4$baseline, cd4$oneyear)  # For comparison of CIs

# Note that the bootstrap CI is narrower than the normal CI in this
# case. Not something that is guaranteed.

hist(b$t, col = "gray")   # Skew!

# When working with skewed distributions, the general advice is to
# prefer the BCa interval to the percentile. Also note that the
# assumptions of the normal-theory are not met here, so that interval
# is not a good fit for this problem.

# You do not have to get all of the intervals:

boot.ci(b, type = "bca")



# R-squared CI
#
# We will use the "Personality Project" data for some regression
# examples.
#
# For more information, see the website:
#
# http://personality-project.org/r/r.guide.html
#
# Here we will look at BDI (Beck Depression Inventory) versus measures
# of trait and state anxiety

pp <- read.csv("pp_data.csv")
bts <- pp[,c("bdi", "traitanx", "stateanx")]  # Subset the data
summary(bts)
plot(bts)

# Let's model BDI as a function of the other measures

bts.mod <- lm(bdi ~ stateanx + traitanx, data = bts)
summary(bts.mod)

summary(bts.mod)$r.square   # Picks out the R-square from the summary

# Regression model function for boot. When doing bootstrapping on
# cases you have to put the indices (i) for the ROWS; that is, use the
# **comma** as below to pick out entire rows of the data frame!

rsq <- function(d,i){
  bootsample <- d[i,]
  fit <- lm(bdi ~ stateanx + traitanx, data = bootsample)
  summary(fit)$r.square
}

results <- boot(bts, rsq, 1000)

boot.ci(results)

hist(results$t, col="cyan")   # Note the r-square sampling
                              # distribution should not be strictly
                              # normal but is not too terrible here.

# ASIDE:
#
# Note about functions for the boot procedure -- the LAST line of the
# function should evaluate to a SINGLE value, and that is the value
# that will be bootstrapped. There is an optional return statement
# that can be used, but is usually unnecessary:
#
# rsq <- function(d,i){
#   bootsample <- d[i,]
#   fit <- lm(bdi ~ stateanx + traitanx, data = bootsample)
#   return(summary(fit)$r.square)
# }
#
# You will see this in some code, and if you look at the supplemental
# code for bootstrap_t_example.R included in this workshop, it is
# sometimes used to wrap **multiple** return values.



# Regeression Coefficients
#
# Continuing the above example we will get the bootstrapped BCa CIs
# for the estimated regression coefficients (betas) of the model

summary(bts)
summary(bts.mod)
coef(bts.mod)
confint(bts.mod)   # Normal theory CIs

# By now the pattern should be sinking in: (1) build a function for
# the statistic of interest, (2) send it to boot(), then (3) use
# conf.int() to get the results.

betas = function(bts,i){
  bootsample = bts[i,]   # Comma!
  fit = lm(bdi ~ stateanx + traitanx, data = bootsample)
  coef(fit)
}

results = boot(bts, betas, 1000)
boot.ci(results)

# Wait! Where are they all?

boot.ci(results, type="bca", index = 1)
boot.ci(results, type="bca", index = 2)
boot.ci(results, type="bca", index = 3)

# ASIDE:
#
# Trick for printing the results all at once, if you are new to
# for loops, you can look at:
#
# https://datascienceplus.com/how-to-write-the-loop-in-r/
#
# This idea comes from: https://stackoverflow.com/questions/18490713

# This prints the BCa interval as a single row:

boot.ci(results, type="bca", index = 1)$bca

# We can pick out the lower and upper bounds by using indices for the
# columns:

boot.ci(results, type="bca", index = 1)$bca[,4]  # lower, upper is 5

for(i in 1:3){
  lwr = boot.ci(results, type="bca", index = i)$bca[,4]
  upr = boot.ci(results, type="bca", index = i)$bca[,5]
  vnm = variable.names(bts.mod)[i]
  cat(sprintf('%s \t %8.4f \t %8.4f\n', vnm, lwr, upr))
}

# Here are the normal CIs agin:

confint(bts.mod)

# Here the bootstrap and normal CIs are close as this problem is
# amenable to either analysis.



# Trimmed Mean
#
# The trimmed mean is a robust version of the mean where the most
# extreme values are dropped from the calculation. It is good for
# "contaminated normals" -- problems where you have a mostly normal
# distribution but have some outlying points mixed in as well.
#
# A reaction time example
#
# For a given task, people average 800 milliseconds (ms) but on
# occassion they completely miss the target and do not respond for
# more than second and a half (say, 1600 ms) on average. Most of the time
# they are attending, but once in a while they lose interest, drift
# off, and miss. Let's say they drift off 10% of the time.
#
# To understand this problem (perhaps before we spend money and
# collect the data) we can simulate some data.

set.seed(111000)     # For exact reproducibility of examples

N = 50        # Total number of trials for a subject
p = 0.10      # Proportion of times they "miss"

Nc = ceiling(p*N) # The misses; ceil() makes this work for other N, p's
NN = N - Nc       # The attended trials
Nc
NN

DN = rnorm(NN,  mean = 800, sd = 100)  # Means and SDs for the 2 dists
Dc = rnorm(Nc, mean = 1600, sd = 200)

# After making the two bins of misses (contaminated) and attended
# (normal) trials we put the data together into one set. Here they are
# sorted to see what is going on, but that is not necessary and does
# not affect the results.

allData = sort(c(DN, Dc))
allData
hist(allData)

# Here is the mean and a couple of trimmed means:

mean(allData)
mean(allData, trim = 0.10)  # Trim 10% from each end
mean(allData, trim = 0.05)  # Trim  5% from each end

# Maybe we want to make a confidence interval for this case, we may
# try to do it with a normal distribution, but this construction is
# wrong! This interval requires that the data all come from one
# distribution, and that the distribution be normal. Given the usual
# robustness argument, people might do this, but it is not really
# valid!

m = mean(allData)
s = sd(allData)

nCI = m + qt(c(0.025, 0.975), df = N - 1)*(s/N)
nCI

# We can make a picture of the normal distribution we are assuming
# here, and you can decide if the histogram matches it.

hist(allData, col="gray", probability = TRUE)
x = 400:1800
lines(x, dnorm(x, mean=m, sd=s), col="blue", lwd=3)

# New trick in this function: you can pass **extra** information
# through the boot() function into the custom function we write to
# analyze our data. Here the variable named "proportion" contains the
# percentage to be trimmed from the mean. Note that when you do this
# you **have** to use the named parameter style where you write
# "proportion = __" in the boot() function parentheses. And this name
# must match the name given to the extra parameter in the custom
# function.

btm = function(d, i, proportion){
    mean(d[i], trim = proportion)
}

results = boot(allData, btm, 2000, proportion = 0.10) # extra info!
boot.ci(results, type = "bca")
nCI

# Try a bootstrapped median for that example for comparison.



# Ratio of Values
#
# Here we constuct a CI for ratios of city populations. The data is
# included in R as example data. R has a lot of built-in data to let
# you try new things.
#
# u is the 1920 population; x is the 1930 population; so x/u is an
# estimate of population growth for the city. We would like to know
# what the average value of this ratio is for these data.

data(bigcity)
summary(bigcity)

# Compute the ratio for each city:

bigcity$r = bigcity$x / bigcity$u
summary(bigcity)
sort(bigcity$r)

# So the individual rates range from < 1 to 25! Probably not very
# normal! Clearly that large 25 is affecting any average.

bootratio = function(d,i){
  mean(d[i,]$r)
}

results1 = boot(bigcity, bootratio, 1000)
hist(results1$t, col = "gray")
boot.ci(results1)

# What we have done here is look at the average growth rate for big
# cities. This shows how cities are growing. Since cities vary a lot,
# this interval is quite big and the data is a mess (look at the
# histogram!)
#
# Since these are rates, we perhaps should use the geometric mean.
# This mean is the **product** of each of n values, followed by taking
# the n-th root.

georatio = function(d,i){
  psych::geometric.mean(d[i,]$r)   # We use a built in geometric mean
}

results2 = boot(bigcity, georatio, 1000)
hist(results2$t, col = "gray")
boot.ci(results2)

# Effectively we have "normalized" our data here, and so the sampling
# distribution (here approximated by the bootstrap distribution) is
# more normal. It is still long tailed, but the "gappy" appearance is
# gone. This geometric mean reduces the impact of the single large
# rate.

# Note: to somewhat normalize this data and do a (comparable?) t-test
# of a geometric mean we use the log of the ratios.

x = t.test(log(bigcity$r))
x

# But the CI is in the wrong scale -- it was log transformed. It
# should be transformation respecting so we can undo the log at the
# limits of the interval to recover the original scale.

exp(x$conf.int)

# What if we wanted to look at the nation's overall growth rate? For
# this, we might sum the two columns and get a single estimate for the
# ratio.

bigratio = function(d,i){
  sum(d[i,]$x)/sum(d[i,]$u)
}

results3 = boot(bigcity, bigratio, 1000)
hist(results3$t, col="gray")
boot.ci(results3)

# As we might expect, by aggregating across cities, we get a more
# stable estimate of growth rate, but for the nation as a whole. It is
# important to point out, however, that since this data is for big
# cities, it is not a great estimator for the overall US growth rate
# as it neglects the other sorts of towns and cities there.

# EOF
