library(tidyverse)
hist(rivers)

hist(sleep$extra)
shapiro.test(sleep$extra)

mean(sleep$extra)
sd(sleep$extra)
t.test(sleep$extra, mu = .2)

##independent t-test

##plot of both groups
ggplot(data = sleep, aes(x= group, y=extra)) + geom_boxplot() + geom_point()

##difference in means is not significant
t.test(sleep$extra[sleep$group==1], sleep$extra[sleep$group==2])

##paired t-test

ggplot(data = sleep, aes(x= group, y=extra, group = ID, color = ID)) + geom_line() + geom_point()

##difference in means issignificant
t.test(sleep$extra[sleep$group==1], sleep$extra[sleep$group==2], paired = T)

##dependent is hwy. independent is trans, drv, and class

fit <- aov(hwy ~ trans + drv + class, data = mpg)
fit
anova(fit)
model.tables(fit, type = "effects")
