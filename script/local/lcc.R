# lcc.R
# calculates results from spatial distributions (within LCC)
# louisiana EJ project

# set up workspace
setwd("D:/la")
load("data/census.RData")
source("script/local/lib/aggregate.R")
source("script/local/lib/ej.R")  # ej class definition (convenience)

# inspect results for minimum distance
load("result/la0.RData")
la0 <- combine(census,result)
la0.ej <- ej(mu=la0$mu,s2=la0$s2,nframe=data.frame(la0$pop.white,la0$pop.black))

summary(la0.ej)/5280


# display results in feet
black.distance/5280
white.distance/5280



