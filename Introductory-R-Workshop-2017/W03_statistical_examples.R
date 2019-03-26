# Some Elementary Statistical Examples
#
# Tests shown: t-test (Welch test), ANOVA (one and two way), ad-hoc tests,
# correlation, Fisher's correlation test, simple linear regression, general
# linear regression (multiple predictors).

# Inspecting Data and t-Tests
#
# Our dataset is built in to R, and it is called insect sprays. The data
# function loads the data for further work.

data(InsectSprays)

# There are a variety of ways to look at data sets:

names(InsectSprays)  # names() gives the names of the variables
str(InsectSprays)    # str()  shows the structure of the data frame

# What is it? Looks like it is 72 obs. of 2 variables, count and spray. "Count"
# is the number of insects on a plant, and "spray" is the type of spray, of
# which there are 6 types. If you click on the arrow next to insect sprays in
# your environment, it will display the same information

summary(InsectSprays) # Numerical summary of your data

# It shows quartiles, min, max and mean for the count variable (a number), and
# the number in each catergory for the spray variable (a categorical variable).

# Let's visualize our results in a nice plot. The function plot() is a pretty
# versatile function, and in this case, it can tell that we have a numeric variable
# and a categorical variable. What sort of plot will it give us?

plot(InsectSprays$spray, InsectSprays$count)

# In almost all data analysis there is some rearrangement and manipultaion
# involved before an analysis. Here we make a subset of this dataset. The code
# below makes a seperate dataset with 2 sprays (A & C), so we can perform a
# t-test later on.
#
# Let's look at our boxplot and pick two sprays that look like they might be
# different from one another. How about A & C?

# R is interactive and most complicated commands can be built up step-by-step,
# inspecting the results of each step and then adding the next bit to get what
# you want.

# This command dumps to the screen all sprays that satisfy the condition "A"
InsectSprays[ which(InsectSprays$spray=='A' ),]

# Let's Isolate the A spray, and store it in a variable
InsectSprays_A <- InsectSprays[ which(InsectSprays$spray=='A' ),]

#Do the same this for C (Isolate the C spray)
InsectSprays_C <- InsectSprays[ which(InsectSprays$spray=='C' ),]

# We will bind the datasets, rbind() is short for "row bind", which means we are
# literally stacking rows on top of other rows
InsectSprays_t <- rbind(InsectSprays_C, InsectSprays_A)

# Take a look at our new dataset with only 2 sprays, so pretty! (All the usual
# commands still work on this subset)

names(InsectSprays_t)
str(InsectSprays_t)
InsectSprays_t

# t-Test
#
# Most of the basic t-test functionality is in the t.test() function. This
# function accepts inputs in a variety of formats, but let's use the formulas.

t.test(count ~ spray, data=InsectSprays_t)

# Now we run a t-test on this dataset with count as a function of spray. Code
# for the t.test function specifies the numeric variable ~ grouping variable and
# gives the data set name. It looks like the mean for A is significantly
# different from C.

# One-Way ANOVA
#
# If we are going to consider an ANOVA, we should get a handle on the means for
# our groups.

# Display all values of count, when spray is A
InsectSprays$count[InsectSprays$spray=="A"]

# Compare this last line with example above, and see if it give you an idea of a
# simpler way to get the results above. :-)
#
# Now we want to look at the mean of variable "count" for category "A"
mean(InsectSprays$count[InsectSprays$spray=="A"])

# The tapply() function allows you to calculate a statistic of your choice for a
# given (numeric) variable, and split that by another (grouping) variable. The
# order they are specified in is:
#
# tapply(Numeric variable, grouping variable, function)
Insect_means <- tapply(InsectSprays$count, InsectSprays$spray, mean)
Insect_means

# Most analysis in R requires (1) doing something, then (2) asking for specific
# results. This pattern is very evident with analyses like and ANOVA. The aov()
# function is short for analysis of variance, with assumptions of normality, and
# we call our model aov.out.

aov.out <- aov(count ~ spray, data=InsectSprays)

# Here we can look at model results, the summary() function sees aov.out as an
# anova, not a regression, so it displays the anova table.
summary(aov.out)

# We have a significant omnibus effect of spray, let's see the nature of these
# differences. This time we ask specifically for the boxplot.
boxplot(InsectSprays$count ~ InsectSprays$spray)

# Boxplot of count as a function of spray, the plot function that we wrote above
# gives the same result.

