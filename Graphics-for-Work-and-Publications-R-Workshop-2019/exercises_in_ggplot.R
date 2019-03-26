# Exercises in ggplot
#
# Presented @ SEPA 2019 Annual Meeting
# Workshop: Graphics in R for Research and Publication
#
# Matthew D. Turner
# Georgia State University
# mturner46@gsu.edu
#
# 2019.03.22

# This file contains exercises that use ggplot2 to make elementary
# figures. The examples we looked at in the demonstrations were
# actually a little more complicated so try not to overthink these!
#
# Setup: load ggplot and the diamonds data

library(ggplot2)
library(gcookbook)  # R package; we use it for some data below

small_diamonds <- read.csv("Data/small_diamonds.csv")

# 1. Histograms and Bar Charts
#
# First we make a bar chart of the cuts of diamonds. Look at the first
# few entries of the diamonds data set. How do you do that? (You can
# refer back to the demonstrations file for help, it is called:
# W01_overview_of_ggplot.R if you were not following along!)
#
# Hint: to get help from R, use the ? symbol, like this:

?head

# 1a. Make a bar chart for the cut variable in the diamonds data set,
# set x aesthetic to be cut, then use: geom_bar()



# Did it work?
#
# Hints: Remember you need to (1) use the ggplot() function, (2)
# inside of the ggplot function you need to use aes() to set the
# aesthetics and you need to tell it which data to use: data = ____.
# Then you need to add on your geom function.
#
# Did you remember all of that? If all else fails, ask your neighbor!
# You can also look at the histogram example (after 1c, below) for a
# hint.
#
# 1b. Now change the previous exercise to make a bar chart of the
# color variable.



# 1c. Now change the previous exercises to make a bar chart of the
# carat variable:



# Note that this does not look right. Why?
#
# What kind of variable is carat? Maybe use summary() or look at
# head() again?
#
# Carat is a continuous variable, so bar charts are not right. For
# these you should use histograms, which can be obtained as follows
# (notice that you can reverse the order of the data and aes
# statements in the ggplot function):

ggplot(data = small_diamonds, aes(x = carat)) + geom_histogram()

# Histograms take continuous variables and break their range of values
# into bins, then makes a bar for each bin. Officially, histograms
# should have bars that touch, while bar charts (representing discrete
# categories) should have bars that do NOT touch.
#
# Now we grab some population change data by state. This has all 50
# states, so we just grab the top 10 for simplicity. (I do this part
# for you.) If you know some R you probably understand this, if not,
# you can just take it as given.

data("uspopchange")
changedata <- subset(uspopchange, rank(Change) >= 40) # Grab top 10 states

changedata  # Typing a data set name just prints it out!

# Look at the data printed out. What are the variables called? did we
# get 10 states like we wanted? What is Abb? Change is the increase of
# the population for the time period for which we have data.
#
# Now, let's make a bar chart of Change (y-axis) by Abb (x-axis):

ggplot(data = changedata, aes(x = Abb, y = Change)) +
  geom_bar(stat = "identity")

# Note that we use: stat = "identity" to tell ggplot to use the Change
# numbers in place of the counts. What would happen if you just
# assigned x to Abb and left geom_bar() as we used it previously? That
# is, if we get rid of the stat = "identity" parameter?
#
# Try it! It is good to break things to see how they work!!



# 1d. Add color to the bars to indicate Region:



# Did it work? If not, did you remember to capitalize the variable
# name?
#
# What is the difference between color and fill again?
#
# Another hint: Which system uses the name color, base R or ggplot?
# Which one uses col as the parameter name?
#
# One final point: it might be nice to put the bars in ascending order
# by the amount of the change. This is a little harder, but not much,
# we use the reorder() function:

ggplot(data = changedata, aes(x = reorder(Abb, Change), y = Change, fill = Region)) +
  geom_bar(stat = "identity")

# Note that this last example tells you what to do for the color if
# you had trouble with that! The function reorder() takes the first
# variable and orders it by the second. See:

?reorder

# for more.
#
# 1e. We have been using the reduced data (top 10 states) from the
# larger data set called: uspopchange (see above where we make the
# variable changedata). Using the bigger uspopchage data set, make a
# nice bar chart of all of this:



# 1f. One more modification we discussed. Let's facet the data by
# region. You can get the idea of how to do this from some of the last
# examples from the presentation, however there is one hitch you will
# see if you just copy that idea.
#
# So go ahead and copy the idea, and see what you get, then read on!



# So that did not work (unless something strange happened!!) -- the
# problem is that for EACH facet you get ALL of the states. (Right??)
# so we need to tell facet_wrap() to only use the states in the
# region. We do this by setting the parameter "scales = free" in
# facet_wrap(). Try it!



# If you are feeling like this is all very easy, look up the function
# vars() in help and see if you can figure out how to do the graph you
# just made using it!



# Now we turn to the Old Faithful geyser data:

?faithful          # Read the help page to learn what the variables are!!
data("faithful")
head(faithful)

# 1g. Geyser Data - Make a histogram of waiting time for the Old
# Faithful geyser data:




# 2. Density Plots
#
# Density plots are basically the same as histograms, so you can just
# drop geom_density in for geom_histogram.
#
# 2a. Convert the plot in exercise 1e into a density plot:



# Sometimes people like density plots with some fill to make it look
# better. Here is how to do that. To make it a little different we use
# the **eruption** time, not the waiting time, so this is NOT the same
# as the plot you just made!

