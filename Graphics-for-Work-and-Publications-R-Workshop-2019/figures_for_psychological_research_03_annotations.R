# Figures for Psychological Research 3: Annotations
# 
# Examples of: 
#
# Presented @ SEPA 2019 Annual Meeting 
# Workshop: Graphics in R for Research and Publication
#
# Matthew D. Turner 
# Georgia State University 
# mturner46@gsu.edu
#
# 2019.03.22

# This file contains examples of (relatively) simple plots in base R
# and ggplot, with some additional tweaks and also annotations.
#
# For publications annotations are often critical for effective
# communication.
#
# The primary focus of this workshop is on using ggplot2 as a library
# to make good quality graphics for research. However, the base R
# graphics system is usually already well-known by R users, fairly
# easy to use, and has some nice tricks to make specific kinds of
# figures.
#
# One place where base R graphics works well is with easy annotation
# of simple plots. Text and lines can be added easily, often more
# easily and precisely than can be done with Excel. Here we show some
# examples of base R plots relevant to psychology and several
# marked-up examples to give you some ideas.



# Example 1: Scatterplot with regions marked by vertical & horizontal
#            lines
#
# This example is from some of my own research in computing and
# informatics; however it can be applied to any data for which a
# scatterplot may be used.
#
# We have some data that relates how often certain terminology is used
# in the scientific literature (calculated from actual downloaded
# scientific papers from the journal _Frontiers in Psychology_) and
# how well a computer using a machine-learning algorithm can identify
# papers that SHOULD use these terms. We are interested in making
# software that can automatically label papers.
#
# Machine learning algorithms work best when they have many examples
# of how terms are used in scientific papers, that is, a higher
# proportion of papers using the term, but many technical terms are
# used infrequently. The plot below relates how often terms are used
# (the variable: ml$freqLabel on the horizontal axis) to how well the
# machine can classify the papers as needing the term (using something
# called the "F1-score," ml$f1, which ranges from 0, bad, to 1,
# excellent). The goal of this example is to show how to mark off
# regions of a plot and label them, but we start with adding a simple
# line.

# Load the data:

ml <- read.csv("Data/machine_learning_example_data.csv")
summary(ml)

# BASE-R: 
# 
# (1) Make a basic, but good quality, plot.

plot(ml$freqLabel, ml$f1, xlim = c(0,1), ylim = c(0,1), pch = 16,
     main = "Classifer Performance as a Function of Label Usage",
     xlab = "Proportion of Data using Label", ylab = "F1 Score")

# Notice the boundary (floor/ceiling) effects present on the left edge
# of the data region, and the fact that the data does not seem to go
# below the y = x diagonal line. This is an artifact of the data we
# are using. Let's say we wish to highlight this feature.
#
# (2) Explore the diagonal effect.
#
# If we want to look at the diagonal, we can add a y = x line. To do
# this we use the R function abline(a,b) to draw the line. You enter
# the equation of the line's coefficients to the function. The line we
# want is the line y = x which in y = a + bx form is: y = 0 + 1x (so
# we have, a = 0; b = 1):

abline(a = 0, b = 1, col = "red", lwd = 2)

# I think that lines look better at a width greater than 1, so I set
# "lwd" to 2. You should be comfortable with color setting by now. We
# can see that the points are all (within rounding) above this line.
#
# (3) Add plot regions.
#
# To look at the data, the original plot, or maybe the one with the
# diagonal, is sufficient. But we would like to draw the readers
# attention to the regions defined by both good algorithm performance
# (y-axis F1 scores > 0.40) and regions defined by high proportions of
# terminology usage (x-axis proportions above 0.60).
#
# We start by redrawing a clean version of the original plot, then we
# use special versions of abline() to add the regions. Note that as a
# general rule, you redraw plots by simply re-running the plot
# commands.

plot(ml$freqLabel, ml$f1, xlim = c(0,1), ylim = c(0,1), pch = 16,
     main = "Classifer Performance as a Function of Label Usage",
     xlab = "Proportion of Data using Label", ylab = "F1 Score")

