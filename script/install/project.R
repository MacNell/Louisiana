# projection.R
# reprojects the louisiana ej project data into feet
# run download.R first

library(sp)
library(rgdal)
library(rgeos)

# load data
cat("Loading Data\n")
setwd("~/lustre")
load("petrochemical.RData")
load("la.RData")

#### PROJECTION ###
la.feet <- "+proj=lcc +lat_1=31.16666666666667 +lat_2=32.66666666666666 +lat_0=30.5 +lon_0=-92.5 +x_0=1000000 +y_0=0 +ellps=GRS80 +datum=NAD83 +to_meter=0.3048006096012192 +no_defs"

cat("data loaded successfully.\n")
cat("Projecting to feet...\n")

# project into feet
la <- spTransform(la,CRS(la.feet))
# this is already in feet
# petrochemical <- spTransform(petrochemical,CRS(la.feet))

cat("Complete.\n")

save(petrochemical,file="petrochemical.RData")
save(la,file="la.RData")

cat("Saved successfully\n")