ggplot(data = faithful, aes(x = eruptions)) +
  geom_density(fill = "blue", alpha = 0.30) +
  xlim(0, 6)

# There are some tweaks here that are new: we set the fill color not
# to an aesthetic, but to a constant color. Second we set the alpha to
# a fixed value, too. That means we are making a color/alpha
# combination that looks good to us; not something that conveys
# information about a variable. Finally, I added a set of x limits,
# using the xlim() function. I think this makes it look better! These
# are the sorts of tweaks you learn over time.
#
# If you don't know what alpha is, look it up online or in the opening
# slides from the workshop.
#
# We can do multiple density plots if we like. Here we use the
# "birthwt" data set from the library MASS:

bwd <- MASS::birthwt            # Trick to load some data, not important
bwd$smoke <- factor(bwd$smoke)  # Convert smoke variable to factor
head(bwd)

# 2b. Make a density plot of birthweight (bwt) on x and fill using the
# variable smoke. Note that smoke is a variable indicating if the
# mother smoked while pregnant. To see both densities, you will need
# to set a FIXED level of alpha, like in my example. Do NOT set fill
# to a constant, it has to be an aesthetic!



# For fun, use the xlim() shown above to tweak the x-axis to show the
# whole plot:



# 3. Scatterplots
#
# Let's look at the relationship between height, age, and sex.

data("heightweight")
head(heightweight)

# What is this data all about?

?heightweight

# 3a. Make a scatterplot -- remember geom_point() -- with the x-axis
# set to ageYear (note the capital "Y"), the y-axis set to heightIn,
# and color set to sex:



# 3b. Now convert the plot so that no color is used, but the shape of
# the points indicates sex (remember aesthetics?):



# If we want to manually set the shapes we can do that, too. (Again,
# this example is also a hint for the previous problems, but do make
# sure to explore the default behavior, too!):

ggplot(data = heightweight, aes(x = ageYear, y = heightIn, shape = sex)) +
  geom_point(size = 3) +
  scale_shape_manual(values = c(1, 2))

# As usual, here are the new tweaks I added: I set size to a constant
# of 3 (I picked it by trial and error) to make the symbols bigger.
# The values 1 and 2, used in the scale_shape_manual() function, were
# picked from a chart I found online of R plotting symbols.
#
# 3c. Experiment with my example code (cut and paste it into the space
# below) by changing the symbol values (the numbers 1 and 2). Stop
# when you get something you like!



# Now I am going to make a new variable. This will split the data into
# those over 100 pounds and those under:

hw <- heightweight   # Copy heightweight to a new variable

hw$weightGroup <- cut(hw$weightLb, breaks = c(-Inf, 100, Inf),
                      labels = c("< 100", ">= 100"))

head(hw)  # See our new variable?

# 3d. Now make a plot like the ones above with x-axis ageYear, y-axis
# heightIn, and then use the shape and fill to show the sex and the
# weightGroup. Your choice on what looks best. Make sure to use the
# new hw data set!



# Maybe you want to get the full weight information into the plot.
# Here is one way to do that. R will make a color gradient to
# represent the full range of weights:

ggplot(data = hw, aes(x = ageYear, y = heightIn, color = weightLb)) +
  geom_point()

# We can also use size (I set alpha to make the dots transparent for
# easier viewing):

ggplot(data = hw, aes(x = ageYear, y = heightIn, size = weightLb)) +
  geom_point(alpha = 0.50)

# 3e. Now make a plot that adds sex to the last display using color:




# 4. Lines
#
# The last basic plot type we will cover is the line plot. This is a
# basic science plot. We will use some guinea pig tooth growth data.
# Here is the information on the data, if you want to look:

?ToothGrowth

# What are the variables? They are listed in the help window.
#
# The data set called "tg" from the gcookbook library summarizes this 
# data set by giving the means of length for the various combinations
# of supp and dose:

tg  # Show the summarized data (loaded from library gcookbook)

# The data now shows supp (the supplement used, either orange juice,
# OJ, or ascorbic acid, VC) the dose of each supplement (0.5, 1, or 2
# units), and the observed average length of the odontoblasts (the
# cells responsible for tooth growth). If you want to be constantly
# surprised by weird data, become a statistician!
#
# 4a. For the tg data set, make a plot with dose on the x-axis, length
# on the y-axis, and color for the supp. Use a geom_line() to make a
# line plot:



# 4b. Add points to the graph you just made. How do you think you will
# do that? Hint: it is easy and more or less obvious!



# Another aesthetic is "linetype".
#
# 4c. Change the plot from 4a to use linetype rather than color:



# 4d. Try using color AND linetype for supp:



# Here is a solution for the last problem that includes some
# additional tweaks for size. I am not suggesting that this is a good
# plot for serious work, it just shows how things can be changed!

ggplot(data = tg, aes(x = dose, y = length, color = supp, linetype = supp)) +
  geom_line(lwd = 2) +
  geom_point(size = 6)

# Final Note: Obviously I cannot cover every type of plot. But you
# should be far enough along in playing with ggplot2 now that you can
# start to figure out how to find the infomation you need. Look online
# for lists of the geoms and use the cheat sheet. Google and other
# search engines do well with requests like "how do I make a _____ in
# ggplot?"
#
# Try the links in the slides and the comments of the files to learn
# more about the tweaks that you can use to make plots look right.
# Finally, make sure to look over the other materials provided with
# this workshop. There is a presentation showing how to work with
# Microsoft Office products, an R code file showing how to make
# publication quality graphics, and some additional R code files with
# more example plots.
#
# Good luck!

# EOF