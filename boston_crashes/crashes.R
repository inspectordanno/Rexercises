crash <- read.delim("https://data.boston.gov/export/e4b/fe3/e4bfe397-6bfc-49c5-9367-c879fac7401d.tsv")

crash$dispatch_ts

crash$date <-as.Date(crash$dispatch_ts)

table(crash$mode_type, crash$location_type)

a <- as.POSIXlt(saf
                )

tmp <- crash[,c(1,2,3,9.10)]
crash <- tmp; rm(tmp)