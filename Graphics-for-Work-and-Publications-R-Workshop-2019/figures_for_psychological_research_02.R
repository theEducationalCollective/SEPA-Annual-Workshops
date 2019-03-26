# Figures for Psychological Research 2
# 
# Examples of: bar charts (with and without error bars), line plots, 
#              interaction plots, dodging, and more additional tweaks
#
# Presented @ SEPA 2019 Annual Meeting 
# Workshop: Graphics in R for Research and Publication
#
# Matthew D. Turner 
# Georgia State University 
# mturner46@gsu.edu
#
# 2019.03.22

# This file has a number of examples of basic and advanced plots that
# may be of some use in psychology. Examples will be given from both
# ggplot and from base R graphics. In some cases, one or the other of
# these will be preferable, but in many cases both are acceptable for
# daily use or in publication.
#
# The data will not be very psychological but you would not believe
# how hard it is to find representative psychology data!

# Setup (as usual we need to load ggplot) and we will load the
# gcookbook library for some data to use in making the plots

library(ggplot2)
library(gcookbook)



# Bar Charts (with and without error bars)
#
# One of the most used plots in psychology is the bar chart with an
# error bar to represent a measurement. In the workshop exercises you
# made some basic bar charts using ggplot, without error bars. Here we
# expand on this.
#
# Note: As a statistician, and someone who cares about data
# visualization, I generally prefer to get people away from using
# these sorts of charts as there is evidence the bars mislead people.
# But the chart type is very common in psychology so we show how to
# make it here. When possible, use a boxplot to give similar summaries
# for data sets.
#
# Example data: cabbages
# 
# We will use some agricultural data for this example that is similar
# to a fixed-effects factorial design. There are 2 cultivars (types)
# of cabbage (c39 and c52), and 3 planting dates (d16, d20, d21). We
# are interested in the weights of the cabbages, and the data set also
# has standard deviations and standard ERRORs for these measurements.
# If you want the original data, they are included in the R library
# MASS, included with R. Type: ?cabbages_exp (aggregate data) and
# ?cabbages (full raw data) for more!

cabbage_exp  # The aggregate data

# GGPLOT: We will do this example with ggplot only, as it is much
# easier for this type of plot. Really. In base R, the programs to
# make these plots look reasonable are a full page of code; in ggplot
# they are a few lines.
#
# Here is the bar plot for just one of the cultivars:

ce_mini <- subset(cabbage_exp, Cultivar == "c39") # Pick out 1 cultivar

g <- ggplot(ce_mini, aes(x = Date, y = Weight)) + 
  geom_bar(fill = "white", color = "black", stat = "identity")
g

# Not very pretty. We have to tell geom_bar() to use the "identity"
# parameter, otherwise it expects count data for bar charts. This form
# (using identity) is common in psychology.
#
# NOTE: Several books and websites that are a bit older leave this
# detail out as there was a change in how ggplot works at some point!
#
# Here are the error bars:

g <- ggplot(ce_mini, aes(x = Date, y = Weight)) + 
  geom_bar(fill = "white", color = "black", stat = "identity") +
  geom_errorbar(aes(ymin = Weight - se, ymax = Weight + se), width = 0.2)
g

# Note:
#
# (1) Inside the geom_errorbar we set a new aesthetic defining ymin
# (the bottom error bar) to mean weight minus the standard error, and
# ymax to the mean weight plus the se. You can use computations here
# or, in more complex data sets, have the ymin and ymax values pre-
# computed and stored in the data frame.
#
# (2) We set the width of the error bars to 0.2; that is 0.2 times the
# width of the chart bars. By default the error bar width will equal
# the full width of whatever object they are attached to, and in this
# case the error bars will look awful! So we adjust this down.
#
# One more detail, maybe we want the y-axis to go to the next full
# number, here 4. We use ylim().

g <- ggplot(ce_mini, aes(x = Date, y = Weight)) + 
  geom_bar(fill = "white", color = "black", stat = "identity") +
  geom_errorbar(aes(ymin = Weight - se, ymax = Weight + se), width = 0.2) +
  ylim(0,4)
g 

# Here is the plot for both cultivars:

g <- ggplot(aes(x = Date, y = Weight, fill = Cultivar), data = cabbage_exp) +
  geom_bar(position = position_dodge(), stat = "identity") +
  geom_errorbar(aes(ymin = Weight - se, ymax = Weight + se),
                position = position_dodge(), width = 0.2)
