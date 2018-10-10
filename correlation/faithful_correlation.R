faithful
f <- faithful
plot(f)
cor(f$eruptions, f$waiting)
cov(f$eruptions, f$waiting)
cor.test(f$eruptions, f$waiting)

mean(f$eruptions)
#is the mean of my sample significantly different than mu?
#comparing a population mean with the mean of the sample
t.test(f$eruptions[1:25], mu = 3.2)

unique(iris$Species)
virg <- iris$Sepal.Width[iris$Species == "virginica"]
vars <- iris$Sepal.Width[iris$Species == "versicolor"]
t.test(virg, vars)
t.test(virg[1:25], vars[1:25])

sleep
drug <- sleep$extra[sleep$group==2]
nodrug <- sleep$extra[sleep$group==1]

t.test(drug, nodrug, paired = TRUE)
