
# data cleaning - we will import a csv file as it is often found in public data sets
agr <- read.csv("http://www.foodsecurityportal.org/api/countries/agricultural-land-pe.csv")

# investigating the structure, we notice several things: 
# 1. each year has its own column. This is called the "wide" data format. 
# We want a format where the variable is called "year" and then each year is a value in that variable. 
# That is called the "long" format. 
# 2. the columns have an X prefix. this is because R does not allow numbers as column names
str(agr)


# the "reshape" package is very useful for converting data between "wide" and long.
# the command for wide -> long is called "melt", for long -> wide it is "cast"

library(reshape2)
# luckily, it works here out of the box, reshape is able to interpret the structure. 
agrl <- melt(agr)
# but let's look at it in more detail.
# we need to identify what is the id variable (stays untouched) and what are the measure variables (get converted)
# here we address the measure variables by their position in the data frame (2:56).
# variable.name and value.name are then only to specifcy our new variable names.
agrl <- melt(agr, id.vars = 1, measure.vars = 2:56, variable.name = "year", value.name = "agr")

# but we have another problem. we have to get rid of the Xs in front of our year 
# to be save, we first convert the factor to a string variable, to be safe in a new column
agrl$y <- as.character(agrl$year)

# now we ignore the first character and only keep the rest with substring (using a temporary object)
tmp <- substr(agrl$y,start = 2, stop = 5)
# finally, we can convert the string to a number and integrate it into our data frame
tmp <- as.numeric(tmp)
agrl$year <- tmp
# we don't need the y variable, just delete it
agrl$y <- NULL

# let's summarize our data set
summary(agrl)

# now we have a data set that works well with ggplot.
# let's only plot a subset of the countries
# filter the columns
dat <- agrl[agrl$Country %in% c("Colombia", "Germany", "Greece", "Chile"),]

ggplot(dat,aes(year,agr)) + 
  geom_line() + 
  facet_wrap(~Country) +
  ylab("% agricultural area")

# we can save the last plot as a pdf, svg or image
ggsave(filename = "plot.pdf")
# and we can save the data set also for later use
save(agrl, file = "data/agriculturalland.rdata")