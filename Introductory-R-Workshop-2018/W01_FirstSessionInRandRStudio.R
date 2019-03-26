# First Session in R and RStudio
#
# Matthew Turner
# 2018.01.18 (Revision 2)

# In R scripts or program files, the hashtag/octothorpe/pound sign
# character marks a comment that is for humans and ignored by the R
# language. Use comments to tell your future self why you made this
# mess.

##### Walk through RStudio Environment!

## R as a Calculator
#

# Basic math - Use R like a calculator! +, -, *, /

2+2
100-99
4*3
88/11
90/12

# Comparisons: >, <, <=, >=, ==, !=

2  <  10
14 >= 14
14 >  14
3  == 3     # Notice the DOUBLE equals!
10 != 10
10 != 20

# The function c() concatenates things into a list. In working with R,
# you will do this a lot!

x = c(1,2,3,4,5)

print(x)  # For use in programs
x         # This "prints" R when used interactively

mean(x)
median(x)
sd(x)
var(x)

sd(x) == sqrt(var(x))

# Because r does basic math so well, it sometimes does not have very
# simple functions built into it. For instance, it lacks a z-score
# function. This is easily computed:

z = (x - mean(x))/sd(x)
z


# Assignment Operator (<- versus =)
#
# In math, the equals sign can mean various things: (1) two
# expressions are equal at a specific value, (2) two expressions are
# identical, (3) two expressions should be set to the same value. This
# last usage is called "assignment." In R, there are two assignment
# operators due to its evolutionary history.

# Important! '<-' versus '=' in the following do the same thing:

x <- c(5,4,3,2,1)
y = c(1,2,3,4,5)
s <- y + x

# Show the values:

x
y
s

# You can also do this (but shouldn't!)

y + x -> z
z

# It is considered good practice to always place the variable to be
# set on the left and the value to set it to on the right.

y + x = z       # This will FAIL!


## Statistical Tables
#
# R provides all of the usual statistical tables and can compute any
# table that can be defined mathematically. Here we show just two.

# Look up some **normal/Gaussian** values
#
# The functions for normals are:
#   (1) pnorm (for probabilities) and
#   (2) qnorm (for z scores).
#
# Like most tables, pnorm gives the probability to the LEFT (or the
# lower-tail probability). These first few you should know from the
# 68-95-99.7 percent rule from stats class:

pnorm(0)
pnorm(1) - pnorm(-1)
pnorm(3) - pnorm(-3)

# What z score corresponds to 84% (= 50% + 34%) probability to the
# left?

qnorm(0.84)

# Most of these functions can be switched to upper tail probabilities
# with the following format:

pnorm(0.9944579, lower.tail = FALSE)

# R can work directly with normals that are not z's: for IQ scores
# (mean 100, sd 15) what proportion of people have IQs greater than
# 130?

1 - pnorm(130, mean=100, sd=15)
pnorm(130, mean=100, sd=15, lower.tail = FALSE)

# The first of the two calculations uses the "1 minus" trick is from
# textbooks, while the second gets the results directly. Both ways of
# doing it are common in practice. Choose your favorite, or if
# teaching, match your textbook.

# **t-distribution values** -- similar to z but with degrees of
# freedom specified

pt(2, df=2)   # Central t with 2 df
pt(2,2)

# ASIDE: In R, the numbers you pass to functions can be specified by
# name (first example) or by position (like the second). There are no
# hard and fast rules for which to form use; it is a matter of style.
# However, when you start using "named parameters" (as these are
# called) you cannot use positional parameters later in the list!

qt(0.95, df=2)  # People seem to like using the names


## Installing and Attaching Libraries
#

# install.packages("e1071")    # Cannot run w/o internet

# Once installed, packages are loaded with the library() command. This
# example uses the package MASS, included with R:

library(MASS)


## Data and Data Sets
#

# R has many built-in data sets, usually from textbooks

data(mammals)   # Loads some data

head(mammals)   # Ways to "glance" at the data
tail(mammals)
summary(mammals)
head(mammals,3)

# The whole thing:
mammals


# Data Frames
#
# The main data structure for R is the data frame. This is essentially
# a spreadsheet-type view of your data.

str(mammals)    # Peek behind "the matrix"

# R usually needs to know which frame holds your data because for most
# projects you can have several frames open at once. This is a very
# different style from SPSS which is very much "one spreadsheet at a
# time." So to access the variable "body" we need to say where "body"
# lives so R knows where to look.
#
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

# Attaching is dangerous as attached data might be selected by R over
# the data you intended if you are working with data frames that share
# variable names. If you MUST use attach(), always detach() when done!

detach(mammals)

# Spend a moment meditating on the last three examples -- they each do
# the exact same thing. If you use R long enough, you will likely use
# each of them for something.


## Transformations
#
# R let's you transform data as needed:

attach(mammals)

plot(body,      brain,      pch=20, col="blue")
plot(log(body), brain,      pch=20, col="blue")
plot(log(body), log(brain), pch=20, col="blue")

detach(mammals)


# Exploring Data
#
# The main examples here are for the "Old Faithful" geyser

data(faithful)     # The data is built-in
str(faithful)
summary(faithful)

# Pictures help us think. The default pictures are line drawings, the
# colors below are to make them easier to see at the workshop.

hist(faithful$eruptions, col="gray") # Length of eruption of old faithful
hist(faithful$waiting,   col="gray") # Waiting time between eruptions

with(faithful, plot(waiting, eruptions, pch=20, col="blue"))

plot(faithful$waiting, faithful$eruptions, pch=20, col="magenta")

# What is the correlation?

with(faithful, cor(waiting, eruptions))

with(faithful, cor.test(waiting, eruptions))


## R Model Language
#

# For this example, focus on the form of the model language. Later in
# the workshop, you will see more examples of full data analyses using
# these techniques.
#
#                 *** SLIDE on LM Formulas! **
#

# Examples with Old Faithful

faith.mod <- lm(eruptions ~ waiting, data=faithful)

faith.mod

str(faith.mod)

summary(faith.mod)

anova(faith.mod)

# Check normality of model with normal plot:

qqnorm(rstandard(faith.mod), pch=20)
qqline(rstandard(faith.mod), col="red", lwd=2)

# Nicer plots -- we can add titles, labels, and so on. Most of the
# options are self-explanatory and there is a lot of help in the
# documentation and online.

# Normality plots:

qqnorm(rstandard(faith.mod), pch=20, ylab="Standardized Residuals",
       xlab="Normal scores", main="Normality of Old Faithful Model")
qqline(rstandard(faith.mod), col="deepskyblue", lwd=3)

# Nicer Regression figure:

with(faithful, plot(waiting, eruptions, pch=20, col="blue",
                    ylab="Eruption Duration", xlab="Waiting Time",
                    main="Old Faithful Data"))

# The abline function can take many different inputs and it will
# usually make an appropriate line out of them. Here we feed it the
# entire regression output and it knows what to do:

abline(faith.mod, col="red", lwd=3)

# EOF