# As there is a significant F, we want to do a post-hoc test. TukeyHSD() does
# Tukey's "Honestly Significant Difference" test. I am storing these in an
# object, because I want to manipulate the output.
post_hoc_insect <- TukeyHSD(aov.out)
post_hoc_insect

# There are lots of post-hoc tests in R. Lots.
#
# Suppose I don't like the way this output looks, I only want to see if there is
# a significant pairwise difference, and I don't care about the nature of the
# difference, I just want the p-value. Bad statistical practice, I know, but
# let's pretend!  We can use the code below to display only the 4th column (the
# p values) of the Tukey HSD $spray output.
post_hoc_insect$spray[,4]

# What will the plot function show us on an linear model?
plot(aov.out)

# The plot function here gives us normality & residual plots. Wait, isn't ANOVA
# different from a linear model? We shall see...
#
# Here we construct a regression model with count as a function of spray:
lm.out <- lm(count ~ spray, data=InsectSprays)

summary(lm.out)  # Because aov2.out is a regression, summary gives us
                 # the coefficients instead of the anova table, but are the
                 # two models really different numerically?

anova(lm.out)    # The anova() function gives an anova table for an lm()
                 # model

# Let's compare the anova tables for the lm() and aov() objects.
anova(aov.out)

# Here is the summary() again for aov.out:
summary(aov.out)

# Look at the last two outputs carefully, what is the difference?
#
# Further research will confirm that the anova is just a type of linear model,
# if that was not covered in your statistics classes.

# This option will not work, as the anova() function produces a table for a
# linear model
anova(count ~ spray, data=InsectSprays)

# Review: aov() fits an analysis of variance, lm() fits a linear regression
# model, anova() provides an anova table from any linear model, and summary()
# provides a summary of a linear model which either lists the coefficients table
# or the ANOVA table, whichever is most relevant.

## Two-Way ANOVA
#
# This is the same stress data as we had in the previous presentation.
stressdata2 <- read.csv(file="dataset_anova_twoWay_interactions.csv",head=TRUE,sep=",")

# Let's revisit our aov function from the previous analysis. Here is a one-way
# ANOVA based on the treatment variable:
stress_anova_1 <- aov(StressReduction ~ Treatment, stressdata2)
summary(stress_anova_1)

# Here is a two way ANOVA model, with stress reduction as a function of
# treatment and gender:
stress_anova2 <- aov(StressReduction ~ Treatment + Gender, stressdata2)
summary(stress_anova2)

# This will give us some boxplots with treatment on the x-axis. What do the
# plots suggest about main effects?
plot(StressReduction ~ Treatment, data =stressdata2)
plot(StressReduction ~ Gender, data = stressdata2)

# What do boxplots say about the effect of gender?
#
# Now let's look at the post-hoc tests:
TukeyHSD(stress_anova2)

# In this two way model, we didn't test for any interactions, let's see what
# happens when we include an interaction term. The star operator ("*") is a
# shorthand notation that says "fit a model with all of the terms and their
# interactions"
stress_anova_int <- aov(StressReduction ~ Treatment * Gender, stressdata2)

# Note: the "*" is not covered previously, but it is the shorthand for the "full
# factorial model" This is the notation for the same interaction model as above,
# but written out completely:
stress_anova_int2 <- aov(StressReduction ~ Treatment + Gender + Treatment:Gender, stressdata2)

# All of the terms that we estimate in this model are included in the "*" term
# in the previous model.
summary(stress_anova_int)

# Here is the second model just to prove they are the same:
summary(stress_anova_int2)

# Interaction Plots help to show the effects:
interaction.plot(stressdata2$Treatment, stressdata2$Gender, stressdata2$StressReduction, fun = mean, trace.label = 'Gender', xlab="Treatment", ylab="Mean Stress Reduction")

# The stardard format for this function is (1) the x-axis factor, (2) the
# variable for which you want seperate lines or "trace" variable, (3) the
# y-axis numeric variable.
#
# As with most functions in R, there are a lot of options, but as long as you
# assign values to the essential options, function options will be set to the
# defaults. A full list of options for this function can be found by typing in
# "interaction.plot" into the "Help" tab in your console.

## Regression Examples
#
# We need some packages for these examples:
library(car)
library(visreg)

