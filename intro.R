
# A quick introduction to R -----------------------------------------------

# Search help - or press F1 with cursor on a function
?plot    # search help on command
??vector # search help on keyworkd

# packages
install.packages(ggplot2) # install a package (or use GUI)
library(ggplot2)  # load a package
require(ggplot2)  # equivalent to library()
detach(package:ggplot2) # unload package (only needed in case of conflicts btw. packages)


# Objects -----------------------------------------------------------------

# in R, everything is stored as an objects
a <- 1          # assign the value 1 to the object a.
car <- cars # assign a copy of the built-ini data set "cars" in the object "car"

# list all objects
ls()

# list objects inside the object dia
ls(car) 

# show the data structure of "car"
str(car)

# delete object
rm(car)

# data structures ---------------------------------------------------------

# two simple vectors
vec <- c(1,2,3)
labels <- c("one", "two", "three")

# a data frame combining the two vectors into columns of a data frame
df <- data.frame(vec,labels)
# now let's give the columns new names
df <- data.frame(values = vec, names = labels)

# directly access the columns as vectors
df$values
df$names

# create a new column
df$v2 <- c(5,6,7) 
# calculate a new column
df$v3 <- df$values + df$v2
# delete a column
df$v2 <- NULL


# access elements inside rows and columns
df[1,]  # first row in dataframe df
df[,1]  # first column in dataframe df
df[2,3] # one element in dataframe df
df[1:3,] # rows 1:3 (: is short for integer sequence from - to)
df$values[1]  # first row in column "values"
df$names[3] # third row in column "names"
df[,"names"] # column with the name "names"

# more on rows and columns
# return the current row and column
row(df)
col(df)

# number of rows and columns
nrow(df)
ncol(df)

# calculate with rows and colunns
df$percent <- 100 *row(df) / nrow(df)

# the length of a vector or data frame (number of elements)
length(df) # number of columns
length(df$values) # number of elements in vector

# Logical Conditions and Comparisons --------------------------------------

1 == 2 # is 1 equal 2?
1 < 2  # is 1 smaller than 2?
2 <= 2 # is 2 smaller or equal 2? ! don't confuse with the assignment operator! <- 
!(1<2) # is 1 not smaller than 2? (! = "is not")
1 != 2 # is 1 not equal 2?
1 %in% c(1,2,3)  # is 1 included in the following vector?

df[df$values>2,] # filter only rows for which the condition df$values>2 is true
df$isGreater2 <- df$values>2 # create a new column that contain the result of a logical test


# data types --------------------------------------------------------------

# a floating point number
fl <- as.numeric(5.345)
# an integer (compare the result!)
int <- as.integer(5.345)

# a vector and a list
vec <- c(1,2,3)
# a list can contain arbitrary elements (often the result of imported data, somewhat inconvenient)
lis <- list(1,2,vec, "test")

# characters and factors
ch <- c("apple", "apple", "cherry", "orange", "cherry" )
# convert character vector to factor vector (a labeled index)
fac <- as.factor(ch)
str(fac)

# the underlying indices
as.numeric(fac)
# the labels 
levels(fac)
# assign new labels to the indices (levels in R terminology)
levels(fac) <- c("car", "truck", "train")
fac

# Missing values ----------------------------------------------------------

# a vector with missing values
vec <- c(1, NA, 2, 3, NA)

# check which elements are missing
is.na(vec)
# this is necessary because e.g. vec[2] == NA does not work!

# Load and clean data -----------------------------------------------------

# sacramento real estate transactions
dat <- read.csv("http://samplecsvs.s3.amazonaws.com/Sacramentorealestatetransactions.csv")

# first step - what is in the data? also click on it in the Environment to open the table
str(dat)

# create a table - number of baths by apartment type?
table(dat$baths,dat$type)

# can also store and visualize the table, or convert it to a data frame
t <- table(dat$baths,dat$type)
plot(t)
df <- as.data.frame(t)

# plotting the data set
plot(dat$type, dat$price)
plot(dat$beds, dat$baths)
plot(dat$sq__ft, dat$price)

# using the formula notation (plot will choose the chart type based on data structure)
plot(price ~ type, data = dat)
plot(beds ~ type, data = dat)

# now the same with ggplot2
library(ggplot2)

# quick notation (does not give same results as plot)
qplot(dat$type, dat$price)

# complete notation
ggplot(dat) + geom_point(aes(x = sq__ft, y = price, color = baths)) + facet_wrap(~type)


# calculate mean and median price
mean(dat$price)
median(dat$price)

# calculate the mean price by condo type
# for this we use an apply function (more on that soon!)
tapply(dat$price, dat$type, FUN = mean)
