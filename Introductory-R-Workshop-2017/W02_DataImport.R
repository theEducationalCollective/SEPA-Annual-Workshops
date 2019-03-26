# Data Import, Export, and Manipulation in R
#
# Jessica Turner
# 2017.03.07

## Moving Around and Exploring Files
#
# Where are we?
getwd()

# What files are in this diretory? How many files are in the directory?
list.files()

# Change the working directory and make sure it worked; this can be done from
# the command line if desired:
# setwd('[path]')

# Using the menus: go to the Session menu and set the working directory to where
# the script file is located

# check it works
list.files()

# Make a list and access it
#
# This command loads the list of files in the directory into a variable:
x=list.files()

# The first file is x[1], and the nth file is x[n], for any value of n between 1
# and the number of files in the directory.
#
# This is useful for automating anything that needs to go through a list of
# files one by one.
x[1]

# What is the 5th file in the directory?
x[5]

# Clear x since we don't need it now:
rm(x)

## Reading Data into R
#
# Our goal: Read a text file into R, look at it a few ways, work with it, access
# the values etc.
#
# Read in a comma separated values file:

read.csv('dataset_anova_twoway_interactions.csv')

# Ok, now read it into a dataframe so we can work with it:
stressdata = read.csv('dataset_anova_twoway_interactions.csv')

# Look at the data:
plot(stressdata)

# The summary() command provides descriptive values for a dataset:
summary(stressdata)

# What about reading in a text file that is not a csv file?
# This is for tab delimited files:

stress2 = read.table('dataset_anova_twoway_interactions.txt')

# Wait a second, something happened to the column names!
stress2[1:5,]

# How to tell R to treat the first row as the column names:
stress2 = read.table('dataset_anova_twoway_interactions.txt', header = T)

# Did it work? Check by looking at the values:
stress2[1:5,]

# ASIDE: R uses 'Boolean' or true/false values a lot. To denote the true value,
# you can use 'T' for short, or write out 'TRUE' (all in caps!). Similarly for
# FALSE and F.
#
# The command above coukd be written more fully:
stress2 = read.table('dataset_anova_twoway_interactions.txt', header = TRUE)

# Let's clear that dataframe since we won't need it:
rm(stress2)

## Selecting Data
#
# When we have a dataset, we usually want to select out parts of it and do
# analysis on those parts. How do we do that in R?

# Remind ourselves what's in the dataframe:
summary(stressdata)
str(stressdata)

# The strings that are the names of the levels of the Treatment factor:
levels(stressdata$Treatment)

# Accessing parts of a dataframe
#
# By named column:
stressdata$Gender

# By row and column (all of column 1):
stressdata[1]

# Just the first data point, or maybe the first 3:
stressdata[1,]
stressdata[1:3,]

# How about the first 3 rows but only from the 3rd column?
stressdata[1:3, 3]

# Selecting based on logical choices (all females, etc.)
# What does R do with this statement?
stressdata$Gender == "F"

# Note the double equals sign: == very different from = !
#
# We can use these Boolean (truth) values to select rows in the data frame:
stressdata[stressdata$Gender == "F",]

# And we can do conjunctions (e.g. all females whose response measure was > 3,
# etc.)
stressdata$Gender == 'F' & stressdata$StressReduction > 3

stressdata[stressdata$Gender == "F" & stressdata$StressReduction > 3,]
stressdata[stressdata$Gender == "F" & stressdata$StressReduction > 3, 2:3]

# A different way to do it: use the "subset" command
subset(stressdata, Gender == 'F')

# Subset allows you to pick arbitary columns of the dataset

subset(stressdata, Gender == 'F', select= c(Treatment, StressReduction))
subset(stressdata, select = c(Treatment, StressReduction))

# Now that we can select subsets of the data, we can look at means across
# specific factor levels. For this will use library(psych) and its function
# describeBy()

library(psych)

# What does this do?
with(stressdata, describeBy(stressdata, group = Gender))

# Try it by treatment type: what are the means by treatment?
with(stressdata, describeBy(stressdata, group = Treatment))

# Alternative: use R's built-in function aggregate(). This is not as pretty but
# it is the same information:
with(stressdata, aggregate(stressdata, by=list(Treatment,Gender), FUN = mean))

