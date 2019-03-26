# Exporting Graphics and Figures for Print and Publications
#
# Presented @ SEPA 2019 Annual Meeting 
# Workshop: Graphics in R for Research and Publication
#
# Matthew D. Turner 
# Georgia State University 
# mturner46@gsu.edu
#
# 2019.03.22

# Making graphics for publications is a matter of (1) good graphic
# design, (2) resolution and size, and (3) getting the file format the
# journal requires. In a short workshop we cannot cover the nuances of
# graphic design, but we can give you all you need of (2) and (3), as
# R makes these relatively easy to do.
#
# Here are some online links for more information:
#
# 1. https://nicercode.github.io/guides/plotting/ 
# 2. https://www.r-bloggers.com/high-resolution-figures-in-r/ 
# 3. http://blog.revolutionanalytics.com/2009/01/10-tips-for-making-your-r-graphics-look-their-best.html
# 
# There is also a lot more information online that is easy to find

# Setup

library(ggplot2)


# Part 1 -- General figure export with the 3 step procedure


# A. Example Base R Graphics Figure
#
# This method works for base R graphics and also for ggplot2 made
# graphics. We will focus on base R graphics at first and move on to
# ggplot2 made graphics at the end.
#
# Let's start with a simple example figure. We will use this
# throughout the first few examples.
#
# This how you probably make this figure in R already:

data(mtcars)                # data on cars and their efficiency
plot(mtcars$wt, mtcars$mpg) # miles per gallon as a function of weight

# We can fix this up with some color and change the symbols plotted to
# solid dots to see more easily:

plot(mtcars$wt, mtcars$mpg, pch = 16, col = "darkblue")

# And if we intend to publish this figure we had better add proper
# axis labels and a title. We will also switch to a gray color for B/W
# printing because journals are all still paper. :-)

plot(mtcars$wt, mtcars$mpg, pch = 16, col = "gray20",
     main = "Mileage as a function of car weight",
     xlab = "Car Weight (1000's lbs.)",
     ylab = "Miles Per Gallon (MPG)")


# B. RStudio Export
#
# If we try to export this for use in a publication it will look
# terrible when we import it to a document or manipulate it. See the
# Powerpoint/PDF presentation included with the workshop materials
# called "working_with_graphics_in_Microsoft_Office" for examples of
# these types of problems.
#
# Example: export from RStudio. This is done in RStudio by using the
# export item on the menu bar in the plot pane. You can try this
# yourself (if you do, check where the image gets saved!!). Export
# from RStudio is acceptable for drafts and day to day work, **if you
# insist on using a mouse click**, but should never be used for
# publications. Personally, I never use it for anything and don't
# recommend it for anyone.


# C. Exporting Publication Quality Graphs Vector Graphics Formats
#    The 3-Step Procedure
#
# Sending figures to files in various formats is not particularly
# hard. You have to do a three step procedure that is basically the
# same each time. The only change, for each different type of file, is
# the first command in the three step procedure. This command will be
# the name of a file type: pdf(), png(), svg(), and so on.
#
# Make sure to do ALL 3 steps!
#
# *** PDF ***
# 
# For the first example we will make a PDF figure. PDFs are a vector
# format that are very useful for publishing.
#
# Step 1 - Open a "pdf" device (width and height are in INCHES):

pdf("mileage.pdf", width = 6, height = 4)

# Step 2 - Make the plot (again):

plot(mtcars$wt, mtcars$mpg, pch = 16, col = "gray50",
     main = "Mileage as a function of car weight",
     xlab = "Car Weight (1000's lbs.)",
     ylab = "Miles Per Gallon (MPG)")

# Step 3 - Close the device:

dev.off()

# Always close off the device or the file on your hard drive will be
# corrupt and not work. This is critical!
#
# If you open this figure and view it, you will see that it looks MUCH
# nicer than the export from RStudio. When making vector figures, R
# changes the proportions and that improves things dramatically. If
# you want specific proportions, there are adjustible settings for all
# of them. Mostly set with the par() function.
#
# PDFs are sometimes required by journals. The main feature of PDFs is
# that they are **vector graphics**, that is, they do not require
# ideas like resolution or dots-per-inch. Instead, you set the
# absolute size (in inches or centimeters) and they come out at that
# size. They can also be made in a way that lets their size be
# adjusted. These are different from bitmap graphics (like PNG or
# JPEG) in that you are not saving a picture, you are instead saving a
# high-level description of the picture. The program that shows the
# image to you builds the image from the description.
#
# *** SVG ***
#
# For nice plots on the web, SVG's (another vector format) are often
# better. Note the **3** steps are used here as well, but we won't
# highlight each of them this time:

svg("mileage.svg", width = 6, height = 4)
plot(mtcars$wt, mtcars$mpg, pch = 16, col = "gray50",
     main = "Mileage as a function of car weight",
     xlab = "Car Weight (1000's lbs.)",
     ylab = "Miles Per Gallon (MPG)")
dev.off()

# Most browsers can open SVG files. If you open this file in a
# browser, you can use the browser's zoom function to see how this
# looks at various sizes. The quality depends, however, on how the
# browser renders the image. So there may be differences between
# different browsers.
#
# *** Changing/Modifying Units in PDFs ***
#
# To change units to centimeters you can use the cm() function. This
# returns a number of centimeters for a given number of inches:

cm(1)   # = 2.54 cm; the number of centimeters in 1 inch

# So we can use cm(1) to convert centimeters to inches:

10/cm(1)   # 10 cm, divided by 2.54 cm/inch is 3.937 inches

# We can do this math right in the pdf() function itself, in the
# height and width parameters. Here is a 10 cm x 10 cm square version
# of the figure above:

pdf("mileage_10cm_square.pdf", width = 10/cm(1), height = 10/cm(1))
plot(mtcars$wt, mtcars$mpg, pch = 16, col = "gray50",
     main = "Mileage as a function of car weight",
     xlab = "Car Weight (1000's lbs.)",
     ylab = "Miles Per Gallon (MPG)")
dev.off()

# Not a pretty figure, but it shows how to resize in centimeters.


# D. Exporting Publication Quality Graphs Bitmap Graphics Formats The
# 3-Step Procedure
#
# Generally you want to use vector graphics files for publication
# quality work. However, on occsion you will have need to make
# high-resolution bitmap figures. My advice is to **avoid this
# whenever possible**! Most journals do have some option for vector
# graphics and you should contact them if it is not clear what they
# want. But, if you must use bitmap graphics here is how to make
# higher-resolutuon figures that will look good in publications.
#
# *** WMF ***
# 
# To make high quality plots for use in Microsoft Word, Powerpoint,
# etc., some people use Windows MetaFiles (WMF; called with the
# win.metafile function in R). Note that I do not prefer these files
# to other options. See the included Powerpoint file that shows the
# problems with WMF: "working_with_graphics_in_Microsoft_Office.pptx".
#
# The following should run on Windows systems. The "win.metafile"
# function will not exist on Macs and Linux systems so skip this
# example on Mac or Linux computers. Note the usual 3 steps again:

win.metafile("mileage.wmf", width = 6, height = 4)
plot(mtcars$wt, mtcars$mpg, pch = 16, col = "gray50",
     main = "Mileage as a function of car weight",
     xlab = "Car Weight (1000's lbs.)",
     ylab = "Miles Per Gallon (MPG)")
dev.off()

# *** PNG ***
#
# Here is the same figure as a PNG (Portable Network Graphics) file.
#
# Note that the sizes are now in PIXELS!
#
# PNG is basically the same format as GIF if you are familiar with
# those. This first figure is not so good.

png("mileage_072dpi.png", width = 600, height = 400)
plot(mtcars$wt, mtcars$mpg, pch = 16, col = "gray50",
     main = "Mileage as a function of car weight",
     xlab = "Car Weight (1000's lbs.)",
     ylab = "Miles Per Gallon (MPG)")
dev.off()

# The figure we just made will be at the default dot density of 72 DPI
# or dots per inch.
#
# For changing the dots per inch (also called PPI or points per inch
# by some journals) we can have R do the math. Here we make the same
# figure we have been making (6" wide, 4" high) so we multiply the
# inches by the dpi, and we set the resolution to the dpi value. You
# can modify the numbers to get any combination of dpi and size you
# require.

dpi <- 300
png("mileage_300dpi.png", width = 6*dpi, height = 4*dpi, res = dpi)
plot(mtcars$wt, mtcars$mpg, pch = 16, col = "gray50",
     main = "Mileage as a function of car weight",
     xlab = "Car Weight (1000's lbs.)",
     ylab = "Miles Per Gallon (MPG)")