g

# We use the "dodge" parameter to tell ggplot to place the bars
# side-by- side, and for this we tell it to use the position_dodge()
# function. Note that when we do not give it any values for the dodge,
# it will use good defaults (usually!).
#
# However the error bars are NOT in the right places! We need to tell
# the error bars **how much** to be dodged. The default dodge for the
# error bars will be the size of the bars, which we set to 0.2. (It
# kind of looks like that is what happened here.) The dodge for bar
# charts is, by default, 0.9. (We can look this up on the ggplot2
# website or in the built-in help.)
#
# So we need to tell the error bars to use this larger amount of dodge
# (this new command is mostly the same as above, just one change):

g <- ggplot(aes(x = Date, y = Weight, fill = Cultivar), data = cabbage_exp) +
  geom_bar(position = position_dodge(), stat = "identity") +
  geom_errorbar(aes(ymin = Weight - se, ymax = Weight + se),
                position = position_dodge(0.9), width = 0.2)
g

# Dodging makes sense once you get used to it, but it takes some
# practice and, specifically, experimenting and BREAKING your plots to
# really learn about how to do it. See:
#
# http://ggplot2.tidyverse.org/reference/position_dodge.html (manual)
# 
# for more. And the following (long) page of example plots shows a lot 
# of examples of dodges: 
# 
# http://www.sthda.com/english/wiki/be-awesome-in-ggplot2-a-practical-guide-to-be-highly-effective-r-software-and-data-visualization
#
# This last bar chart we made is actually a pretty chart, but it 
# should not exist. Similar information is better conveyed by the 
# corresponding boxplots:

library(MASS)   # For the original FULL (not summary) cabbages data
data(cabbages)   
cabbages        # Show the data

boxplot(HeadWt ~ Cult:Date, data = cabbages) # Quick boxplot compare to previous

# Or in ggplot:
#
# We need to use the auxillary function interaction() to compute a new
# variable which holds the combinations of cultivar and date. We store
# it in the itx variable. This gives the same boxplot as base R above:

itx <- interaction(cabbages$Cult, cabbages$Date)

itx          # What is in itx?
length(itx)  # How long is it?

g <- ggplot(aes(y = HeadWt, x = itx, color = Cult), data = cabbages) + 
  geom_boxplot()
g

# A lot of people these days like to drop the original data points on
# top of the boxes to show both a summary and the original noisy data.
# We will use jitter to make it clearer:

g <- ggplot(aes(y = HeadWt, x = itx, color = Cult), data = cabbages) + 
  geom_boxplot(outlier.shape = NA) + geom_point() + geom_jitter()
g

# NB: the "outlier.shape = NA" parameter turns off any points that the
# geom_boxplot might add. We do not need them because we are including
# all of the points in this one. 
#
# Also note that you can change the x-axis names in a variety of ways
# see:
#
# www.sthda.com/english/wiki/ggplot2-axis-ticks-a-guide-to-customize-tick-marks-and-labels
#
# for more. There are many other sites explaining this process if you
# don't like this one.



# Line Plots
#
# GGPLOT: As mentioned above, when looking at bulk data a boxplot is
# better than a bar chart. However, when using bars to summarize
# single measurements (like means or other parameters) line plots are
# sometime more clear. A better chart than using bars for many types
# of data is to use a line plot. Here we use the same data as above,
# but with lines:
#
# Just one cultivar:

g <- ggplot(ce_mini, aes(x = Date, y = Weight)) + 
  geom_point(size = 4) +
  geom_line(aes(group = 1)) + 
  geom_errorbar(aes(ymin = Weight - se, ymax = Weight + se), width = 0.1)
g

# A couple of things to note:
# 
#   (1) I set the size to 4 for geom_point() because it looked good
#   (2) Same reason for setting "width = 0.1" in geom_errorbar()
#   (3) The "aes(group = 1)" setting in geom_line() forces ggplot to
#       connect the dots. In effect, it creates a single fixed group.
#       This will make more sense when you compare it with the next
#       example!
# 
# Now let's do this for both cultivars:

g <- ggplot(aes(x = Date, y = Weight, color = Cultivar, group = Cultivar), 
            data = cabbage_exp) +
  geom_line() +
  geom_point(size = 4) + 
  geom_errorbar(aes(ymin = Weight - se, ymax = Weight + se), width = 0.1)