abline(v = 0.6, lwd = 2, col = "red")  # v for vertical line at x = 0.6
abline(h = 0.4, lwd = 2, col = "red")  # h for horizontal line, y = 0.4

# So we have four regions. To label them we use the text() function in
# R. We give x and y coordinates, followed by the text we want. The
# weird looking "\n" (backslash-en) puts a new line in between the
# text. Note that the x and y coordinates chosen for the labels were
# picked by eye. You can do that if you like, or you could just as
# easily base the positions on some mathematical feature of the data.

text(0.825, 0.65, "Easy:\nGood Scores, Many Examples")
text(0.3, 0.85, "Algorithm Success:\nGood Scores, Fewer Examples")
text(0.3, 0.2, "Hard:\nToo Few Examples")
text(0.825, 0.2, "Impossible:\nMathematically this cannot happen!")


# Example 2: Simple histogram with labels
#
# This example plots a histogram with some markup. We use the count
# data from the same file loaded above.

termUsage <- ml$numTexts  # counts of how many documents use each term

hist(termUsage, main = "How many documents use each term?", 
     xlab = "Number of documents", ylab = "Count", col = "gray")

# Mark regions of interest and label them

abline(v = 1000, col = "red", lwd = 3)
text(1750, 20, "Common Terms")
text(700, 20, "Less Common\nTerms")

# Add an arrow and an additional label.
#
# The arrow is specified by starting and ending points. The x0 and y0
# coordinate is the start point, and the x1 and y1 coordinates are the
# ending point. The length = 0.15 sets the length of the arrowhead's
# lines.

arrows(x0 = 400, y0 = 42, x1 = 100, y1 = 30, length = 0.15, lwd = 3)
text(615, 42.5, "Hard to Classify")

# Note that this uses "base R" graphics and there are additional
# packages you can add to R that do this, possibly with better
# quality. See:
#
# http://bookdown.org/ndphillips/YaRrr/low-level-plotting-functions.html
# 
# and
# 
# http://www.countbio.com/web_pages/left_object/R_for_biology/R_fundamentals/draw_inside_plot_R.html
#
# for some details of doing these things in base R. You may also want
# to check out the "Shape" package:
#
# http://www.rdocumentation.org/packages/shape/versions/1.4.4
#
# for more advanced tools for making shape based annotation on plots
# in base R. 
# 
# Publication Quality Output
# 
# To end this example we will make a PDF version of the figure. To get
# the details of this process, see the file "publication_graphics.R"
# included with this workshop.

# Set the output "device" to make a PDF:

pdf("base_r_hisotgram_example.pdf", width = 8, height = 5)

# Redo the whole plot again. Note that when I looked at the PDF the
# coordinates of the arrow and the locations of the text were a little
# off, so I adjusted the coordinates a little bit. Again, this was
# done iteratively, by eye, until I was satisfied.

hist(termUsage, main = "How many documents use each term?", xlab = "Number of documents", ylab = "Count", col = "gray")
abline(v = 1000, col = "red", lwd = 3)
text(1750, 20, "Common Terms")
text(700, 20, "Less Common\nTerms")
arrows(x0 = 600, y0 = 41, x1 = 100, y1 = 25, length = 0.15, lwd = 3)
text(630, 42.5, "Hard to Classify")

# Write the PDF file to the hard disk:

dev.off()

# Look at the PDF file generated. As I mentioned above it has been
# tweaked a little bit by simply remaking the figure a few times and
# adjusting the locations of the arrow and the text.
#
# Notice also that it looks better than the examples shown inside of
# RStudio. It is important to look directly as the graphics placed in
# files; their corresponding versions in RStudio will always look
# different!



# Some ggplot Examples
#
# ggplot allows a lot of kinds of annotation as well, here are a few
# simple examples. For more examples see Chang's _R Graphics Cookbook_
# mentioned in the slide presentation. There are also many examples
# online. Some examples are at:
#
# http://r-statistics.co/Complete-Ggplot2-Tutorial-Part2-Customizing-Theme-With-R-Code.html
#
# and one detailed example at:
# 
# http://www.r-bloggers.com/how-to-annotate-a-plot-in-ggplot2/
# 
# which we will use here.

