plot(rivers)

library(ggplot2)
library(ggthemes)

qplot(rivers)

mpg
mympg <- mpg

ggplot(data = mympg) +
  geom_point(aes(x=displ,y=hwy,color=class,size=cyl), alpha = 0.5) +
  ggtitle("Cars") + xlab("Displacement") + ylab("Highway MPG")


