# Workshop Part 3.0
# Intro to linear modeling in R
# Jessica & Matthew Turner, March 2019

library(car)
library(lme4)

#install.packages("effects")
library(effects)

duncan=read.table("Data/Duncan.txt", header=TRUE)

# We've worked with lm() a bit now, but let's review--see the modeling
# language overview! Note the full parameterization of lm()

?lm

# lm(formula, data, subset, weights, na.action, method = "qr", model =
# TRUE, x = FALSE, y = FALSE, qr = TRUE, singular.ok = TRUE, contrasts
# = NULL, offset, ...)
# formula and data we've discussed
# subset is probably best to avoid--use subset() to create a new dataset to
# analyze first
# na.action is what to do in case of missing data
# For the options after that, you're on your own.

# consider this

mod.1 = lm(duncan$prestige ~ duncan$type)
mod.2 = lm(prestige ~ type, data = duncan)
mod.3 = aov(prestige ~ type, data = duncan)
mod.4 = aov(prestige ~ type + income, data = duncan)

# do they give different models? does summary() treat them the same?


# use aov() and anova() to get the more usual F table:
anova(mod.2)
anova(mod.3)
anova(mod.1)


# the difference between anova() and Anova()
anova(mod.2)
Anova(mod.2)  # Anova is from the car() package

# anova by default gives the Type I sums of squares
# Anova by default gives Type II and will give Type III if forced
# This is not an issue for balanced data or where interactions are not significant
# but when there are interactions, it's recommended to use Type III

# let's reload the stress-relief data since that had an interaction
stress=read.csv("Data/dataset_anova_missing.csv", header=TRUE)
summary(stress)

# run the defaults
mod.5 = lm(StressReduction ~ Treatment*Gender, data=stress)
Anova(mod.5)

# now try it with Type III SS
mod.6 = lm(StressReduction ~ Treatment*Gender, data=stress,
           contrasts=list(Treatment=contr.sum, Gender=contr.sum))
Anova(mod.6, type="III")

# try a summary() on both models and see what you think!

# useful for plotting output
plot(predictorEffects(mod.6))
plot(predictorEffects(mod.5))

# Within subjects analyses
# these all come from https://personality-project.org/r/r.guide/r.anova.html

# Ex1 -- one way repeated measures:
# load it into a variable
Memtest = read.csv("Data/One-wayWithinSub.csv", header=TRUE)
head(Memtest)
summary(Memtest)

# you can see from the summary there are 5 subjects, 3 levels of
# stimulus valence, and a Recall score 
# this is one factor, all within subjects

mem.mod = aov(Recall ~ Valence + Error(Subject/Valence), data=Memtest)

summary(mem.mod) # what is the output?

boxplot(Recall ~ Subject*Valence, data=Memtest, ylab="Recall")
# handy trick to see factor means
print(model.tables(mem.mod, "means"))

# note that lmer() from the lme4 library can do the same thing

mem.lm = lmer(Recall ~ Valence + (1|Subject), data=Memtest)

summary(mem.lm)  # note the differences here! the model is listed at the top...
Anova(mem.lm)  # this only shows the fixed effects output, and it's type II by default
Anova(mem.lm, type="III", test.statistic="F")


print(model.tables(mem.lm, "means")) # now this doesn't work
plot(Effect("Valence", mem.lm))  # but this does!

# Ex2 --two way repeated measures:
# load it into a variable and take a look at it

CuedRecall=read.csv("Data/Two-wayWithinSub.csv", header=TRUE)
head(CuedRecall)
summary(CuedRecall)

# different ways to look at the data--plot() is fairly smart about it

boxplot(Recall~Task*Valence, data=CuedRecall)

plot(Recall~Task*Valence*Subject, data=CuedRecall)


# Now there are two factors: Cued vs Free (recall), as well as Valence
# let's fit the full model including interactions

mem2.mod = aov(Recall ~ (Task*Valence) + Error(Subject/(Task*Valence)), data=CuedRecall)
summary(mem2.mod) #look at how the output is organized!


# how to set this up with lmer()?

mem2.lm = lmer(Recall ~ Task*Valence + # error is more complex
                 (1|Subject)+(1|Task:Subject)+(1|Valence:Subject),
               data = CuedRecall)
summary(mem2.lm)
Anova(mem2.lm, test.statistic="F") # compare with the summary of mem2.mod

# Mixed model: both within and between subjects factors
Mixed = read.csv("Data/MixedEffects.csv", header=TRUE)

# how many unique subjects does it have?
levels(Mixed$Subject)
length(levels(Mixed$Subject))

# this dataset has 18 subjects, 9 male and 9 female
# Each was assigned one of three possible medication dosages (A-C)
# Each performed free and cued recall with pos/neutral/neg words
summary(Mixed)

# what are the between subject factors and what are the within subject factors?


# let's see what it looks like

plot(Recall~(Task*Valence*Gender*Dosage*Subject), data=Mixed)

# How do we set up the model? Let's say we want it fully crossed--

# the real question is how to set up the error term
mixed.mod = aov(Recall~(Task*Valence*Gender*Dosage)  # all the factors
                + Error(Subject/(Task*Valence))+(Gender*Dosage),
                data=Mixed)
summary(mixed.mod)
print(model.tables(mixed.mod, "means"))

# how to set it up lmer()
mixed.lm=lmer(Recall~(Task*Valence*Gender*Dosage) +
              (1|Subject)+(1|Task:Subject)+(1|Valence:Subject),
            data=Mixed)

Anova(mixed.lm, test.statistic="F") # again, compare with the aov() version

# end of this workshop!
