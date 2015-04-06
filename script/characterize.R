### characterize.R
# computes spatial proximity distributions from R data
# characterize spatial polygons: takes about 2 hours, run once

data.dir <- "D:/Users/Nathaniel/Documents/Louisiana"  # workspace location
library(sp)
library(rgdal)
library(rgeos)
source("D:/Users/Nathaniel/GitHub/Louisiana/script/polygons.R")

setwd(data.dir)
load("la.RData")

distances <- c(5280/2,5280,5280*3)
proximity <- PolygonsProximity(la,tri,d=distances)
save(proximity,file="proximity.RData")




