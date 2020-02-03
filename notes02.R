# Graphs are one of the most important aspects of presentation and analysis of data, because 
# they help reveal structure and patterns. In this lecture we revisited graphs that should be
# familiar to you already, while seeing them through the lense of the 'grammar of graphics', a 
# framework developed by Leland Wilkinson. It allows for a systematic approach to creating any 
# kind of plot with any kind of data. The idea: a certain set of rules underlies all graphics, 
# similar to grammar as the set of rules that combines verbs, nouns, adjectives etc. to 
# sentences. Similarly, plots are being constructed by adding grammatical elements together.

# Every graph has seven defining elements, three of which are most important: 
# - data (the dataset that is being plotted)
# - aesthetics (the scales onto which we 'map' our data)
# - geometries (the visual elements use for the graph)
# The remaining elements are optional and control the details of the plot (facets, 
# statistics, coordinates, and themes).

# The grammar of graphics is implemented in R in the ggplot2 package, which is part of the 
# tidyverse package we installed last time.
library(tidyverse)

# Its main function is ggplot(), which requires at the minimum two arguments: a data frame 
# whose variables we want to plot, and a description of the relationship of each variable 
# with a visual element in the graph. The latter requires an additional function, aes(), which 
# is short for 'aesthetic mappings'. Conceptually these refer to relationships between variables 
# of the given data frame, and a visual aspect of your plot that is going to convey the 
# information (e.g. the values of the x-axis and y-axis, color fillings, shapes, etc.)

# As mentioned before, the basic 'ingredient' to a graph is the data in form of a 
# data.frame. We will use titanic data set from before.
load(url("https://git.io/JvGIH"))

# One of the most basic plots is called a 'bar' or 'column plot'. It contains two 
#   or more categories along one axis and a series of bars - one for each 
#   category - along the other axis. The length of the bar represents the magnitude 
#   of the measure for each category. The scale of the 'measurement' axis is usually 
#   absolute (as compared to relative or in percentages).

# In the language of the 'grammar of graphics', we are simply mapping a categorical 
#   variable of our choice along the $x$-axis, and choose a bar geometry.

###       data    +  aesthetic mapping   +    geometry ###
ggplot(data = titanic, mapping = aes(x = Pclass)) + geom_bar()

# This completes a very basic plot, that can be further polished. For instance, we 
#   could modify the labels on each axis.
ggplot(titanic, aes(x = Pclass)) + geom_bar() +
    labs(x = "Ticket class", y = "Number of passengers")

# Turning this into a bar chart requires nothing but a flip of the axis. This is 
#    done by adding coord_flip() to the plot.
ggplot(titanic, aes(x = Pclass)) + geom_bar() +
    labs(x = "Ticket class", y = "Number of passengers") +
    coord_flip()

# Since upper class should naturally be on top, we can reverse the order with fct_rev()
ggplot(titanic, aes(x = fct_rev(Pclass))) + geom_bar() +
    labs(x = "Ticket class", y = "Number of passengers") +
    coord_flip()
# For more details on factor reordering: https://r4ds.had.co.nz/factors.html#modifying-factor-order

# We could convey more information in this plot. For instance, we could decompose
#   each class by gender. And we would like to do so by splitting each column in two:
ggplot(titanic, aes(x = fct_rev(Pclass), fill = Sex)) + geom_bar() +
    labs(x = "Ticket class", y = "Number of passengers") +
    coord_flip()

# Rather than filling, we could also place separate bars next to each other
ggplot(titanic, aes(x = fct_rev(Pclass), fill = Sex)) + geom_bar(position = "dodge") +
    labs(x = "Ticket class", y = "Number of passengers") +
    coord_flip()

# Next, we could drill down deeper by spliting the data by port of embarkation. The 
#   function facet_wrap() splits the plot into four panels (one for each level of 
#   Embarked)
ggplot(titanic, aes(x = fct_rev(Pclass), fill = Sex)) + geom_bar(position = "dodge") +
    labs(x = "Ticket class", y = "Number of passengers") +
    coord_flip() +
    facet_wrap(~Embarked)

# It might be better to interchange Sex and Embarked
ggplot(titanic, aes(x = fct_rev(Pclass), fill = Embarked)) + geom_bar(position = "dodge") +
    labs(x = "Ticket class", y = "Number of passengers") +
    coord_flip() +
    facet_wrap(~Sex)

# There are plenty of more ways to customize the graph. For instance, one could
#   change the color scheme.
ggplot(titanic, aes(x = fct_rev(Pclass), fill = Embarked)) + geom_bar(position = "dodge") +
    labs(x = "Ticket class", y = "Number of passengers") +
    coord_flip() +
    facet_wrap(~Sex) +
    scale_fill_manual(values = c("orange", "skyblue", "firebrick", "black"))

# Or we can change the theme entirely
ggplot(titanic, aes(x = fct_rev(Pclass), fill = Embarked)) + geom_bar(position = "dodge") +
    labs(x = "Ticket class", y = "Number of passengers") +
    coord_flip() +
    facet_wrap(~Sex) +
    scale_fill_manual(values = c("orange", "skyblue", "firebrick", "black")) +
    theme_dark()

