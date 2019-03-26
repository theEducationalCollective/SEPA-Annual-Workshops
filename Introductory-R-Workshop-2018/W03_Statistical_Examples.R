# Some Elementary Statistical Examples
#
# Tests shown: t-test (Welch test), ANOVA (one and two way), ad-hoc
# tests, correlation, Fisher's correlation test, simple linear
# regression, general linear regression (multiple predictors).


# Inspecting Data and t-Tests
#
# Ex. A drug company tested three formulations of a pain relief
# medicine for migraine headache sufferers. For the experiment 27
# volunteers were selected and 9 were randomly assigned to one of
# three drug formulations.
#
# The subjects were instructed to take the drug during their next
# migraine headache episode and to report their pain on a scale of 1
# to 10 (10 being most pain). we'll load it into a variable called
# Headache.

Headache = read.csv('HeadacheAov.csv')

# There are a variety of ways to look at data sets:

names(Headache)  # names() gives the names of the variables
str(Headache)    # str()  shows the structure of the data frame

# From the above, you can see it is 27 obs. of 2 variables, Pain and
# Drug.  If you click on the arrow next to Headache in your
# environment, it will display the same information

summary(Headache) # Numerical summary of your data

# It shows 1st and 3rd quartiles, min, max, median, and mean for the
# Pain variable (a number), and the count in each category for the
# Drug variable (a categorical variable).

# Let's visualize our results in a plot. The function plot() is a
# pretty versatile function, and in this case, it can tell that we
# have a numeric variable and a categorical variable. What sort of
# plot will it give us?

plot(Headache$Drug, Headache$Pain)

# In almost all data analysis there is some rearrangement and
# manipultaion involved before an analysis. Here we make a subset of
# this dataset. The code below makes a seperate dataset with 2 of the
# drugs (A & C), so we can perform a t-test later on.
#
# Let's look at our boxplot and pick two drugs that look like they
# might be different from one another. How about A & C?

# R is interactive and most complicated commands can be built up
# step-by-step, inspecting the results of each step and then adding
# the next bit to get what you want.

# This command dumps to the screen all data that satisfy the condition
# "A"

Headache[which(Headache$Drug=='A' ),]
Headache[Headache$Drug=='A',]

# Let's Isolate the A and C drugs, and store each in a variable:

Headache_A <- Headache[which(Headache$Drug=='A' ),]
Headache_C <- Headache[which(Headache$Drug=='C' ),]

# We will bind the datasets, rbind() is short for "row bind", which
# means we are literally stacking rows on top of other rows:

HeadacheSubset <- rbind(Headache_C, Headache_A)

# Take a look at our new dataset with only 2 sprays, so pretty! (All
# the usual commands still work on this subset)

names(HeadacheSubset)
str(HeadacheSubset)
summary(HeadacheSubset)
plot(HeadacheSubset$Drug, HeadacheSubset$Pain)

# Note that R has remembered that there were three levels of the
# variable Drug, even though there are none of the B's in this new
# data set. This is not a problem, but if you are curious, there is a
# command to remove unused factor levels:

hs = droplevels(HeadacheSubset)   # Make R forget about B!
summary(hs)
plot(hs$Drug, hs$Pain)

library(psych)
with(HeadacheSubset, describeBy(Pain, group = Drug))


# t-Test
#
# Most of the basic t-test functionality is in the t.test() function.
# This function accepts inputs in a variety of formats, but let's use
# the formulas.

t.test(Pain ~ Drug, data=HeadacheSubset)

# Now we run a t-test on this dataset with pain as a function of drug.
# Code for the t.test function specifies models as:
#
#         numeric variable ~ grouping variable
#
# and gives the data set name. It looks like the mean for A is
# significantly different from C.


# One-Way ANOVA
#
# If we are going to consider an ANOVA, we should get a handle on the
# means for our groups.

# Display all values of pain, when drug is A

Headache$Pain[Headache$Drug=="A"]

# Now we want to look at the mean of variable "Pain" for category "A"

mean(Headache$Pain[Headache$Drug=="A"])

# The tapply() function allows you to calculate a statistic of your
# choice for a given (numeric) variable, and split that by another
# (grouping) variable. The order they are specified in is:
#
# tapply(numeric variable, grouping variable, function)

Headache_means <- tapply(Headache$Pain, Headache$Drug, mean)
Headache_means

# that is a lot faster than computing it one Drug at a time! It also
# works for other statistics:

tapply(Headache$Pain, Headache$Drug, mean)
tapply(Headache$Pain, Headache$Drug, median)
tapply(Headache$Pain, Headache$Drug, sd)

# Compare these with the output of the describeBy() function from the
# psych library above

# Most analysis in R requires (1) doing something, and then (2) asking
# for specific results. This pattern is very evident with analyses
# like and ANOVA. The aov() function is the standard (normal theory)
# analysis of variance, and we will call our model aov.out.

aov.out <- aov(Pain ~ Drug, data = Headache)

# Here we can look at model results, the summary() function sees
# aov.out as an anova, not a regression, so it displays the anova
# table:

summary(aov.out)

# We have a significant omnibus effect of drug, let's see the nature
# of these differences. This time we ask specifically for the boxplot:

boxplot(Headache$Pain ~ Headache$Drug)

# Boxplot of reported Pain as a function of Drug-- the plot function
# that we wrote above gives the same result.

# As there is a significant F, we are allowed to do a post-hoc test.
# TukeyHSD() does Tukey's "Honestly Significant Difference" test. I
# will store these in an object, because I want to manipulate the
# results:

post_hoc_headache <- TukeyHSD(aov.out)
post_hoc_headache

# There are lots of post-hoc tests in R. Lots.
#
# We can pick parts of the output by name. Also showing off the
# "round" function for setting significant digits:

round(post_hoc_headache$Drug[,"p adj"], digits = 4)

# What will the plot function show us on an linear model?

plot(aov.out)

# The plot function here gives us normality & residual plots. Wait,
# isn't ANOVA different from a linear model?


# Regression Model (1)
#
# Here we construct a regression model with Pain as a function of
# Drug:

lm.out <- lm(Pain ~ Drug, data = Headache)

summary(lm.out)  # Because lm.out is a regression, summary gives us
                 # the coefficients instead of the anova table, but
                 # are the two models really different numerically?

anova(lm.out)    # The anova() function gives an anova table for an
                 # lm() model

# Let's compare the anova tables for the lm() and aov() objects.

anova(aov.out)

# Here is the summary() again for aov.out:

summary(aov.out)

# Look at the last two outputs carefully, what is the difference?
#
# Further research will confirm that the anova is just a type of
# linear model, if that was not covered in your statistics classes.
#
# Review: aov() fits an analysis of variance, lm() fits a linear
# regression model, anova() provides an anova table from any linear
# model, and summary() provides a summary of a linear model which
# either lists the coefficients table or the ANOVA table, whichever is
# most relevant.


# Two-Way ANOVA
#
# This is the same stress data that we used in the previous
# presentation:

stressdata2 <- read.csv("dataset_anova_twoWay_interactions.csv",
                        head = TRUE, sep=",")

# Let's revisit our aov function from the previous analysis. Here is a
# one-way ANOVA based on the treatment variable:

stress_anova_1 <- aov(StressReduction ~ Treatment, stressdata2)
summary(stress_anova_1)

# Here is a two way ANOVA model, with stress reduction as a function
# of treatment and gender:

stress_anova2 <- aov(StressReduction ~ Treatment + Gender,
                     data = stressdata2)

summary(stress_anova2)

# This will give us some boxplots with treatment on the x-axis. What
# do the plots suggest about main effects?

plot(StressReduction ~ Treatment, data = stressdata2)
plot(StressReduction ~ Gender, data = stressdata2)

# What do boxplots say about the effect of gender?
#
# Now let's look at the post-hoc tests:

TukeyHSD(stress_anova2)

# Note that Tukey's HSD is computed for both gender and drug, despite
# the fact that gender was not a significant effect!


# ANOVA with Interaction
#
# In this two way model, we didn't test for any interactions, let's
# see what happens when we include an interaction term. The star
# operator ("*") is a shorthand notation that says "fit a model with
# all of the terms and their interactions"


stress_anova_int <- aov(StressReduction ~ Treatment * Gender,
                        data = stressdata2)

# The "*" operator was not covered previously, but it is shorthand for
# the "full factorial model." This is the notation for the same
# interaction model as above, but written out completely:

stress_anova_int2 <- aov(StressReduction ~ Treatment + Gender + Treatment:Gender,
                         data = stressdata2)

# All of the terms that we estimate in this model are included in the
# "*" term in the previous model:

summary(stress_anova_int)

# Here is the second model just to prove they are the same:

summary(stress_anova_int2)

# Interaction Plots help to show the effects:

interaction.plot(stressdata2$Treatment, stressdata2$Gender,
                 stressdata2$StressReduction, fun = mean,
                 trace.label = 'Gender', xlab="Treatment",
                 ylab="Mean Stress Reduction", lwd=3)

# The stardard format for this function is (1) the x-axis factor (here
# treatment), (2) the variable for which you want lines or "trace"
# variable (here gender), (3) the y-axis numeric variable (the
# response variable; here stress reduction).
#
# As with most functions in R, there are a lot of options, but as long
# as you assign values to the essential options, the remaining
# function options will be set to their defaults. A full list of
# options for this function can be found by typing in
# "interaction.plot" into the "Help" tab in your console, or:

?interaction.plot


## More Regression Examples (and Correlation Test)
#
# We need some packages for these examples:

library(car)
library(visreg)

# The package "car" is named for the book "Companion to Applied
# Regression" by Fox and Weisberg. It supplements the book "Applied
# Regression Analysis and Generalized Linear Models," by Fox. This
# last is a common book for statistics in the social and psychological
# sciences. It includes a large number of useful utility functions for
# regression problems, functions for ANOVAs with type II sums of
# squares, etc.
#
# See:
#
# https://www.r-bloggers.com/anova-%E2%80%93-type-iiiiii-ss-explained/
#
# for more details on sums-of-squares if you are the sort of person
# who feels strongly about the differences among types I, II, III, and
# IV.
#
# The "visreg" library will allow us to create multivariate partial
# regression plots.

# The data for this analysis is taken from the Prestige dataset, an
# included dataset in car package.

data(Prestige)
str(Prestige)

# Prestige variable: Pineo-Porter prestige score for occupation, from
# a social survey conducted in the mid-1960s. Demographic information
# was collected about the professions that were rated for prestige,
# and they include level of income for each job, percentage of women
# in the job, and education required for each job. More information
# about this dataset can be found by typing in prestige into the
# "help" bar.

# Let's look at the first 5 rows of data, head will give us 6 by
# default, but we specify we want 5 rows:

head(Prestige,5)
summary(Prestige)


# Correlations
#
# Start with some correlations. Let's look at the correlation between
# income and education:

cor(Prestige$income, Prestige$education)

# We would expect to find a positive correlation between income and
# education, unless of course, you are a researcher (sigh) :-).
#
# Visualize your data. Variables appear to have a linear relationship

plot(Prestige$education, Prestige$income,  xlab="Education",
     ylab="Income", pch=16)

# The full correlation test, with confidence interval and p-value:

cor.test(Prestige$income, Prestige$education)

# A Multiple Regression problem. Yay, more linear models. Describe
# what relationship we are trying to model:

mod1 <- lm(prestige ~ education + income + women, data=Prestige)
summary(mod1)

# How is this summary different than the summary for the aov function?
# Because we are asking for a summary on an lm() object, R gives us
# the regression coefficients, because that's what we most often want
# in this context.

anova(mod1)

# This last will give you an anova table for the model, this table
# usually appears at the beginning of the regression model results in
# SPSS.

# What happens when we use the plot() function on the model

plot(mod1)

# This gives us the same results as when we use it on an aov() model,
# the diagnostic plots. In this case for a model with continuous
# predictors.

# What if we want to visualize our partial plots? In R we can use a
# package called visreg. It gives us the partial plots of our
# regressors.

visreg(mod1, type=c("conditional"))

# The plots will show up in the "plots" tab in the workspace. You have
# the option to save the image, or copy to the clipboard, a very
# useful function! Place cursor in the console and press enter to see
# the next plot. The line of best fit is included in each plot. As
# with other packages, there are many ways to customize the display.
# You can see the options by typing in "visreg" into the help section.



# ASIDE (Not covered in the workshop)
#
# Look carefully--where are the names of the occupations in the data
# set? What is up with that?

summary(Prestige)
rownames(Prestige) # This gives us a full list of all of the rownames

# In the Prestige data set the names of the occupations are not a
# variable in the data set, they are assigned as row names. This is
# rarely done anymore but used to be a common thing and you do see it
# once in a while.
#
# This is not good practice; things we might want to use should be in
# a variable where we can access them. We cannot easily use the row
# names here.
#
# If we want to, we can fix this:

np <- with(Prestige,
           data.frame(education=education, income=income, women=women,
                      prestige=prestige, census=census, type=type,
                      jobname=rownames(Prestige)))

# Check:

names(np)
names(Prestige)
dim(Prestige)
dim(np)
np$jobname

# EOF
