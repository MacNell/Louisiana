# main.R
# main analysis file for the louisiana project
# make sure to run install first

# run for first install
# install.packages("sp")
# install.packages("rgdal")
# install.packages("rgeos")

# load packages
library(sp)
library(rgdal)
library(rgeos)

# load scripts
setwd("~/R/la")
source("script/restrict.R")
source("script/polygons.R")

# load data
setwd("~/lustre")
load("petrochemical.RData")
load("la.RData")

cat("data loaded successfully.\n")

cat("Starting calculation.\n")
# do the calculations (currently, test with 1000 runs)
miles <- 5280*0
result <- DescribeShapefile(la,tri,d=miles,n=1000)
save(result,file="~/lustre/la0.RData")

# for some reason, this is giving a bounding box infinity problem
# error in validOBject(.object) from polygons.R#8
# invalid class spatialpoints object: bbox should never containe infinite values
# warning: no non-missing arguments to min, returning inf
# watning: no non-missing arguments to max, returning -Inf
# apparently the bounding box isn't being computed correctly?
# maybe a switch to gEnvelope will help things
# this seems fine, what is the deal?
# this seems to be okay, why is this getting null?
# apparently doing 100 runs instead of 10 fixes the problem...the results remain to be seen

cat("Process completed.\n")
