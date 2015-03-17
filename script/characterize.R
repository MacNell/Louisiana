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
samp52 <- replicate(5,calculate(n0=white,n1=black,bayes=result),simplify=FALSE)
save(samp52,file="samp5.RData")

samp52
