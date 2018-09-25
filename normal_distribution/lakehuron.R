LukeHuron
lake <- LakeHuron
summary(lake)
plot(lake)
#visually check to see how data is distributed
hist(lake, breaks= 30)

m.l <- mean(lake)
sd.l <- sd(lake)
lake.z <- (lake - m.l) / sd.l
lake.z
hist(lake.z)

temp <- data.frame(level= lake, year = row(lake))

library(ggplot2)
ggplot(as.data.frame(lake)) +
  geom_histogram(aes(x))

qqnorm(lake.z)
qqline(lake.z)

#test to see if it is normally distributed
shapiro.test(lake.z)

faithful
hist(faithful$eruptions)
qqnorm(faithful$eruptions)
qqline(faithful$eruptions)

#finding the probabily area between the z-scores 2 and 02
pnorm(2) - pnorm(-2)

#converting back to raw school
(2 + m.l) * sd.l

#raw score, mean, standard deviation
pnorm(580, mean= m.l, sd= sd.l)
#77.5% of values are expect to be below this number