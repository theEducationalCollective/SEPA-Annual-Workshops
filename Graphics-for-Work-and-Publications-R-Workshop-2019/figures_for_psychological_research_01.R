# Figures for Psychological Research 1
# 
# Examples of: histograms, boxplots, scatter plots with & without lines
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

# Setup (as usual we need to load ggplot)

library(ggplot2)

# We will initially use some example data included with R called
# mtcars, it is data from several makes/models of car collected my
# Motor Trend magazine some years ago:

data(mtcars)
names(mtcars)  # List the variable names of this data

# The mtcars data set contains data on various models of car and their
# various features:
#
#    mpg  - miles per gallon
#    cyl  - number of cylinders
#    hp   - horse power
#    disp - displacement (engine size)
#    wt   - car weight
#    am   - automatic or manual transmission
# 
# and so on. We will use these to make some simple figures. 
# 
# Remember that we can pick the variables out of this data set with
# the "$" notation:

mean(mtcars$mpg)     # Compute the mean of the mpg variable
sd(mtcars$mpg)       # Standard deviation
median(mtcars$mpg)   # Median, etc... 



# Histograms
#
# Histograms are one of the most basic plots, here are several
# examples in both base R and ggplot. Each will start with a simple
# example, and then add more details to the figure.
#
# BASE-R: Use the hist function

hist(mtcars$mpg)   # Not very pretty

hist(mtcars$mpg, col = "cyan", main = "This is a histogram",
     xlab = "Miles per Gallon (MPG)")

# We can set color with "col", the main title with "main", and the
# x-axis label with "xlab" -- there is also a "ylab" for the y-axis,
# but we do not need it here.
#
# GGPLOT: This one starts out longer. (We will assign each plot to the
# variable g as we go)

g <- ggplot(aes(x = mpg), data = mtcars) + geom_histogram()
g

# Yikes! This histogram has way too many bins! We can change this. If
# you search for help on the geom_histogram function it will tell you
# more about setting bins. It also allows you to set breakpoints or
# use other algorithms to find the number of bins. See also:
# 
# https://ggplot2.tidyverse.org/reference/geom_histogram.html
# 
# for more.

g <- ggplot(aes(x = mpg), data = mtcars) + geom_histogram(bins = 10)
g

# Some people like this aesthetic choice, but I think the bins running
# together is not great, so we can set the color of the edges of the
# bars in the plot to something else to make them visible:

g <- ggplot(aes(x = mpg), data = mtcars) + 
  geom_histogram(bins = 10, color = "black", fill = "cyan")
g

# Remember that color is the EDGE color, and fill is the color INSIDE
# the bars. Note also that I am not really a fan of cyan as a color, I
# just wanted something distinct. Change it to something else!
# 
# Here is the list of color names R knows:

colors()

# Note that although ggplot requires more work up front, it often
# makes it easier to add additional features. Here is the same data,
# presented as densities (proportions rather than frequencies) and
# with the corresponding normal curve added as an overlay.
#
# Once you get the hang of it, this is not so complicated, but if it
# seems like a lot now, don't fret, just skip this example and move
# on, and come back when you learn more!
#
# First we show the functions as we have been working with them
# throughout the workshop:

g <- ggplot(aes(x = mpg), data = mtcars) + 
  geom_histogram(aes(y = ..density..), bins = 10, color = "black", fill = "white") + 
  stat_function(fun = dnorm, args = list(mean = mean(mtcars$mpg), sd = sd(mtcars$mpg)), lwd = 1.1, color = "red")
g

# When you see R code online, it will often be formatted in a way that
# makes it all fit on the screen at once. Compare the next lines with
# the example just above -- they are EXACTLY the same. Really!

g <- ggplot(aes(x = mpg), data = mtcars) +
  geom_histogram(aes(y = ..density..),
                 bins = 10,
                 color = "black",
                 fill = "white") +
  stat_function(fun = dnorm,
                args = list(mean = mean(mtcars$mpg), 
                            sd   = sd(mtcars$mpg)),
                lwd = 1.1,
                color = "red")
g