library(ggplot2)

# ggplot Example 1: Histogram
# 
# GGPLOT: We know how to do a histogram already. We will use the "Old
# Faithful" geyser data included with R:

data(faithful)
summary(faithful)

# Eruptions is the eruption time of the geyser, and waiting is the
# waiting time in between eruptions. There is a pattern in the data
# that shows that longer waiting times result in bigger (longer)
# eruptions.

g <- ggplot(aes(x = eruptions), data = faithful) + 
  geom_histogram(color = "black", fill = "gray70") 
g

# Let's emphasize the break between the two piles of data:

g <- ggplot(aes(x = eruptions), data = faithful) + 
  geom_histogram(color = "black", fill = "gray70") + 
  geom_vline(xintercept = 3.15, color = "red", lwd = 1.2)
g

# And let's add some text:

g <- ggplot(aes(x = eruptions), data = faithful) + 
  geom_histogram(color = "black", fill = "gray70") + 
  geom_vline(xintercept = 3.14, color = "red", lwd = 1.2) +
  annotate("text", label = "Longer Wait Time", x = 3.8, y = 20, 
           color = "red") +
  annotate("text", label = "Shorter Wait Time", x = 2.5, y = 20,
           color = "red")
g

# ggplot allows a lot of manipulation of the text with parameters:

g <- ggplot(aes(x = eruptions), data = faithful) + 
  geom_histogram(color = "darkred", fill = "gray70") + 
  geom_vline(xintercept = 3.14, color = "darkred", lwd = 1.2) +
  annotate("text", label = "Longer Wait Time", x = 3.8, y = 20, 
           color = "darkred", family = "serif", fontface = "italic",
           size = 6) +
  annotate("text", label = "Shorter Wait Time", x = 2.5, y = 20,
           color = "darkred", family = "serif", fontface = "italic",
           size = 6)
g

# ggplot Example 2: Scatterplot
# 
# We use the geyser data again:

g <- ggplot(aes(x = waiting, y = eruptions), data = faithful) +
  geom_point()
g

# We can split this on the medians:

g <- ggplot(aes(x = waiting, y = eruptions), data = faithful) +
  geom_point() + 
  geom_vline(xintercept = median(faithful$waiting), color = "red") +
  geom_hline(yintercept = median(faithful$eruptions), color = "red")
g

# Notice that the medians do not adequately show the bounds of the two
# "clumps" of data. Maybe the means do better:

g <- ggplot(aes(x = waiting, y = eruptions), data = faithful) +
  geom_point() + 
  geom_vline(xintercept = mean(faithful$waiting), color = "red") +
  geom_hline(yintercept = mean(faithful$eruptions), color = "red")
g

# Certainly better! We can add text to any location using the
# annotate() function from the previous example. I will leave this to
# you to experiment with on your own.
#
# ggplot Example 3: Math
#
# This is getting a bit advanced, but ggplot can show math in its
# annotations, too. To be fair, so can base R graphics, but there it
# is a little harder to do. This final example is harder than the rest
# of them, so if it is too much, you can skip it for now.
#
# The first plot below is a collection of tricks to make ggplot show
# the normal curve. Don't worry about the details, but if you care,
# all we did was make a "fake" data frame to hold two numbers x = -3
# and x = 3. This is the range of the output normal curve.

p <- ggplot(aes(x = x), data = data.frame(x = c(-3,3))) +
  stat_function(fun = dnorm)
p

# Here is a mathematical label. We tell annotate() to "parse" the math
# (by setting "parse = TRUE").

p <- ggplot(aes(x = x), data = data.frame(x = c(-3,3))) +
  stat_function(fun = dnorm) + 
  annotate("text", x = 1.75, y = 0.3, parse = TRUE, size = 8,
           label = "frac(1,sqrt(2 * pi)) * e^{-x^2/2}")
p

# EOF