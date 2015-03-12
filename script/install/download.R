# download.R
# Script to automically download the census and tri data files
# Author Nathaniel MacHardy 
# Last updated 		August 1 2014
# Verified working 	September 15 2014

# this will need to be run on your analysis machine to install datasets.

# !!! MAKE SURE TO SET DATA DIRECTORY !!!
# This is where the data will be downloaded to.

# set data directory
setwd("~/lustre")

# load libraries, etc
library(rgeos)
library(rgdal)

################ Shapefile Data ######################

# get the file from the census bureau ftp site
download.file(
	url="ftp://ftp2.census.gov/geo/pvs/tiger2010st/22_Louisiana/22/tl_2010_22_tabblock10.zip",
	destfile="la.zip"
)

# unpack the file
unzip("la.zip")
file.remove("la.zip")  # clean up

# import
la <- readOGR(".","tl_2010_22_tabblock10")

# save in RData format to facilitate loading later
save(la,file="la.RData")

# clean up
file.remove("tl_2010_22_tabblock10.shp")
file.remove("tl_2010_22_tabblock10.dbf")
file.remove("tl_2010_22_tabblock10.prj")  
file.remove("tl_2010_22_tabblock10.shx")  
file.remove("tl_2010_22_tabblock10.shp.xml")  # this is correct

################## TRI data ######################

# download the 2010 TRI data from the EPA server
# the download link is hidden behind a script 
# but can be discovered using firefox's
# "copy download link"
download.file(url="http://ofmpub.epa.gov/enviro/efservice/MV_TRI_BASIC_DOWNLOAD/st/=/LA/year/=/2010/EXCEL",
	destfile="tri.csv")

# import the data file as a dataframe
tri.csv <- read.csv("tri.csv")

# promote to a spatialpoints data frame
coords <- cbind(tri.csv$LONGITUDE,tri.csv$LATITUDE)
tri <- SpatialPointsDataFrame(coords,tri.csv,proj4string=CRS(proj4string(la)))

# save in native RData
save(tri,file="tri.RData")
file.remove("tri.csv")  # clean up

cat("Data downloaded successfully\n")
