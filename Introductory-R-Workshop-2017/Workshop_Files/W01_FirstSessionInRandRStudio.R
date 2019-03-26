# First Session in R and RStudio
#
# Matthew Turner
# 2017.02.26

# In R script or program files, the hashtag/octothorpe/pound sign
# character marks a comment that is for humand and ignored by the
# R language.

## R as a Calculator
#

# Basic math - Use R like a calculator! +, -, *, /
2+2
100-99
4*3
88/11

# Comparisons: >, <, <=, >=, ==, !=
2  <  10
14 >= 14
14 >  14
3  == 3
10 != 10
10 != 20

# The function c() concatenates things into a list:
x = c(1,2,3,4,5)

print(x)
x

mean(x)
median(x)
sd(x)
var(x)

sd(x) == sqrt(var(x))

# Because r does math so well, it sometimes does not have very simple functions
# in it. For instance, it lacks a z-score function. This is easily written:

z = (x - mean(x))/sd(x)
z

## Assignment Operator (<- versus =)
#

# Important! '<-' versus '=' in the following do the same thing:
y = c(1,2,3,4,5)
x <- c(5,4,3,2,1)
s <- y + x

# Show the values:
x
y
s

# You can also do this (but shouldn't!)

y + x -> z
z
y + x = z       # This will FAIL!

# Statistical Tables
#
# R provides all of the usual statistical tables and can compute any table that
# can be defined mthematically. Here we show just two.

# Look up some normal/Gaussian values
#
# The functions for normals are pnorm (for probabilities) and qnorm (for z
# scores). Like most tables, pnorm gives the probability to the RIGHT (or the
# lower-tail probability). These first few you should know from the 68-95-99.7
# percent rule from stats class:
pnorm(0)
pnorm(1) - pnorm(-1)
pnorm(3) - pnorm(-3)

# What z score corresponds to 84% (= 50% + 34%) probability?
qnorm(0.84)

# R can work directly with normals that are not z's: for IQ scores (mean 100, sd
# 15) what proportion of people have IQs greater than 130?

1 - pnorm(130, mean=100, sd=15)  # The "1 minus" trick is from textbooks!
pnorm(130, mean=100, sd=15, lower.tail = FALSE)  # Get UPPER tail probability

# t-distribution: similar to z but with degrees of freedom specified

pt(2, df=2)  # Centeral t with 2 df
qt(0.908, df=2)

## Installing and Attaching Libraries
#

# install.packages("e1071")    # Cannot run w/o internet

# Once installed, packages are loaded with the library() command.
# This example uses the package MASS, included with R:

library(MASS)

## Data and Data Sets
#

# R has many built-in data sets, usually from textbooks

data(mammals)

head(mammals)
tail(mammals)
summary(mammals)
head(mammals,3)

## Data Frames
#

str(mammals)

# We access parts of data frames by using '$'

mean(mammals$body)
sd(mammals$body)

# Or we can use with()

with(mammals, mean(body))
with(mammals, sd(body))

# Or we can attach the frame:

attach(mammals)
mean(body)
sd(body)

# Attaching is dangerous as attached data might be selected
# by R over the data you intended if you are working with
# data frames that share variable names. If you MUST use
# attach(), always detach() when done!

detach(mammals)

## Transformations
#
# R let's you transform data as needed:

attach(mammals)

plot(body,      brain,      pch=20, col="blue")
plot(log(body), brain,      pch=20, col="blue")
plot(log(body), log(brain), pch=20, col="blue")

detach(mammals)

## Exploring Data
#
# The main examples here are for the "Old Faithful" geyser

data(faithful)     # The data is built-in
str(faithful)
summary(faithful)

hist(faithful$eruptions, col="gray") # Length of eruption of old faithful
hist(faithful$waiting)               # Waiting time between eruptions

with(faithful, plot(waiting, eruptions, pch=20, col="blue"))

plot(faithful$waiting, faithful$eruptions, pch=20, col="magenta")

# What is the correlation?

with(faithful, cor(waiting, eruptions))

with(faithful, cor.test(waiting, eruptions))

## R Model Language
#

# For these examples focus on the use of the model language
# later in the workshop, you will get to see more examples
# of full data analyses using these techniques.

# Examples with Old Faithful

faith.mod <- lm(eruptions ~ waiting, data=faithful)

faith.mod

summary(faith.mod)

anova(faith.mod)

# Check normality of model:

qqnorm(rstandard(faith.mod), pch=20)
qqline(rstandard(faith.mod), col="pink", lwd=2)

# Nicer plot -- we can add titles, labels, and so on:

qqnorm(rstandard(faith.mod), pch=20, ylab="Standardized Residuals",
       xlab="Normal scores", main="Normality of Old Faithful Model")
qqline(rstandard(faith.mod), col="deepskyblue", lwd=2)

# Regression figure:

with(faithful, plot(waiting, eruptions, pch=20, col="blue"))
abline(faith.mod, col="red", lwd=3)
