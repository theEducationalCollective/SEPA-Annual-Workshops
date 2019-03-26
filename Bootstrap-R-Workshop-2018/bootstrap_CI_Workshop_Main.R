# Bootstrap Confidence Intervals Workshop
# Main Lecture R Examples for Demonstration
#
# 2018.03.06
# Matthew D. Turner
# Georgia State University
# mturner46@gsu.edu

# Setup
#
# We always need to begin by loading the "boot" library when doing a
# session of bootstrap data analysis. Additionally, throughout these
# files we use the function set.seed() which restarts the random
# number generator. These lines are present to guarantee that the
# analyses are exactly the same here. This is so some of the
# histograms, tables, comparisons, etc. are identical for the
# discussions in the workshop. These lines should not be used in your
# own analyses (at least not in the same way). It **is** a good idea
# to use a randomly selected seed, and to record it, in your own work.
# But that is a more advanced discussion.

library(boot)
set.seed(10001)   # Set the random seed for reproducibility


# SECTION 1 - Examples of Traditional CI Calculations
#
# There are not a lot of built in functions for confidence intervals
# from normal or other standard distributions in R, because we can
# basically just write down the formula as it appears in textbooks.
# But there are intervals embedded in other results and output.


# R's Statistical Tables
#
# The main thing we need to know is how to use R's built-in
# statistical tables. In R, there are tables for quantiles and
# probabilities. All the functions are named similarly: d, q, p, r
#
# R has functions with the same names for all the usual probability
# distributions: normal, t, chi-square, etc.
#
# For an overview of these, see: http://seankross.com/notes/dpqr/

help(Distributions)
?pnorm

# Due to time constraints we will only mention 2 of these, the d and q
# functions.

# dnorm -- The normal (Gaussian) density (Gaussian histogram). See:
# https://www.statmethods.net/advgraphs/probability.html for more
# details of this.

z = seq(from = -4, to = 4, by = 0.1)
plot(z, dnorm(z), type="l", lwd=2)

# qnorm -- Normal quantiles for a given probability
#
# Let's say we want a 95% confidence interval. This is usually written
# a 0.95 = 1 - alpha; so here alpha is equal to 0.05:

alpha = 0.05

# What is the lower bound critical z score for this?

alpha/2

qnorm(alpha/2)

# That magic number of 0.025 happens a lot: if our alpha = 0.05, then
# alpha/2 = 0.025.
#
# What is the upper critical value? 1 - 0.025 = 0.975

1 - alpha/2
qnorm(1 - alpha/2)

# The "p" function is the reverse of the "q" function; "q" gives you a
# *quantile* that corresponds to a probability, while "p" gives you a
# *probability* for a quantile. Remember all those nasty textbook
# problems about probabilities from stats class? pnorm and qnorm
# answer almost all of the ones for the normal distribution!


# The t-distribution Quantile Function: qt()
#
# Let's look at a more complete example: t-scores used for confidence
# interval calculations. The qt() function is similar to qnorm()...

alpha = 0.01    # 0.99 AKA 99% intervals have alpha of 0.01

# What are the critical z values for this?

qt(alpha/2)

# For a t-statistic, we need to set degrees of freedom. That depends
# on the specifics of the problem, but for now let's just use 9 so
# that the function talks to us!

qt(alpha/2, df = 9)

# Upper:

qt(1 - alpha/2, df = 9)

# We can use the c() list function to do this all at once

c(alpha/2, 1 - alpha/2)  # Made a list of the probabilities

ts = qt( c(alpha/2, 1 - alpha/2), df = 9)   # We can do both at once
ts


# FINALLY: An interval! We will use the t this time to show it.
#
# We will use the "lizard tail length" data from:
# https://www.stat.wisc.edu/~yandell/st571/R/append7.pdf

lizard = c(6.2, 6.6, 7.1, 7.4, 7.6, 7.9, 8, 8.3, 8.4,
           8.5, 8.6, 8.8, 8.8, 9.1, 9.2, 9.4, 9.4, 9.7,
           9.9, 10.2, 10.4, 10.8, 11.3, 11.9)

# CI Formula: mean + t-score * (std-dev/square-root(n))
#
# For a 99% interval (alpha 0.01):

alpha = 0.01
n     = length(lizard)
ts    = qt(c(alpha/2, 1 - alpha/2), df = n - 1)
ts

ci99 = mean(lizard) + ts*sd(lizard)/sqrt(length(lizard))
ci99

