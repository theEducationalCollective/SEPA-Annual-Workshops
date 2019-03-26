# Example Solutions for Exercises
# 
# Presented @ SEPA 2019 Annual Meeting 
# Workshop: Graphics in R for Research and Publication
#
# Matthew D. Turner 
# Georgia State University 
# mturner46@gsu.edu
#
# 2019.03.22

# These are example solutions, yours may be different and still be
# right! Keep that in mind.
#
# Good luck!

library(ggplot2)
library(gcookbook)

small_diamonds <- read.csv("Data/small_diamonds.csv")

# 1a. Bar chart of cut

ggplot(data = small_diamonds, aes(x = cut)) + geom_bar()

# 1b. Bar chart of color

ggplot(data = small_diamonds, aes(x = color)) + geom_bar()

# 1c. Bar chart of carat (note this is NOT good!)

ggplot(data = small_diamonds, aes(x = carat)) + geom_bar()

# Un-numbered example: I asked you to do to break geom_bar for state
# data:

changedata <- subset(uspopchange, rank(Change) >= 40) # Load data

ggplot(data = changedata, aes(x = Abb)) + geom_bar()

# What happens is that by default geom_bar() counts the number of
# values for each state (as is usual in a bar chart) and then reports
# that each state has one value. This is true, there is one line in 
# the data set per state! :-)

# 1d. Add color (fill!) to states data

ggplot(data = changedata, aes(x = Abb, y = Change, fill = Region)) +
  geom_bar(stat = "identity")

# 1e. For the full uspopchage data set, with order to make it look
# nicer:

ggplot(data = uspopchange, aes(x = reorder(Abb, Change), y = Change, fill = Region)) +
  geom_bar(stat = "identity")

# 1f. Faceted state population change data. Here are two solutions and
# the not so great plot you likely got on your first try. First, the
# not so great plot based on the examples from the "milk" data:

ggplot(data = uspopchange, aes(x = reorder(Abb, Change), y = Change)) +
  geom_bar(stat = "identity") + facet_wrap(~Region)

# The first proper solution is how you would likely do it based on the
# examples earlier in the workshop, and uses the new instruction given
# in the question:

ggplot(data = uspopchange, aes(x = reorder(Abb, Change), y = Change)) +
  geom_bar(stat = "identity") + facet_wrap(~Region, scales = "free")

# The second version of this below is how you can do it if you looked
# up vars() and understood the explanation (if you skipped this or
# don't like it, just move on, it is not a big deal):

ggplot(data = uspopchange, aes(x = reorder(Abb, Change), y = Change)) +
  geom_bar(stat = "identity") + facet_wrap(vars(Region), scales = "free")

# 1g. Waiting time for Old Faithful

data(faithful)

ggplot(data = faithful, aes(x = waiting)) + geom_histogram()

# 2a. Convert previous to density plot:

ggplot(data = faithful, aes(x = waiting)) + geom_density()

# 2b. Birthweight versus smoking of mother

bwd <- MASS::birthwt
bwd$smoke <- factor(bwd$smoke) 

ggplot(data = bwd, aes(x = bwt, fill = smoke)) + 
  geom_density(alpha = 0.4)

# Tweaked x limits:

ggplot(data = bwd, aes(x = bwt, fill = smoke)) + 
  geom_density(alpha = 0.4) + 
  xlim(0, 5500)

# 3a. Height as a function of age:

data(heightweight)

ggplot(data = heightweight, aes(x = ageYear, y = heightIn, color = sex)) +
  geom_point()

# 3b. Change sex to shape, not color:

ggplot(data = heightweight, aes(x = ageYear, y = heightIn, shape = sex)) +
  geom_point()

# 3c. Solution is in the exercises since my example IS a solution. :-)

# 3d. Make a plot with too much going on! color/shape for sex and group:

hw <- heightweight
hw$weightGroup <- cut(hw$weightLb, breaks = c(-Inf, 100, Inf), labels = c("< 100", ">= 100"))

ggplot(data = hw, aes(x = ageYear, y = heightIn, shape = sex, color = weightGroup)) +
  geom_point(size = 4)

# Note that I manually set the size to make it look a litter better.
# 
# 3e. Add sex via color:

ggplot(data = hw, aes(x = ageYear, y = heightIn, size = weightLb, color = sex)) +
  geom_point(alpha = 0.50)

# 4a. 

ggplot(data = tg, aes(x = dose, y = length, color = supp)) + 
  geom_line()

# 4b. Add points

ggplot(data = tg, aes(x = dose, y = length, color = supp)) + 
  geom_line() +
  geom_point()

# 4c. Change color to linetype

ggplot(data = tg, aes(x = dose, y = length, linetype = supp)) + 
  geom_line() +
  geom_point()

# 4d. Color and linetype for supp:

ggplot(data = tg, aes(x = dose, y = length, linetype = supp, color = supp)) + 
  geom_line() +
  geom_point()

# Please experiment with the solutions. All learning will come by
# trying things, breaking things, and looking for help to sort things
# out.
#
# Search engines can give you lots of advice on making different types
# of plots.

# EOF