# Once you get used to it, you can read these things easily. For
# whichever version of the code you prefer, look carefully. The
# changes we made are:
# 
#  1. We added "aes(y = ..density..)" to geom_histogram to convert
#     from frequencies to densities (proportions)
#  2. We added the "stat_function" telling ggplot to add the curve
#     from a statistical function.
#  3. We told R to use "dnorm" as the statistical function -- this 
#     computes the "density" of the normal curve (the bell curve 
#     shape). And we pass this function two named arguments, "mean"
#     and "sd" -- the parameters of the normal curve.
#  4. Finally we added in "lwd" (line width) and "color" for the 
#     normal curve. Remember ggplot uses "color" not "col"!
# 
# There is a lot happening here, so don't be overwhelmed if it does
# not all make sense. You can look up many of these things in R's
# help. Looking online for advice about adding normal curves to
# histograms in R and ggplot will give many guides on how to do this
# with more details.
# 
# This is the sort of example that is worth coming back to once you
# feel your understanding of R and ggplot is stronger!
# 
# One final addition. The xlim nad ylim functions in ggplot work like
# the corresponding parameters in base R graphics. So here is the plot
# with a better x-axis for showing the normal curve. The only change 
# is the xlim() function.

g <- ggplot(aes(x = mpg), data = mtcars) + 
  geom_histogram(aes(y = ..density..), bins = 10, color = "black", fill = "white") + 
  stat_function(fun = dnorm, args = list(mean = mean(mtcars$mpg), sd = sd(mtcars$mpg)), lwd = 1.1, color = "red") +
  xlim(0, 40)
g



# Boxplots
#
# In the last few years boxplots have become standard in psychology.
# Thank goodness! It certainly took long enough; the other sciences
# have had them since the mid-1980's! Here are a couple boxplots.
#
# BASE-R: Use the boxplot function; although some other functions will
# peoduce them by default.
#
# *** R FORMULA NOTATION ***
#
# To use this function you have to know the "formula notation" of R.
# This notation is based on linear models which are written:
#
# Y = b_0 + b_1*X + b_2*Z  (b_i are coefficients; Y,Z,X are variables)
#
# and in R is stylized:
#
# Y ~ X + Z   (in R, coefficients are not given but filled in automatically)
#
# This is usually read as "Y as a function of X." For boxplots, X
# should be a grouping variable. Let's look at mpg (fuel efficiency)
# as a function of the number of cylinders in an engine (big engine =
# more power = less efficient; usually).

boxplot(mtcars$mpg ~ mtcars$cyl)

# Look at the cylinder variable:

summary(mtcars$cyl)
table(mtcars$cyl)

# R sees that this is a number but also recognizes that it is just 3
# values. So it treates it as a group. Sometimes R gets fussy and
# won't treat numbers as names like they are used here. When that
# happens you can force R to treat numbers as names (levels of a
# factor variable) with the as.factor() function.

boxplot(mtcars$mpg ~ as.factor(mtcars$cyl))

# But that is not needed here bacause R recognized the factor nature
# of the variable. HOWEVER, R is not consistent in this behavior so
# remember the as.factor() function for those cases!
#
# R allows us one more trick that makes this easier, but unfortunately
# R is not consistent on when you can do this. But MANY functions
# allow this shortcut:

boxplot(mpg ~ cyl, data = mtcars)

# This uses the R "formula notation"
# To fix it up a bit the same parameters from above are allowed:

boxplot(mpg ~ cyl, data = mtcars, main = "Boxplot Example", 
        xlab = "Number of Cylinders", ylab = "Miles per Gallon (MPG)")

# GGPLOT: We follow the usual pattern. Note that we need to hint
# ggplot that the cyl variable is a factor. By default, ggplot will
# treat it as a number. (Unlike R, ggplot is ALWAYS fussy!!)

g <- ggplot(aes(x = as.factor(cyl), y = mpg), data = mtcars) + 
  geom_boxplot()
g

# For once, ggplot is not giving us a good x-axis label. So we fix
# this with the labs() function. See:
#
# https://ggplot2.tidyverse.org/reference/labs.html
#
# for more details. Note that we stored our ggplot inside of the
# variable g. Because we have that, we can just continue modifying g
# as we add features such as new labels:

g <- g + labs(x = "Number of Cylinders") + 
  labs(y = "Miles per Gallon") + labs(title = "Boxplot Example")
g

# coord_flip()
# 
# By the way, here is a neat trick! The ggplot system allows easy 
# flipping of coordinates with just one function:

g <- ggplot(aes(x = as.factor(cyl), y = mpg), data = mtcars) + 
  geom_boxplot() + labs(x = "Number of Cylinders") + 
  labs(y = "Miles per Gallon") + labs(title = "Boxplot Example") +
  coord_flip()
g



# Scatterplots (with and without regression lines)
#
# The basic scatterplot in base R and ggplot was covered in the
# discussion of ggplot's main features. Here we review this in an
# example, then add a regression line (and scatterplot smoother) to
# it.
#
# BASE-R: Use the plot command

plot(mtcars$disp, mtcars$mpg)

# The default plot is not great. I usually replace the open circle
# with a solid dot. This is set with the plotting character parameter,
# "pch". We can also set color:

plot(mtcars$disp, mtcars$mpg, pch = 16, col = "gray30", 
     xlab = "Displacement", ylab = "Miles per Gallon", 
     main = "Efficiency as a function of Displacement")

# To add a regression line you need to compute the regression. We
# cannot cover this in detail here, but the linear model (lm) command
# fits straight lines and we use it. This also uses the "formula
# notation" mentioned previously.
#
# Here we want mpg as a function of displacement:

mod <- lm(mpg ~ disp, data = mtcars) # Fit the model: mpg = b0 + b1*disp

# R stores ENTIRE models inside of variables, so everything you need
# to make the regression line is in the variable mod.
#
# The abline() function will add this regression line to the last plot
# made, which is the one we want! What is great about the abline()
# function is that you just give it the entire model we just made and
# it picks out the line for us.

abline(mod, lwd = 2, col = "red")

# Bigger engines = lower efficiency!
#
# I promised to show you how to add a scatterplot smoother, a LOESS
# line, and there are two ways to do it.
#
# The first is to use a fully packaged function that plots the line
# and the points. This one is good for day to day work.

scatter.smooth(x = mtcars$disp, y = mtcars$mpg)

# Notice that I did not use the "data = mtcars" setting here. This
# function does NOT support that parameter! (I told you that R was
# inconsistent.)
#
# Another way to add a scatterplot smoother line to a scatterplot is
# to compute the smooth and then add it to the figure we made at the
# start of this section.

plot(mtcars$disp, mtcars$mpg, pch = 16, col = "gray30", 
     xlab = "Displacement", ylab = "Miles per Gallon", 
     main = "Efficiency as a function of Displacement")

lom <- loess(mpg ~ disp, data = mtcars) # Fit the loess model
lp  <- predict(lom)                     # Generate the predicted mpg's

lines(mtcars$disp[order(mtcars$disp)], lp[order(mtcars$disp)], 
      col = "red", lwd = 2)             # Plot the line predicted

# This is harder than using the "black box" function, but as you learn
# more R you can extend this in ways that the black box cannot do.
#
# GGPLOT: The pattern should be clear by now.
#
# Here ggplot starts to show that when things get harder, it gets
# better...
#
# Simple, for day to day work:

g <- ggplot(aes(x = disp, y = mpg), data = mtcars) + geom_point()
g

# Nicer, with titles/axis labels. Publishable, maybe with a little
# work on fixing the margins or fonts:

g <- ggplot(aes(x = disp, y = mpg), data = mtcars) + geom_point() +
  labs(x = "Displacement") + labs(y = "Miles per Gallon") + 
  labs(title = "Efficiency as a Function of Engine Size")
g

# Add a LOESS smoother? Easy:

g <- ggplot(aes(x = disp, y = mpg), data = mtcars) + geom_point() +
  labs(x = "Displacement") + labs(y = "Miles per Gallon") + 
  labs(title = "Efficiency as a Function of Engine Size") +
  geom_smooth()
g

# Add a regression line? Almost as easy:

g <- ggplot(aes(x = disp, y = mpg), data = mtcars) + geom_point() +
  labs(x = "Displacement") + labs(y = "Miles per Gallon") + 
  labs(title = "Efficiency as a Function of Engine Size") +
  geom_smooth(method = lm, color = "red")
g

# So ggplot thinks that fitting a straight lines is a kind of scatter
# plot smoother. This is true and it is how modern statistical theory
# tends to view things.
#
# Notice also that ggplot assumes the DEFAULT smooth is a loess and
# you have to override the default with "method = lm" to get a linear
# model (lm) fitted line.
#
# This is consistent with modern statistical practice that prefers
# loess, and scatterplot smoothers generally, over straight
# line/linear models. This is an example of how R encodes the
# practices of statisticans, rather than psychologists, into its core.
# SPSS tends to encode the practices of psychologists and social
# scientists. This is a good thing. Statisticians' practices are
# generally better. (Sorry!)
#
# By the way we can add both lines easily:

g <- ggplot(aes(x = disp, y = mpg), data = mtcars) + geom_point() +
  labs(x = "Displacement") + labs(y = "Miles per Gallon") + 
  labs(title = "Efficiency as a Function of Engine Size") +
  geom_smooth(color = "blue", se = FALSE) +
  geom_smooth(method = lm, color = "red")
g

# To make the image clearer, I turned OFF the standard error
# visualization for the loess. You can easily choose to turn off the
# linear model's error bounds if you prefer. One of the advantages of
# ggplot in this case is that the functions and parameters are
# consistent across types of models! Much better than base R graphics.

# EOF