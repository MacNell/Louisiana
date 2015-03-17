### characterize.R
# computes spatial proximity distributions from R data

data.dir <- "D:/Louisiana"

library(sp)
library(rgdal)
library(rgeos)
source("C:/GitHub/Louisiana/script/polygons.R")

load("petrochemical.RData")
load("la.RData")

distances <- c(5280/2,5280,5280*3)
result <- PolygonsProximity(la,petrochemical,d=distances)
save(result,file="result.RData")