aggregate(stressdata, by = list(stressdata$Treatment,stressdata$Gender), FUN = mean, na.rm = TRUE)

## Recoding Data
#
# This is all assuming the data in the data file are what you want but what
# about recoding data? (e.g. gendeer or SES codes) changing codes: load an
# example:

stress2 = read.csv('dataset_anova_BadCode_interactions.csv')

# What's wrong with this summary?
summary(stress2)

# Set gender to be a nominal variable, i.e. a grouping factor:
stress2$Gender = as.factor(stress2$Gender)

# How's that look?
summary(stress2)

# We need to recode stress2$Gender to better names. Check the current levels:
levels(stress2$Gender)

# Reset those values appropriately:
levels(stress2$Gender) = c('Male', 'Female')

# Check it worked:
summary(stress2)

# Create a new variable based on intervals of stress reduction
# Identify even ranges of the values
tmp = cut(stress2$StressReduction, 3)

table(tmp)

# Recode with labels, Low Medium High
tmp2 = cut(stress2$StressReduction, 3, labels = c('Low', 'Medium', 'High'))

# Add these to the data frame:
stress2$ReductionLevel = tmp
stress2$ReductionLevelGroup = tmp2

summary(stress2)

# Save it as a new file
#
# Let's check what we want; write to the screen until it's in the format we want

write.table(stress2, file = "")

# We want comma-separated values
write.table(stress2, file = "", sep = ",")

# ...and no need for row numbers
write.table(stress2, file = "", sep = ",", row.names = FALSE)

# Write it to a file in the current working directory (you'd better have write
# permissions there):
write.table(stress2, file = "NewData.csv", sep = ",", row.names = FALSE)

# Is it there?
list.files()

# Save the workspace
#
# What objects are in the "workspace"?
ls()

save.image()
list.files()  # It doesn't show up because it's just .Rdata

save(list=ls(), file="Workshop1.Rdata")
list.files()

# Quit is q() and you can load workshop1.Rdata to start again where you left off...

# you can also read in SPSS files
# it requires the 'foreign' library

library(foreign)

# Read in an SPSS file version of the stress data:
list.files(pattern = '*.sav')
SPSSdata = read.spss('StressData.sav')

# How to figure out what's in it?

SPSSdata
summary(SPSSdata)
str(SPSSdata)
describeBy(SPSSdata, group = SPSSdata$Gender)

## Good Data Formatting and Practices
#

# a note on data format, organization, rows and columns etc.

# The tidy data format: Lots of us use a "wide" data format--each row is a
# subject, and all the variables are multiple columns. The "tidy" data format
# uses a "narrow" data format: each row is a unique observation or condition,
# and all of the columns are tied to that condition. For instance, longitudinal
# data: each visit is another row, with a column identifying which visit it was
# and all the measures taken at that visit (as long as there are no other
# conditions) are columns. E.g., the stress data:

# Load stressdata wide dataset:
wide = read.csv('WideFormat.csv')
summary(wide)

# Fix the subject ID problem
wide$subject = as.factor(wide$subject)
summary(wide)

# This allows a paired t.test, e.g. to test if overall pre vs post are
# different:
t.test(wide$Stress.pree, wide$Stress.post, paired=TRUE)

# And equivalently, whether overall $StressReduction is different from zero:
t.test(wide$StressReduction)

# But not an ANOVA comparing pre ve post, because there's no way to identify the
# levels:
#
# aov = (y ~ x)  -- what is y?

# Read in the long format
# How is it set up differently than before?
long = read.csv('LongFormat.csv')
summary(long)

# Fix the subject issue
long$subject = as.factor(long$subject)
summary(long)

head(long)

mdl = aov(StressLevel ~ Condition, data = long)
summary(mdl)

# Plot
plot(long$Condition, long$StressLevel)
plot(long$Treatment, long$StressLevel)

# How do we know if there's an effect of treatment on stressreduction?
# Stay tuned for the next part of the workshop for a 2 way interaction!

str(wide)

plot(wide$Treatment, wide$StressReduction)

plot(wide$Stress.pree, wide$Stress.post, pch=16)
plot(wide$Stress.pree, wide$StressReduction, pch = 8)