g

# For day to day work this may be ok, but there are some problems. We
# should do some dodging of the points to see them better. We will
# save the dodge we want to use in the variable pd, then we will use
# this dodge setting for each of the plot items.

pd <- position_dodge(0.2) # save this in a variable to save typing!

g <- ggplot(aes(x = Date, y = Weight, color = Cultivar, group = Cultivar), 
            data = cabbage_exp) +
  geom_line(position = pd) +
  geom_point(position = pd, size = 4) + 
  geom_errorbar(aes(ymin = Weight - se, ymax = Weight + se), width = 0.1,
                position = pd)
g

# Note that I tried several values for the dodge and just picked the
# one I liked the most.
#
# Some people like error bars to be a different color:

g <- ggplot(aes(x = Date, y = Weight, color = Cultivar, group = Cultivar), 
            data = cabbage_exp) +
  geom_line(position = pd) +
  geom_point(position = pd, size = 4) + 
  geom_errorbar(aes(ymin = Weight - se, ymax = Weight + se), width = 0.1,
                position = pd, color = "black")
g

# Notce the problem here! Because the error bars are plotted last,
# they appear on top of the points.
#
# Remember ggplot works in LAYERS!
#
# So we need to re-order the plot instructions. The only change here
# is where we place the geom_errorbar() function:

g <- ggplot(aes(x = Date, y = Weight, color = Cultivar, group = Cultivar), 
            data = cabbage_exp) +
  geom_errorbar(aes(ymin = Weight - se, ymax = Weight + se), width = 0.1,
                position = pd, color = "black") +
  geom_line(position = pd) +
  geom_point(position = pd, size = 4)
g



# Interaction plots
#
# A convenient plot used in factorial designs is the interaction plot
# where one factor is on the x-axis and the other factor is shown with
# lines. These are especially useful for interpreting interactions in
# linear model analysis.
#
# The data here is on tooth growth in 60 guinea pigs. The animals were
# given a dose of vitamin C (0.5, 1.0, or 2.0 mg/day) by one of two
# delivery methods: as orange juice (labelled OJ) or as a direct
# supplement (labelled VC in the data). The response is sometimes
# called tooth length, but it is actually the cell size of the
# odontoblasts. Here are some summaries of the data:

by(ToothGrowth$len, ToothGrowth$dose, summary)
by(ToothGrowth$len, ToothGrowth$supp, summary)

# by() is a useful function. It takes a variable inside of a data
# frame to be analyzed (here the "len" variable) and also a grouping
# variable in the same data frame (here "dose" then "supp"), and
# finally the name of a function to compute (here summary).
#
# BASE-R: There is an interaction.plot() function. It does NOT accept
# a "data = " parameter. Sorry.

interaction.plot(ToothGrowth$dose, ToothGrowth$supp, ToothGrowth$len)

# This is what most people use for day-to-day work. This is not
# something that can be made to look very nice. However, it has the
# advantage that it works on the raw data.
#
# GGPLOT: This is basically the same as the line plots above, and easy
# to make and manipulate for nicer quality. The downside is that we
# need to aggregate the data. Fortunately R provides a simple funtion
# for this!

toothMeans <- aggregate(len ~ dose+supp, data = ToothGrowth, mean)

g <- ggplot(aes(x = dose, y = len, color = supp), data = toothMeans) +
  geom_line() +
  geom_point(size = 4)

g

# Note that the ggplot version shows that the distance between 1 and 2
# is twice that between 0.5 and 1, in terms of dose. This is probably
# a good thing as does IS a continuous variable.
#
# But if we want to emphasize that does is a name only (a factor), we
# can wrap it in the as.factor() function.
# 
# I also changed the line width with "lwd = 1.2":

g <- ggplot(aes(x = as.factor(dose), y = len, color = supp), 
            data = toothMeans) +
  geom_line(aes(group = supp), lwd = 1.2) +
  geom_point(size = 4)

g

# Note that when I made dose into a factor, this broke the geom_line()
# function. My first plot had no lines. To get the lines back, I had
# to set a "group" aesthetic, which I added to geom_line() to
# emphasize that this is the function that needed it. Note that there
# is no problem making one variable apply to more than one aesthetic.

# EOF