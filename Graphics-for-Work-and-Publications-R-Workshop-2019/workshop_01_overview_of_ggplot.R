# Overview of ggplot2
#
# Presented @ SEPA 2019 Annual Meeting 
# Workshop: Graphics in R for Research and Publication
#
# Matthew D. Turner 
# Georgia State University 
# mturner46@gsu.edu
#
# 2019.03.22

# ggplot2 is a sophisticated plotting system developed by Hadley
# Wickham and based on the "Grammar of Graphics" (developed by Leland
# Wilkinson). It provides a systematic way of building up graphical
# displays of data from elementary ideas and operations.

# Some additional help with ggplot2 can be found at:
#
# 1. https://tutorials.iq.harvard.edu/R/Rgraphics/Rgraphics.html
# 2. https://stats.idre.ucla.edu/r/seminars/ggplot2_intro/  (excellent!)
# 3. https://rpubs.com/hadley/ggplot2-layers  (advice on layering plots)
#
# About 50 detailed ggplot examples can be found at:
#
# http://r-statistics.co/Top50-Ggplot2-Visualizations-MasterList-R-Code.html
#
# and this can give you a quick start on what you need, as well as
# giving you some new ideas.

# This file focuses on just one or two examples. The examples are
# somewhat complex but this was done for a reason. The ggplot system
# allows for plots to be built up using layers and combinations of
# "geom" functions. Most regular day-to-day plots you make will simply
# consist of a command that looks like this:
#
#  ggplot(DATASET, aes(AESTHETIC = VARIABLE, ETC.)) + geom_SOMETHING()
#
# and little else! The plots here will consist of several geoms being
# used in a chain. But without doing this, the details of how ggplot
# cannot easily be seen. So PLEASE do not be overwhelmed by the
# examples here, almost every use of ggplot is simpler than the
# examples shown here. :-)
# 
# To indicate sections of these documents, there will be a space equal
# to 3 blank lines. The end of the document is indicated by a comment
# that says "# EOF" (for End Of File)



# SET-UP to use ggplot (and some other stuff!)
#
# Remember that to use functions that are not part of "base R" you
# must first load the relevant libraries. You can do this at any point
# before using functions from the libraries, but it is considered good
# practice by many people to put them at the top of the code file.

set.seed(1001)    # Fixes the random numbers to be the same every time
                  #   we do this here to make this file the same every
                  #   time that it is run!

library(ggplot2)  # Required to load the ggplot plotting functions -- 
                  #   you will have to do this every time you use
                  #   ggplot in your own work!



# Part I -- ggplot example: basic scatterplot
#
# This section will focus on one example that is a scatterplot to show
# many of the basic features of ggplot. The scatterplot is the most
# basic plot to start with (with the possible exception of the
# histogram). It uses two of the most elementary aesthetics, the the x
# position and y position of each point in the figure, which are
# mapped to two different variables in your data set.
# 
# Here is some data for us to play with:

small_diamonds <- read.csv("Data/small_diamonds.csv")

# You can use <- or = to mean "equals"; in the sense of assignment or
# naming things. The <- or arrow notation is older. You need to
# recognize both forms as they are used fairly equally online and in
# books on R.
# 
# Here are some useful commands to summarize or look at R data:

head(small_diamonds)    # Look at the first few rows of the data
summary(small_diamonds) # Statistical summary of the data set
dim(small_diamonds)     # 5000 rows (subjects) by 5 columns (variables)

# BASE-R: Here is how you would probably make this plot if you use R
# already.
#
# You access each variable in the data set with the "$" notation; name
# of data set followed by variable: DATASET$VARIABLE

plot(small_diamonds$carat, small_diamonds$price)

# By the way: you have to use "=" inside of functions; the <- notation
# cannot be used there, it leads to errors. I am not sure how these
# stylistic conventions evolved.

# GGPLOT: Here is the ggplot equivalent figure

pvc <- ggplot(aes(x = carat, y = price), data = small_diamonds)