dev.off()

# In the next figure we change only one thing: the value of the dpi in
# the first line!

dpi <- 600
png("mileage_600dpi.png", width = 6*dpi, height = 4*dpi, res = dpi)
plot(mtcars$wt, mtcars$mpg, pch = 16, col = "gray50",
     main = "Mileage as a function of car weight",
     xlab = "Car Weight (1000's lbs.)",
     ylab = "Miles Per Gallon (MPG)")
dev.off()

# For figures PNG is a good bitmap option. However, you can make JPEGs
# (AKA JPG), also. JPEG figures are compressed using a "lossy"
# algorithm, which means that the images will be degraded a bit to
# save space on your computer's storage. However, by setting the dpi
# to a high number it will not look very degraded.

dpi <- 600
jpeg("mileage_600dpi_lossy.jpg", width = 6*dpi, height = 4*dpi, res = dpi)
plot(mtcars$wt, mtcars$mpg, pch = 16, col = "gray50",
     main = "Mileage as a function of car weight",
     xlab = "Car Weight (1000's lbs.)",
     ylab = "Miles Per Gallon (MPG)")
dev.off()

# There are a variety of ways to specify bitmap figures that you will
# learn about if you look online. For some reason, the png() function
# takes a parameter for figure size UNITS (but the pdf() and svg()
# functions do not!).
#
# So we can also specify a figure as follows, here with a 20 cm x 10
# cm size:

dpi <- 600
png("mileage_600dpi_20cm_by_10cm.png", width = 20, height = 10,
    units = "cm", res = dpi)
plot(mtcars$wt, mtcars$mpg, pch = 16, col = "gray50",
     main = "Mileage as a function of car weight",
     xlab = "Car Weight (1000's lbs.)",
     ylab = "Miles Per Gallon (MPG)")
dev.off()

# Again, not a great figure, but it shows how to use centimeters in
# the png() function.


# E. Using the 3-Step Procedure with ggplot
# 
# *** PDF from ggplot ***
# 
# If we want to use this 3-step procedure with ggplot, the only change
# is to use a print() function for the plot we made. Here is the code
# for the plot we started with in the other file:

small_diamonds <- read.csv("Data/small_diamonds.csv")
pvc <- ggplot(aes(x = carat, y = price), data = small_diamonds) +
  geom_point(aes(color = cut))
pvc

# To save this to a PDF, we do the same 3 step procedure as above,
# with one change: we use the print function on the name we gave the
# plot:

pdf("diamonds_ggplot.pdf", width = 8, height = 6)  # Step 1
print(pvc)                                         # Step 2
dev.off()                                          # Step 3



# Part 2 -- ggplot2 Figure Export with ggsave
#
# There is an even easier way to save plots from ggplot, and this is
# to use the ggsave command. This command will, by default, save the
# most recent plot made using ggplot. Here we will use the other
# simple example from the other file:


mpg_plot <- ggplot(aes(x = wt, y = mpg), data = mtcars) + 
  geom_point() + labs(y = "Miles per Gallon") + 
  labs(x = "Car Weight (1000's of lbs.)") + 
  labs(title = "ggplot Example Figure")


mpg_plot

ggsave("mpg_ggplot.pdf", width = 16, height = 8, units = "cm")


# Final Notes:
#
# Remember that publishers will have requirements that you have to
# follow. They may want a bitmap format (PNG, JPEG/JPG) or a vector
# format (PDF, SVG) and they will have recommended sizes and
# resolution, although they may not use the terminology we use here.
#
# Please note also that additional file formats are available: the two
# most common ones we have not mentioned are TIFF and EPS
# (encapsulated postscript). The former is made with the tiff()
# function, and the latter, being a kind of postscript, is made with
# the postscript command: postscript("filename.eps", ...) -- notice
# that the EPS is specified by the filename ending in the ".eps"
# extension.
#
# Finally, we have focused on using the ggplot and base R graphics
# defaults for many things, such as the sizes of the margins, text
# sizes, most of the symbol and other sizes, etc. All of these things
# are adjustable so if you do not like the defaults, you can change
# them. Usually searching online for the feature you want to change
# plus the keywords "r" and "ggplot" will get you relevant
# information. Good luck!

# EOF