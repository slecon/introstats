######
# Introduction, focussing on data
######

# This loads an R object known as a data.frame
load(url("https://git.io/fAZil"))

# What you see in the environment is called the 'structure' of the data

str(titanic)

# The first word in each row is the variable name
#    think of it as a column name in the quasi-matrix that is the data.frame
# The abbreviation after the colon is the data type, and they relate to the scales of 
#    measurement from the opening lecture.
# The equivalent to what we called "categorical variable" is a 'factor' in R, and its
#   categories are referred to as 'levels'.
#   The variable "Sex" has two levels, "male and "female", and the variable "Embarked"
#   has three levels "Cherbourg", "Queenstown", and "Southampton."
# The equivalent to ordinal variables are called 'ordered factors'. The ascending order of
#   their levels is indicated with '<'
# Finally, the equivalent of both interval and ratio data are called 'numerical' in R. (If
#   a variable only takes on integer values, it is stored as 'integer')
# There two other variable types in this data: 'character' and 'logical'.
#   'character' is purely text, with levels or categories.
#   'logical' are binary data, limited to being 'TRUE' or 'FALSE'. (Mathematically, these 
#   are '1' and '0')

# The types of data are recognized by R when we ask it to summarize the data.
summary(titanic)
# As you can see, R treats each variable differently when it comes to the summary. Some
#   variables are only being counted, some are being tabulated (by category), while others
#   receive an entire array of statistical operations


####
# Indexing
####

# Abstractly speaking, a dataframe is rectangular array of data. It has rows (in this case 891),
#   each representing an 'observation', and columns (in this case 9), each representing a 
#   'variable'. Each particular cell of the data frame is a 'value'.

# To retrieve a particular cell, we have to index the data frame, which is done with square
#   brackets. For instance,
titanic[10,3]
# gives the value of the 10th row (observation 10) and 3rd column (variable 'age'). 
# Try another:
titanic[11,8]

# To retrieve an entire row, leave the spot after the comma empty
titanic[137,]
# Similarly, leaving the row position empty returns all rows of a selected column
titanic[,4]
# Consequently, leaving both empty returns the entire data
titanic[,]

# Since the variable names are essentially column names, there is a second way to recover a 
#   particular column:
titanic[,"Pclass"]

# The particular values i and j in titanic[i,j] are referred to as indices. To retrieve more
#   than one row or more than one column, these indices have to be vectors.

# In computer science, a vector is a one-dimensional homogeneous collection, i.e. a simple
#   array of either numbers or characters. Creating a vector in R requires the c() function.
c(2,4,6,8)

# Using this vector as an index in our previous notation retrieves multiple rows
titanic[c(2,4,6,8),"Fare"]
# or multiple columns for that matter
titanic[,c("Pclass","Cabin")]

# Vectors can also be stored in a separate variable, and then used indirectly. To store them, 
#   or any other function output, use the assignment operator <-
k <- c(1,3,5,7,9)
titanic[k,]

# R has several shortcuts for when you want to create long vectors of some repeating pattern.
# Most notably, a vector containing a sequence from 1 to 10 can be written as
c(1,2,3,4,5,6,7,8,9,10)
# or, more efficiently,
seq(from=1,to=10,by=1)
# or, even shorter
1:10

# Hence, the following command calls the first fifteen rows.
titanic[1:15,]

# As a footnote, it should be mentioned R has two functions showing sort-of a 
head(titanic)
tail(titanic)

####
# Logical conditions
####
# An important concept in R, just as in other programming languages, are logical conditions 
#   (also known as Boolean expressions). These are essentially statements that can either be
#   TRUE or FALSE
# For instance:
5 < 4 
3*(-1) < sqrt(2)
titanic[5,"Pclass"] == "Lower"

# if performed on a vector, the statement is checked elementwise
k < 5

# and for these purposes, individual columns of data frames are being treated as vectors
titanic[,"Age"] < 18