# The package "car" is named for the book "Companion to Applied Regression" by
# John Fox and Harvey Sanford Weisberg. It also supplements the book "Applied
# Regression Analysis and Generalized Linear Models" by Fox. This last is a
# common book for statistics in the social and psychological sciences. It
# includes a large number of useful utility functions for regression problems,
# functions for ANOVA's with type II sums of squares, etc. See:
# https://www.r-bloggers.com/anova-%E2%80%93-type-iiiiii-ss-explained/) for more
# details on sums-of-squares if you are the sort of person who feels strongly
# about the differences among types I, II, and III.
#
# This "visreg" library will allow us to create multivariate partial plots.

# The data for this analysis is taken from the Prestige dataset, an included
# dataset in car package.
data(Prestige)
str(Prestige)

# Prestige variable: Pineo-Porter prestige score for occupation, from a social
# survey conducted in the mid-1960s. Demographic information was collected about
# the professions that were rated for prestige, and they include level of income
# for each job, percentage of women in the job, and education required for each
# job. More information about this dataset can be found by typing in prestige
# into the "help" bar.

# Let's look at the first 5 rows of data, head will give us 6 by default, but we
# specify we want 5 rows:
head(Prestige,5)
summary(Prestige)

# Looking at the summary, can you determine which variables are numeric and
# categorical?
#
# Look carefully--where are the names of the occupations in the data set? What
# is up with that?

rownames(Prestige) # This gives us a full list of all of the rownames

# ASIDE
#
# In this data set the names of the occupations are not a variable in the data
# set, they are assigned as row names. This is actualy not good practice; things
# we might want to use should be in a variable where we can access them.
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

# Back to the problem
#
# Start with some correlations. Let's look at the correlation between income and
# education:
cor(Prestige$income, Prestige$education)

# We would expect to find a positive correlation between income and education,
# unless of course, you are a researcher (sigh) :-).
#
# Visualize your data. Variables appear to have a linear relationship
plot(Prestige$education, Prestige$income,  xlab="Education ", ylab="Income")

# The full correlation test, with confidence interval and p-value:
cor.test(Prestige$income, Prestige$education)

# A Multiple Regression problem. Yay, more linear models. Describe what
# relationship we are trying to model:
mod1 <- lm(prestige ~ education + income + women, data=Prestige)
summary(mod1)

# How is this summary different than the summary for the aov function? Because
# we are asking for a summary on an lm() object, R gives us the regression
# coefficients, because that's what we most often want in this context.
anova(mod1)

# This last will give you an anova table for the model, this table usually
# appears at the beginning of the regression model results in SPSS.

# What happens when we use the plot() function on the model?
plot(mod1)

# This gives us the same results as when we use it on an aov() model, the
# diagnostic plots. In this case for a model with continuous predictors.

# What if we want to visualize our partial plots? In R we can use a package
# called visreg. It gives us the partial plots of our regressors.
visreg(mod1, type=c("conditional"))

# The plots will show up in the "plots" tab in the workspace. You have the
# option to save the image, or copy to the clipboard, a very useful function!
# Place cursor in the console and press enter to see the next plot. The line of
# best fit is included in each plot. As with other packages, there are many ways
# to customize the display. You can see the options by typing in "visreg" into
# the help section.


# Final Example
#
# This is an example of a very fancy 3-D plot. This will *not* work with the
# elementary setup for the workshop. However, once you are back online and have
# the internet, you can easily install the missing packages and run this.

library(rgl)
library(scatterplot3d)

# Modify the data with centering
newdata <- Prestige[,c(1:4)]
education.c <- scale(newdata$education, center=TRUE, scale=FALSE)
prestige.c <- scale(newdata$prestige, center=TRUE, scale=FALSE)
women.c <- scale(newdata$women, center=TRUE, scale=FALSE)

# Bind these new variables into newdata
new.c.vars <- cbind(education.c, prestige.c, women.c)
newdata <- cbind(newdata, new.c.vars)

# Add names for the new variables and get a summary
names(newdata)[5:7] = c("education.c", "prestige.c", "women.c" )
summary(newdata)

# "Live" movable 3-D scatterplot
newdat <- expand.grid(prestige.c=seq(-35,45,by=5),women.c=seq(-25,70,by=5))
newdat$pp <- predict(mod2,newdata=newdat)
with(newdata,plot3d(prestige.c,women.c,income, col="blue", size=1, type="s", main="3D Linear Model Fit"))

# "Static" 3-D plot (not movable)
scatterplot3d(Prestige$education, Prestige$prestige, Prestige$women, color=par("col"))
