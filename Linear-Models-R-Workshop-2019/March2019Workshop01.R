# Workshop Part 1.0
# Intro to linear modeling in R
# Jessica & Matthew Turner, March 2019

library(car)

# where are we?
getwd()

# Change the working directory to where the script file and data files
# are

# A first regression (pulled from Fox & Weisberg, 2nd Edition)

# Read in the data file from the Dat directory

duncan = read.table("Data/Duncan.txt", header=TRUE)

# Check the global environment window (usually on the right)--what
# changed? what's in the dataframe duncan?

summary(duncan)

# let's just look at the education data
duncan$education  # this just dumps it to the screen

summary(duncan$education)  # what is this doing?

# how about accessing all the income data
duncan$income

# what's the distribution look like

hist(duncan$income, col="gray")
hist(duncan$prestige, col="gray")

plot(duncan$income, duncan$prestige, pch=16)
# let's fix the labels
plot(duncan$income, duncan$prestige, pch=16, xlab="Income", ylab="Prestige")

# can we regress prestige against the occupational income?

duncan.mod = lm(duncan$prestige ~ duncan$income) # what happens?

summary(duncan.mod)

# qqplot on the model
qqPlot(duncan.mod, pch=16)

# who are the outliers?
row.names(duncan)[6]
row.names(duncan)[16]
row.names(duncan)[c(6,16)]  # welcome to the c() command--stay tuned for more on that!

# histogram of the studentized residuals
hist(rstudent(duncan.mod))

# quick plot using scatterplot(), several ways
#
plot(duncan$income, duncan$prestige, pch=19)

# scatter plot by default fits an OLS regression
scatterplot(duncan$income, duncan$prestige, pch=19, col="red")

# or you can be explict about the model--and turn on the option to id
# the outliers
scatterplot(prestige ~ income, data=duncan, id=TRUE)

# but let's automatically fit regressions separately for the different
# occupation groups
scatterplot(prestige ~ income, data=duncan, id=TRUE, 
            groups=duncan$type, smooth=FALSE)

# this is great to look at but you'll note it did not save the
# different models as objects!

# Your turn: Try making some new models regressing prestige against a
# combination of variables, e.g., prestige against education, education + income






# The END of this part. 

