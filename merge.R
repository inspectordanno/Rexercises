dataOne <- data.frame( a = c("american","canadian","mexican","chinese","english","french"), b =c ("united states", "canada", "mexico", "china", "uk", "france"))
dataTwo <- data.frame( b= c("china","france","united states", "mexico", "uk", "canada"), c=c("beijing", "paris", "washington", "mexico city", "london", "ottawa"))

merged <- merge(dataOne, dataTwo, by = "b")

bind <- cbind(dataOne, dataTwo)

names ##rename columns