# But nothing appears!
#
# We need to either (1) print() the plot or (2) we can just type the
# name of the plot to make it appear in the plots pane of RStudio.
# This latter way only works interactively. The line above, with the
# arrow sign (<-), assigns the plot to the variable pvc; we can use
# any name we like!
#
# Show the plot (either of these will work interactively):

print(pvc)

pvc

# Well something appeared! But no graph. Remember that ggplot does not
# make any data appear until you specify a geom function. We add some
# points to show the scatterplot:

pvc <- ggplot(aes(x = carat, y = price), data = small_diamonds) +
  geom_point()
pvc

# IMPORTANT! Pause here for a moment and realize that for simple plots
# this is basically all you have to do to make a plot with ggplot.
# That is it. If you compare it with the base R plot, you can see
# basically the same information in both.
#
# Notice also that the background is different. The default ggplot
# axes and backgrounds are generally preferred by visualization
# professionals, but all of these features can be changed if you like.

# GGPLOT: Now let's use color to add another variable to the plot. The
# following two commands make the same plot:

pvc <- ggplot(aes(x = carat, y = price), data = small_diamonds) +
  geom_point(aes(color = cut))
pvc

pvc <- ggplot(aes(x = carat, y = price, color = cut), data = small_diamonds) +
  geom_point()
pvc

# As you will discover with ggplot, there are usualy multiple places
# you can put things. Here the aesthetic mapping of color can either
# be places in the main aes() setting (2nd example) or it can be set
# as part of the use of the geom_point() function. For many plots this
# will not matter, but when you make more complex figures with layers
# it can affect the result (example below).
#
# BASE-R: Making the colored point plot with base R graphics
#
# Note that this is a bit of a hack recommended online at the Stack
# Overflow website. It is not a systematic way of doing things.

plot(small_diamonds$carat, small_diamonds$price,
     col = small_diamonds$cut, pch = 16)
legend("bottomright", legend = unique(small_diamonds$cut),
       col = 1:length(small_diamonds$cut), pch = 16)

# The main point to observe here is that ggplot is simpler to use for
# more complicated figures. Another benefit that ggplot offers is that
# as plots become more complicated the addition of features is done
# systematically. This will be explored in the next, very detailed,
# example.



# Part II -- ggplot example: line plot (time series/repeated measures)
#
# Data for this part of the demo is the "milk_data.csv" file included
# with the workshop files. If you are running this file from the
# location where the code is located, it will know where the data is
# located.
#
# If something goes wrong, from the menu at the top of RStudio,
# select:
#
#     "Session | Set Working Directory | To Source File Location"
#
# this should fix things and when you re-run the file load command
# below it should work.

milk <- read.csv("Data/milk_data.csv")  # This data is used in ref (2) at top

head(milk)  # Show first few lines of the file
dim(milk)   # How many measurements?

# This data shows the protein content of milk from specific cows,
# recorded at multiple time points. The cows are on different diets.
#
# GGPLOT: Here is the basic graph of protein versus time:

ggplot(data = milk, aes(x = time, y = protein)) + geom_point()

# No Variable name or arrow!!?!
#
# Notice the difference here: unlike in the previous examples we are
# not assigning the plot a name. So the plots just appear. The
# downside of this is that the plots are NOT SAVED and cannot be
# further manipulated, just shown. To modify them we need to redo them
# every time. For teaching this is fine.
#
# This is ok for a demo, but for real work it is not usually what you
# want to do. (See examples both above and below this section and
# elsewhere in this workshop!)
#
# Color
#
# Add the diet as a color (a different aesthetic). There are two ways
# to do this. We can change the original specification or we can add a
# new aesthetic to the points directly.

# Here we change specification at the first layer.
#
# We will often show these commands spread out over several lines:

ggplot(data = milk, aes(x = time, y = protein, col = diet)) + 
  geom_point()

# It is important to look at your data carefully -- there is a lot
# missing here, because the points often cover each other.
#
# Do the diets look like they are equal in sampling?

table(milk$diet)

