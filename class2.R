
# ggplot demo -------------------------------------------------------------


library(ggplot2)
library(ggthemes)

qplot(rivers)

mpg
mympg <- mpg

ggplot(data = mympg) + 
  geom_point(aes(x=displ,y=hwy,color = class, size= cyl), alpha = 0.5) + 
  ggtitle("Cars") + xlab("Displacement") + ylab("Consumpt. Highway")
  theme_economist()

library(plotly)
ggplotly()  


# Anscomb's Quartet -------------------------------------------------------
anscombe
attach(anscombe)

plot(x1,y1)
plot(x2,y2)
plot(x3,y3)
plot(x4,y4)

mean(x1)
mean(x2)

sd(y1)

detach(anscombe)
# the Boxplot -------------------------------------------------------------

plot(iris)

a <- boxplot(Sepal.Length ~ Species, data = iris)

g <- ggplot(iris, aes(x = Species, 
                      y = Sepal.Length)) + 
  geom_boxplot() +
  geom_jitter(alpha = 0.3) 


g

# how are outliers calcuated in ggplot2?
# https://ggplot2.tidyverse.org/reference/geom_boxplot.html

iris

virg <- iris[iris$Species == "virginica", ]

hist(virg$Sepal.Length)

sd <- sd(virg$Sepal.Length)
mean <- mean(virg$Sepal.Length)

virg$z <- (virg$Sepal.Length - mean) / sd

attach(virg)
sort(z)
quantile(z)
IQR(z)

quantile(z,0.25) - 1.5 * IQR(z)
quantile(z,0.75) + 1.5 * IQR(z)

# Boston data example -----------------------------------------------------


# crashes in Boston
crash <- read.delim("https://data.boston.gov/export/e4b/fe3/e4bfe397-6bfc-49c5-9367-c879fac7401d.tsv")

crash$dispatch_ts

# date object - extract the date
crash$date <- as.Date(crash$dispatch_ts)

# example POSIXct object 
a <- as.POSIXct("2015-01-01 18:23:57", format = "%Y-%m-%d %H:%M:%S")

# format takes a date time object and creates a formatted string
format(a, "%H^%M^%S")

# but internally, it is the number of seconds since jan 1 1900
as.numeric(a)

# example POSIXlt object - this is similar, but includes a list of date components
# this only works for POSIXlt, not POSIXct
a <- as.POSIXlt("2015-01-01 18:23:57", format = "%Y-%m-%d %H:%M:%S")
ls(a)
a$hour
a$mday
a$wday

# but then there are some functions that work with all kinds of dateobject
months(a)
weekdays(a)
quarters(a)


# lets use it
crash$time <- as.POSIXlt(crash$dispatch_ts) # stored as seconds
crash$dispatch_ts <- NULL


hist(crash$time, breaks = "hours")
library(lubridate)

ggplot(crash) + 
  geom_histogram(aes(x = time, fill = mode_type)) 

ggplot(crash) + 
  geom_bar(aes(x = time$mon, fill = mode_type)) + scale_fill_brewer(palette = "PuBuGn") + xlab("hour of day") 

summary(crash$time$mon)

# wide long example -------------------------------------------------------


agr <- read.csv("http://www.foodsecurityportal.org/api/countries/agricultural-land-pe.csv")

str(agr)

library(reshape2)
agrl <- melt(agr)
agrl <- melt(agr, id.vars = 1, measure.vars = 2:56, variable.name = "year", value.name = "agr")

agrl$y <- as.character(agrl$year)

tmp <- substr("X1961",start = 2, stop = 5)
tmp <- as.numeric(tmp)
agrl$year <- tmp

agrl$year <-as.numeric(substr(agrl$y,start = 2, stop = 5))
agrl$y <- NULL

ggplot(agrl) + geom_line(aes(year,agr)) + facet_wrap(~Country) + theme_minimal()
ggsave()
save(agrl, file = "data/agriculturalland.rdata")

# Earnings report ---------------------------------------------------------

earnings <- read.csv("data/employee-earnings-report-2017.csv")

tmp <- gsub("[$]","", earnings$REGULAR)
tmp <- gsub(",","", tmp)
tmp <- as.numeric(tmp)
earnings$REGULAR <- tmp



a <- runif(15, 1, 50)
a
