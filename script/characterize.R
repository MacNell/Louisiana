### characterize.R
# computes spatial proximity distributions from R data

data.dir <- "D:/Louisiana"

library(sp)
library(rgdal)
library(rgeos)
source("C:/GitHub/Louisiana/script/polygons.R")

setwd(data.dir)
load("petrochemical.RData")
load("la.RData")

### characterize spatial polygons: takes about 2 hours, run once
# distances <- c(5280/2,5280,5280*3)
# result <- PolygonsProximity(la,petrochemical,d=distances)
# save(result,file="result.RData")

### resample distributions

# let's try one resample (200 seconds per full sample?)
black <- la$pop.black
white <- la$pop.total - la$pop.black

load("result.RData")
# test replicator
samp54 <- replicate(5,calculate(n0=white,n1=black,bayes=result),simplify=FALSE)
save(samp54,file="samp54.RData")
samp53
samp52


?princomp

dat <- do.call(rbind,mat.to.sweep)

require(graphics)
data(USArrests)

pc.cr <- princomp(USArrests, cor=TRUE)

summary(pc.cr)
confint(pc.cr)

names(pc.cr)
pc.cr$loadings

mean(pc.cr$scores[,1])
sd(pc.cr$scores[,1])


stem <- calculate(n0=white,n1=black,bayes=result)

# let's try one at a time. Dump result if simulation fails.
for(i in 1:5) {
  try( {temp <- calculate(n0=white,n1=black,bayes=result)
  stem <- c(stem,temp) })
}