# We can reduce this problem with a standard technique, adding a
# jitter to the points. This works REALLY well here, because it is
# easy to see/explain to viewers that the "time" variable is always on
# integer values, so the jitter will not be too confusing.

ggplot(data = milk, aes(x = time, y = protein, col = diet)) + 
  geom_point() + 
  geom_jitter()

# This better shows the density of the various diets.
#
# Note that we can adjust the amount of jitter. I think the days look
# a little run together; so I will reduce the jitter to make the days
# more distinct. We do this by setting the maximum width and height
# change introduced by the random numbers:

ggplot(data = milk, aes(x = time, y = protein, col = diet)) +
  geom_point() +
  geom_jitter(width = 0.25, height = 0.25)

# To learn more about these settings, you can search for help on the
# function geom_jitter(). This works for all the functions you might
# need help with!

?geom_jitter

# We can now fit lines for each diet over this figure. For more
# details about the settings to geom_smooth() -- which draws a
# scatterplot smoother over the figure -- you can use "?" as above:
# ?geom_smooth for the help page.

ggplot(data = milk, aes(x = time, y = protein, col = diet)) +
  geom_point() + 
  geom_jitter(width = 0.25, height = 0.25) +
  geom_smooth(se = FALSE, lwd = 1.5)

# The "se = FALSE" part turns off the error bounds for the lines, and
# the "lwd = 1.5" sets the line width (thickness).

# Example: use color for **only** part of a figure
# 
# Maybe we want to reserve color for just the lines. How would we do
# this?
#
# Let's think about order for a moment, here we redo the plot with the
# color removed from the points and the lines done as above (layered
# on top of the points). We will set the points to a gray color,
# "gray50", one of several gray colors available.

ggplot(data = milk, aes(x = time, y = protein)) +
  geom_point(color = "gray50") + 
  geom_jitter(width = 0.25, height = 0.25) +
  geom_smooth(aes(col = diet), se = FALSE, lwd = 1.5)

# Well this is not right, why are some points gray and some black (the
# default color)? Note that we called jitter to move the points
# around, and the ones that are not jittered are all gray while the
# ones moved are black. So we need to change both of the geoms that
# use color!

ggplot(data = milk, aes(x = time, y = protein)) +
  geom_point(color = "gray50") +
  geom_jitter(width = 0.25, height = 0.25, color = "gray50") +
  geom_smooth(aes(col = diet), se = FALSE, lwd = 1.5)

# Notice a couple of things -- we set color to a fixed value. Plot
# elements can be either fixed values or aesthetic mappings, but not
# both!
# 
# For more on color, see the document:
# 
# https://www.nceas.ucsb.edu/~frazier/RSpatialGuides/colorPaletteCheatsheet.pdf
#
# which is included with this workshop in the "Extras" folder. You can
# also get a list of all colors in R with the colors function:

colors()

# Extra Syntax Example 1: What would happen if we left the color
# aesthetic mapping in the main ggplot command (the first function),
# like above?

ggplot(data = milk, aes(x = time, y = protein, col = diet)) +
  geom_point(color = "gray50") + 
  geom_jitter(width = 0.25, height = 0.25, color="gray50") +
  geom_smooth(se = FALSE, lwd = 1.5)

# Note that if you look at these two pictures, back to back, there are
# slight differences. This is due to the formatting of the pictures
# given the randomness introduced by geom_jitter().
#
# So when you set something in a later command (like setting the color
# to gray50 in the geom_point and geom_jitter functions here) it
# **overrides** the earlier settings (usually!).
#
# Note also here that the color setting in the first command is still
# sitting there when you get to the geom_smooth function later on; and
# because this function does **not** override the aesthetic mapping,
# it is used.
#
# Extra Syntax Example 2: Note that the order matters!

ggplot(data = milk, aes(x = time, y = protein)) +
  geom_smooth(aes(col = diet), se = FALSE, lwd = 2) + # Move the line to the 1st layer
  geom_point(color = "gray50") +
  geom_jitter(width = 0.25, height = 0.25, color = "gray50")