t.test(lizard, conf.level = 0.99)  # Check! t.test gives the CI

# Is this a good interval for this data set? Check the histogram:

hist(lizard, col="gray")

# How well does the assumed normal distribution fit this data? We will
# add a normal curve, using dnorm, for the estimated mean and standard
# deviation above. This is the normal that the analysis is based on
# given this data.

hist(lizard, col="gray", xlim = c(4, 14), ylim = c(0, 0.30),
     probability = TRUE)
x = seq(from = 4, to = 14, by=0.1)
lines(x, dnorm(x, mean = mean(lizard), sd = sd(lizard)),
      lwd = 2, col = "blue")

# When looking at data, another trick is to use a "density estimator"
# which tries to estimate the shape of the distribution, but without
# making the assumption that the data are normal. Here is the
# empirical density estimator:
#
# lines(density(lizard), lwd=3, col="red")
#
# As you can see, this new line (red) is not completely normal, but
# not that different, either. So the normal is a good approximation
# here. See: https://www.statmethods.net/graphs/density.html for more.
#
# See: http://www.cyclismo.org/tutorial/R/confidence.html for more
# examples of normal intervals and t distribution confidence
# intervals.



# SECTION 2 - Percentile Bootstrap
#
# The following example is from Wright, London, and Field (2011)
# _Using Bootstrap Estimation and the Plug-In Principle for Clinical
# Psychology Data_, Journal of Exp. Psychopathology, 2:2, 252-270. A
# good starting paper for psychology researchers.
#
# The data below are the numbers of alternate personalities among
# people diagnosed with multiple personality disorder (now DID) from
# Goff and Simms (1993; see references in Wright, et al.). This is a
# 10 subject sample from Goff and Simms full set of 54 cases.

set.seed(5050)  # For reproducibility

numPer <- c(1,1,2,2,4,5,7,15,30,56)

# The first law of data analysis: look at the data!!!

hist(numPer, prob=TRUE, col="gray")

qqnorm(numPer, pch=16, col="blue")
qqline(numPer, col="red", lwd=3)

# https://www.statmethods.net/advgraphs/probability.html gives some
# quick introduction to QQ (Quantile-Quantile) plots, and specifically
# the "normal probability plot."
#
# Normal theory confidence interval analysis:

m = mean(numPer)
s = sd(numPer)
n = length(numPer)

ci95 = m + qt(c(0.025, 0.975), df = n-1)*(s/sqrt(n))
ci95

# Which of the following is closer to the bulk of the data?

hist(numPer, col="gray")
mean(numPer)
median(numPer)

# So maybe we would prefer the median to the mean if we are talking
# about a measure nearer to the center of the bulk of the data and not
# so influenced by the one huge outlier.

# What if we want to get a CI for the median? Use the bootstrap to get
# the interval for the median.
#
# Need a bootstrap functions:

#      usualfunction = function(d,i){
#        do_something(d[i])
#      }

bootmedian = function(d,i){
  median(d[i])
}

# Here is the function that does most of the work!
#
# The boot() function takes (at least) 3 arguments in this order:
#
# boot(data set, function to bootstrap, number of boot samples)

results = boot(numPer, bootmedian, 2000)

# What comes out? (t is our statistic)

str(results)
hist(results$t, col="gray")
summary(results$t)

# Get the 95% CI by obtaining the quantiles:

?quantile

quantile(results$t, c(0.025, 0.975))

# The usual function for getting the Bootstrap CIs from the output of
# boot()

boot.ci(results)

# What happens if we repeat things?
#

newResults = boot(numPer, bootmedian, 2000)
hist(newResults$t, col="gray")
quantile(newResults$t, c(0.025, 0.975))

newResults = boot(numPer, bootmedian, 2000)
hist(newResults$t, col="gray")
quantile(newResults$t, c(0.025, 0.975))

# Uh-oh! If we use random samples, we get different results

newResults = boot(numPer, bootmedian, 50000)  # Bigger B!
hist(newResults$t, col="gray")
quantile(newResults$t, c(0.025, 0.975))

# Using a much bigger B (number of bootstrap samples) stabilizes the
# behavior of the results
#
# Note what we have done here, we have built a 95% confidence interval
# for a median which does not have a clearly defined CI. There **are**
# intervals for medians, but they usually do not allow us to set
# arbitrary confidence levels, as we have done here. To get other
# intervals:

boot.ci(results, conf = 0.90)
boot.ci(results, conf = c(0.90, 0.95, 0.99))

# EOF