# The important part is to observe that the entire description of the plot follows
#   some grammatical rules. And with these rules in mind, we can think of describing
#   a different kind of plot: a pie chart.
#   Pie charts are circular depictions of proportions of some categorical variable.
#   They are widely used in business, often depicting such things as budget 
#   categories (also in the news media, to depict voting percentages)
#   You find them used very often in science, because they are rather inaccurate and
#   hard to decode (in particular if some categories are too small)
#   If you were to construct them by hand, how would you do it?
#   (i)  determine the proportions in each level of the categorical variable
#   (ii) translate this proportion to an angle of a circle

ggplot(titanic, aes(x = "", fill = Pclass)) +
    geom_bar(width = 1)

# This created a bar chart with a single column, but filled according to the 
#    categories of Pclass. Next, we need to wrap the y-axis around a polar
#    coordinate system

ggplot(titanic, aes(x = "", fill = Pclass)) +
    geom_bar(width = 1) +
    coord_polar(theta = "y")

# We can further refine the plot by detailing the coordinate axis around the pie.
ggplot(titanic, aes(x = "", fill = Pclass)) +
    geom_bar(width = 1) +
    coord_polar(theta = "y") +
    scale_y_continuous(breaks = seq(0, 1000, by = 100))

# In general, pie charts should be avoided in favor of bar charts.

### Two-variable plots
#
# Scatter plot
# two-dimensional graph of points from two numerical variables; most often used 
#   in science to illustrate relationship between variables

# To illustrate, use the beer data set from last time
beer <- read.csv("https://git.io/JvGIN")
# Remember how to fix the misclassification of the gender variable?
beer <- mutate(beer, gender = factor(gender, levels = c(0, 1), labels = c("male", "female")))

# Again: a basic plot, but this time with x and y variables. Also, the geometry 
#    employed now are points, i.e. geom_point()
ggplot(beer, aes(x = weight, y = height)) + geom_point()

# Lets add better labels
ggplot(beer, aes(x = weight, y = height)) + geom_point() +
    labs(x = "Weight (in pounds)", y = "Height (in inches)")

# Drill deeper by splitting this by gender
ggplot(beer, aes(x = weight, y = height, color = gender)) + geom_point() +
    labs(x = "Weight (in pounds)", y = "Height (in inches)")

# Control the size of points by average beer consuption
ggplot(beer, aes(x = weight, y = height, color = gender, size = nbeer)) + geom_point() +
    labs(x = "Weight (in pounds)", y = "Height (in inches)")

# Alternatively, we could have gender determine the shape, not the color of points,
# and take the average beer consumption for color
ggplot(beer, aes(x = weight, y = height, shape = gender, color = nbeer)) + geom_point() +
    labs(x = "Weight (in pounds)", y = "Height (in inches)")

# The color scheme could use some more range
ggplot(beer, aes(x = weight, y = height, shape = gender, color = nbeer)) + geom_point() +
    labs(x = "Weight (in pounds)", y = "Height (in inches)") +
    scale_colour_gradientn(colours = rainbow(4))
# For more details: http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/

# Some observations have the same height and weight, i.e. share the same (x,y)
#   coordinates. In the graph, this means the points are lying on top of each
#   other. To avoid this overplotting, we can introduce some 'jitter' (i.e. random
#   noise) into the plot, by changing the geometry
ggplot(beer, aes(x = weight, y = height, shape = gender, color = nbeer)) + geom_jitter() +
    labs(x = "Weight (in pounds)", y = "Height (in inches)") +
    scale_colour_gradientn(colours = rainbow(4))

## Different example
# mirer data
load(url("https://git.io/JvGLc"))

# Lets plot education against wage
ggplot(mirer, aes(x = educ, y = wage)) + geom_point() +
    labs(x = "Education in years", y = "Hourly wage")

# The data could definitely use some jitter, but also a transformation of the
#   y axis to logarithmic scale
ggplot(mirer, aes(x = educ, y = wage)) + geom_jitter() +
    labs(x = "Education in years", y = "Hourly wage") +
    scale_y_continuous(trans = "log10")

# Next, we can color the plot by region
ggplot(mirer, aes(x = educ, y = wage, color = region)) + geom_jitter() +
    labs(x = "Education in years", y = "Hourly wage") +
    scale_y_continuous(trans = "log10")

ggplot(mirer, aes(x = educ, y = wage)) + geom_jitter() +
    labs(x = "Education in years", y = "Hourly wage") +
    scale_y_continuous(trans = "log10") +
    facet_grid(~region)

## A time series of monthly US unemployment data
#
load(url("https://git.io/JvGL4"))
str(us.unemp)

# We want to plot the values on the y-axis, and date on the x-axis
# Scatter plot not really useful
ggplot(us.unemp, aes(x = date, y = value)) +
    geom_point()

# geom_line() to connect individual dots
ggplot(us.unemp, aes(x = date, y = value)) +
  geom_path()