# Now the ugly gray data points are on top of the lines.
#
# Another view of the data might want daily summaries (boxplots):

ggplot(data = milk, aes(x = as.factor(time), y = protein)) +
  geom_boxplot(lwd = 1.5)

# Notice the new trick here: the time variable has to be set to be a
# "factor" so that R will recognize it as a "grouping variable". We do
# this with the command as.factor().
#
# By default R thinks of numbers as numbers and will not use them to
# group things. By using the as.factor function, you are telling R to
# use the numbers not as numbers but as names.
#
# Here is a plot that shows the points, summaries by day (boxplots),
# and a summary line that averages over all three diets at once:

ggplot(data = milk, aes(x = as.factor(time), y = protein, color = diet)) +
  geom_point(color = "gray50") +
  geom_jitter(width = 0.25, height = 0.25, color = "gray50") +
  geom_boxplot(outlier.shape = NA, alpha = 0.50, lwd = 1.5) +
  geom_smooth(aes(x = time), lwd = 2)            # note aes()!

# Quiz! How would you get all three lines back for the different
# diets? Hint: you need two changes, one is adding something and one
# is removing something.
#
# Notice the new trick: in the first three layers, x is a FACTOR time,
# as that works for points, jitter, and boxplots. Then it is changed
# to a continuous variable (a number) for the geom_smooth() function
# to fit the line. We have also eliminated the groups (diet) so we get
# one line only. Also the "outlier.shape = NA" parameter turns off the
# boxplot's display of outlying points; it is not needed here as we
# are already showing all the data.
#
# Swap the boxplot for the currently more trendy "violin plot":

ggplot(data = milk, aes(x = as.factor(time), y = protein)) +
  geom_point(color = "gray50") +
  geom_jitter(width = 0.25, height = 0.25, color = "gray50") +
  geom_violin(alpha = 0.50, lwd = 1.5) +
  geom_smooth(aes(x = time), lwd = 2, color = "red")



# Part III -- ggplot facets
#
# Facets are used to break data into groups and make a different plot
# for each group. This is an important part of making plots make sense
# for complex arrangements of data.
#
# In this example we will also use a variable for part of the plot and
# then add additional layers to it to change it. Please compare how
# the examples are made in all three of the sections of this example
# file. It shows three different paradigms of how to work with ggplot
# in terms of storing and modifying your results.

p <- ggplot(data = milk, aes(x = time, y = protein)) + geom_point()

p # Show the plot, named p (like the first example)

p + facet_wrap(~diet)    # Show the plot p with facets

p + facet_wrap(~diet) + geom_smooth(lwd = 1.5)    # Facets + Smoothers

# Note that the two plots where we added things to p did NOT change p
# itself:

p # The original plot!

# If we want to update the variable p to hold the new plot, we need to
# assign the result of the adding of ggplot components to the original
# variable name. Notice the assignment arrow here:

p <- p + facet_wrap(~diet) + geom_smooth(lwd = 1.5) # Note: does not show

p # Show the new plot

# Another Facet Example
#
# Here we do a DENSITY plot of protein levels (kind of like histograms
# but smoothed more) by diet and faceted by time:

ggplot(milk, aes(x = protein, color = diet)) + facet_wrap(~time) + 
  geom_density()

# If you prefer histgograms, we can do that, too.

ggplot(milk, aes(x = protein, color = diet)) + facet_wrap(~time) +
  geom_histogram(aes(fill = diet))
  
# Technically this shows the same basic information as the density
# plot figure, but the histograms are harder to read and interpret
# with multiple overlays of data. The density is better in how it
# shows things and also in that it averages the data a bit. For group
# comparisons of distribution, statisticians prefer the density plots.
#
# Hopefully these examples show you the basic principles of ggplot.
# Nothing about the examples here is really unique to the geoms that
# were selected. The principles, setting aesthetics, using fixed
# parameters settings (like the color), layers, facets, and the
# ordering of things will generalize.

# EOF