# Side note: notice the 'NA' values. These are missing values, resulting from an empty cell
#   of the age variable for the particular individual. Missing data are a common occurence 
#   in practical data work, and R handles NA's rather gracefully.

# Next, we want to further leaverage logical conditions, by identifying the row number of 
#   observations for which a certain condition is true. This is done via the which() function.
which(titanic[,"Embarked"]=="Cherbourg")
# The result is a vector, which we can store for further use
french.passengers <- which(titanic[,"Embarked"]=="Cherbourg")
# Like any vectors earlier, we can use this vector to index the data set
titanic[french.passengers,c("Name","Sex")]

# With this powerful syntax, we can identify observations based on all kinds of conditions and
#   criteria.

#####
# Technical notes
#####

# After installation, the R version on your computer contains only the 'base' functions. These
#   are quite powerful and in most cases sufficient for our class, but literally thousands of
#   additional functions are available through the installation of 'packages'. One particular
#   useful package that we will use repeatedly in this class is called 'tidyverse'. To install:
install.packages("tidyverse")
# This package is now installed perpetually, but needs to be 'actived' in each R session. This
#   is done with the library() function.
library(tidyverse)

#####
# Back to data
#####
# The Titanic data set we used earlier was already well 'cleaned-up'. In most cases, obviously,
#   your data won't come in this 'tidy' format. Rather, you will have to clean the data yourself.
# Take the following example. The read.csv() function imports a file with comma-separated values.
beer <- read.csv("https://git.io/fAgL0")

# Checking the structure of this data frame reveals that every variable is coded as numeric. While
#   this is the correct assessment for the first four, the last variable is clearly categorical
#   and should be classified as such. 
str(beer)

# To fix this, we are going to use a number of new functions are once. The function mutate(), which
#   is included in the tidyverse package. Further, the function factor() takes in any vector and
#   re-classifies it as a categorical variable for given levels, with associated labels.

beer <- mutate(beer, gender=factor(gender, levels=c(0,1), labels=c("male","female")))

# Now the gender variable is correctly classified.
str(beer)

# For a more involved example, consider the following data adapted from Thad W. Mirer, "Economic 
# Statistics and Econometrics", 3rd ed. (New York: Macmillan, 1995), pp. 17-22.)
mirer <- read.table(file="https://git.io/fA2wx", 
                    stringsAsFactors = FALSE, comment.char = "@")
# A look at the structure reveals that the first column (V1) was mistaken to be of character 
#   type.
str(mirer)

# This is because of a misplaced semicolon in the (otherwise empty) last row.
tail(mirer)
# Recall from above how we can use indexing to retrieve or exclude certain rows (or columns).
mirer <- mirer[-101,]

# Next, notice that the variable names are generic V[0-9] labels. To rename individual columns,
#   use the rename() function that comes with the tidyverse package.
mirer <- rename(mirer, id=V1, famsize=V2, educ=V3, age=V4,
                exp=V5, anmw=V6, race=V7, region=V8, wage=V9,
                faminc=V10, wealth=V11, savings=V12)
# Next, we would like to redefine certain variables, in particular correcting their type. For
#   this task we use the mutate() function.
mirer <- mutate(mirer, id=as.numeric(id),
                race=factor(race, levels=c(1,2), labels=c("white", "black")),
                region=factor(region, levels=1:4, labels=c("northeast", "northcentral", 
                                                           "south", "west"))
)
# Now the data set has a proper structure. To save the result in R's own data format, use the
#   save() command. Before you can do that, though, you have to tell R in which directory we
#   are working in. This is done with the setwd("") command.
setwd("C:/path/to/your/files")  # <= fix the path first!

save(mirer, file="mirer.rda")

# To command rm() removes objects from the environment.
rm(mirer)
# Equivalently, the little broom in the "Environment" tab can be used.

# With load(), we can retrieve the previously saved data file.
load(file="mirer.rda")