# Bootstrap Tutorial 1
#
# Just Enough R to Follow Along (boot_just_enough.R)
#
# Matthew D. Turner & Jessica A. Turner
#       Department of Psychology
#       Georgia State University
#
# 2018.02.20

# Basic R Syntax is like a calculator but with lists and statistical
# functions:

2 + 2

x  = 10
y <- 20   # You can use = or <- to set values to variables
x + y

# List of numbers
#
# This uses the c() function which makes lists of things,
# we will use this again later!

x = c(1,2,3,4,5)
x

x = 1:10  # shorthand for "all whole numbers from 1 to 10, inclusive"
x

# Simple functions

mean(x)
median(x)
sd(x)

z = (x - mean(x))/sd(x)
z

t.test(x)

# Libraries add functions to do more things, and often include data
# that can be used for practice or learning new tools. We will use
# the data set "cars" which gives stopping distance versus speed for
# 50 observations.

library(boot)  # Load the tools for bootstrapping
data(cars)     # Load the data set "cars" of speeds and distances

# Data Frames (df) are like mini-spreadsheets inside of R and are the
# most common way to store data for analysis.

cars          # Type name of the df to see it all...
head(cars)    #    ...or head() to see just the top

# We need to specify the variables AND their df's to do things!

cor(cars$speed, cars$dist)             # format: df$variable
cor.test(cars$speed, cars$dist)
plot(cars$speed, cars$dist, pch = 16)  # "pch=16" for solid dots

# Linear models are specified by listing the dependent variable,
# followed by a tilde, followed by the dependent variables separated
# by +, :, or * depending on which interactions you want.
#
#     ***** PDF of Formula Language *****
#
# Here is a simple regression of stopping distance on speed or
# dist ~ speed

dos = lm(dist ~ speed, data = cars)  # data=cars replaces $'s in lm
summary(dos)

# Regression figure:

plot(cars$speed, cars$dist, pch=16, col="red")  # col is color
abline(dos, col="blue", lwd=3)                  # lwd is line width

# Indexing Data Frames (Important!)
#
# Data frames may be indexed in VERY flexible ways:

head(cars)

cars[1,]      # First row of cars (blank after comma)
cars[3,2]     # Third row, second column of cars
cars[1:5,]    # The first five rows of cars (blank after comma)
cars[,2]      # ALL the distances (2nd column; blank BEFORE comma)

cars[c(3,3,3),]   # You have to do this, not in your copies!

# Make a RANDOM sample of INDICES:

set.seed(100)

sample(1:5, 2, replace=TRUE)    # Sample with replacement
sample(1:5, 2, replace=TRUE)    # from the set {1, 2, 3, 4, 5}
sample(1:5, 2, replace=TRUE)    # sample 2 values
sample(1:5, 2, replace=TRUE)

sample(1:5, 2, replace=FALSE)   # Sample without replacement (default)
sample(1:5, 2, replace=FALSE)
sample(1:5, 2)                  # Same as replace=FALSE
sample(1:5, 2)

# How "big" is cars?

dim(cars)     # dim is dimension (rows, columns) of cars

dim(cars)[1]  # rows
dim(cars)[2]  # columns

j = sample(1:50, 10)  # 1:50 is list of numbers from 1 to 50
j

# Then get these rows! (In bootstrapping we do this a LOT! But WITH
# replacement!!) Note the comma with nothing after it below, it is
# important and we use it later on today!

cars[j,]  # note the first column is the values of j;
          # you used those as indices to the data


# Loading data from CSV (comma separated value) files is easy, and
# Excel can export to these. We will use some data from the
# Personality Project (http://personality-project.org/index.html)
# specifically a set of 231 measurements of 13 assessments.
#
# The original data is located at:
# http://personality-project.org/r/datasets/maps.mixx.epi.bfi.data --
# R can read data off of the internet, but for today we copied the
# data to a file and gave it to you:

ppd = read.csv("pp_data.csv")  # If this fails, change directory!
head(ppd)
summary(ppd)

# We will look at bdi (Beck Depression Inventory) as a function of two
# measures of anxiety (state and trait) later today.
#
# For now, let's just look at the bdi

mean(ppd$bdi)
hist(ppd$bdi, probability = TRUE, col="grey", xlab="BDI Score")

# Normal CI for this mean
#
# For more: http://www.cyclismo.org/tutorial/R/confidence.html
#
# Let's pull out the BDI scores to make this easier to type:

bdi = ppd$bdi

# Then get the statistics:

n   = length(bdi)
m   = mean(bdi)
s   = sd(bdi)

# The normal CI for a mean is mean +/- z(alpha/2)*SE where the SE is
# the standard error of the mean. That is just the standard deviation
# of the data, divided by the square root of the sample size:

SE = s/sqrt(n)

# From stats class you may recall that for a 95% CI, the critical z
# values are +/- 1.96. Later we will get this from R's built in
# tables, but for now we just know it.

LB = m - 1.96*SE
UB = m + 1.96*SE

# Print the interval for the mean:
#
# This is not necessary, but we can print the lower and upper bound
# like an interval:

c(LB, UB)

# Functions
#
# In R users can create new functions to wrap up processes as new
# commands. We need to do a little of this to do bootstrapping,
# specifically we have to wrap our statistic inside a function that is
# given to the boot() function.

# Square a number:

2*2
square(2)

# This is not a thing, yet!

square = function(x){
    x*x
    }

square(2)
square(456.33)

456.33*456.33

# For bootstraps we always write a function, and it usually looks like
# this:

usualfunction = function(d,i){
    do_something(d[i])
}

# Where do_something is a "statistic", d is the data set, and i is a
# set of indices (as above)
#
# So:

meanie   = function(d,i){   # compute the mean
    mean(d[i])
}
medianie = function(d,i){   # compute the median
    median(d[i])
}

meanie(cars$dist, 3:10)

mean(cars$dist[3:10])       # for comparison

pearson_r_general = function(d,i){   # this will only work for a
    cor(d$x[i], d$y[i])              # dataset that has columns
}                                    # named x and y !!!

# We set up functions that are SPECIFIC to a given data set when
# bootstrapping. For the cars data above, the two variables are called
# speed and dist:

pearson_r_cars = function(d,i){
    cor(d$speed[i],d$dist[i])     # Note the names here!
}

j = sample(1:50, 50, replace=TRUE)
j                                  # Note the repeats!
pearson_r_cars(cars, j)            # Do it again and it changes

library(boot)
results = boot(cars, pearson_r_cars, 2000)
boot.ci(results)

# EOF