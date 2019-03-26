# Workshop Part 2.0
# Intro to linear modeling in R
# Jessica & Matthew Turner, March 2019

library(car)
library(lme4)

# Working with Data--subsetting, transforming, visualizing
duncan=read.table("Data/Duncan.txt", header=TRUE)
summary(duncan)
# we already know about column names
duncan$type

# this puts out all rows for the first column
duncan[,1]

# all columns for the second row
duncan[2,]

# what does this do?
duncan[2:5, 1:3]

# How would you get the 3rd row?


# How would you get the 3rd row, only the 2nd column?


# If we wanted only the blue collar data:

subset(duncan, type=="bc") # note the double == 

# blue collar data with prestige > 25

subset(duncan, type=="bc" & prestige > 25)

# these subsets are dataframes and behave like it

summary(subset(duncan, type=="wc"))

# you can save them as a new dataframe for use in other functions

bc_data=subset(duncan, type=="bc")

bc.mod = lm(bc_data$prestige ~ bc_data$income)
summary(bc.mod)
plot(bc_data$income, bc_data$prestige)

# create a subset of the duncan data that is the data from the white
# collar professions with prestige below average for the wc group
# and save it in a variable named 'wcdata'



# does prestige relate to income in the white collar professions? 



# let's talk about the c() function--what does it do? Try these:
c(1,2,3,4,5)
c("type", "income")
c(1,2,3,4)/2
c(1,2,3,4) + c(6,8,10,12)
log(c(10,100,1000), base=10)

x=c("bob", "jane")
y=c("grace", "eric")
c(x,y)

# can we use dataframes in c()?  What does this do?
c(duncan,bc_data)

summary(c(duncan, bc_data))  # hmm!! 

# but for our purposes, you can use c() to select more than one column from your dataframe

subset(duncan, select = c("type", "income"))

# data transformations

# let's add some random data to our dataframe

nonsense = runif(45)

duncan$SillyData = nonsense

# check what it did to the duncan dataframe: How would you look at it?


# More transformations: 
# read in some data that needs recoding

Stressdata = read.csv("Data/dataset_anova_BadCode_interactions.csv")
summary(Stressdata)

# turning numbers into factor levels

Stressdata$Gender = as.factor(Stressdata$Gender)
summary(Stressdata)

# relabeling numbers as strings
# for a factor variable, we can check what the levels are called, and reset those values
levels(Stressdata$Gender)

# reset the values
levels(Stressdata$Gender) = c("male","female")
summary(Stressdata)

# centering a variable
Stressdata$StressReduction.cent = scale(Stressdata$StressReduction, 
                                        center = TRUE, scale = FALSE)

# z-scaling it
Stressdata$StressReduction.z = scale(Stressdata$StressReduction, 
                                     center = TRUE, scale = TRUE)

# check what happened to Stressdata!



# make a histogram of those values to see what they look like


# dealing with missing data
# let's read in an example

missdata = read.csv("Data/dataset_anova_missing.csv", header=TRUE)
summary(missdata)

# what does that do
median(missdata$CognitiveChange)
median(missdata$StressReduction)

lm(missdata$StressReduction ~ missdata$Treatment)

# some functions by default know to drop missing cases, some don't

median(missdata$StressReduction, na.rm = TRUE)

# look in the help documentation for a given command, for how to specify what to do with NA data

# do you want to know which ones are causing trouble?
complete.cases(missdata)

# you can make a new dataframe based on the complete cases
missdata.complete = na.omit(missdata)

# binning your data
# Create a new variable based on intervals of stress reduction.
# First, what do the stress reduction values look like?
hist(Stressdata$StressReduction)

#
# Identify even ranges of the values using cut()
tmp = cut(Stressdata$StressReduction, 3)

table(tmp)

# Recode with labels, Low Medium High
tmp2 = cut(Stressdata$StressReduction, 3,
           labels = c('Low', 'Medium', 'High'))

# Add these to the data frame:
Stressdata$ReductionLevel = tmp
Stressdata$ReductionLevelGroup = tmp2

summary(Stressdata)

# more on visualizing your data
# plot() as a general purpose function--it tries to make smart choices

# show the possible pairings of the first 3 variables
plot(Stressdata[,1:3])

# plot treatment vs stress reduction score
plot(Stressdata[,1],Stressdata[,3])
plot(Stressdata$Treatment, Stressdata$StressReduction)

# plot reduction score against z score of stress reduction
plot(Stressdata$StressReduction, Stressdata$StressReduction.z)

# boxplot

boxplot(Stressdata$StressReduction ~ Stressdata$Gender)

# make a boxplot by treatment group


# how about response as a function of both?

plot(Stressdata$StressReduction ~ Stressdata$Gender + Stressdata$Treatment)

boxplot(Stressdata$StressReduction ~ Stressdata$Gender + Stressdata$Treatment)

# Save what you've changed in the data as a new file
#
# Let's check what we want; write to the screen until it's in the
# format we want

write.table(Stressdata, file = "")

# We want comma-separated values
write.table(Stressdata, file = "", sep = ",")

# ...and no need for row numbers
write.table(Stressdata, file = "", sep = ",", row.names = FALSE)

# Write it to a file in the current working directory (you'd better
# have write permissions there):
write.table(Stressdata, file = "NewData.csv", sep = ",",
            row.names = FALSE)

# Is it there?
list.files()

# and clear your environment of everything
rm(list=ls())

# Your turn: 
# 1) Read in one of the files in the Data directory
# 2) Select a dependent variable and two independent variables and use subset() to make a smaller dataframe
# 3) run a linear model on the smaller dataset --either multiple regression or anova using lm()
# 4) write your reduced dataset out to a new file.
# 5) make a histogram of one of the data variables

