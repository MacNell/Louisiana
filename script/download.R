##### download.R
### Script to automically download the census and tri data files
# and format correctly for analysis

# !!! MAKE SURE TO SET DATA DIRECTORY !!!
# This is where the data will be downloaded to.
data.dir <- "D:/Louisiana"

# load libraries, etc
library(sp)
library(rgeos)
library(rgdal)
setwd(data.dir)
naics <- read.csv("naics.csv") # naics codes to include in analysis

##### Shapefile Data #####

# get the shapefile from the census bureau ftp site
download.file(
	url="ftp://ftp2.census.gov/geo/pvs/tiger2010st/22_Louisiana/22/tl_2010_22_tabblock10.zip",
	destfile="la.zip")
# unpack the file
unzip("la.zip")
file.remove("la.zip")  # clean up
# import
la <- readOGR(".","tl_2010_22_tabblock10")
# clean up
# file.remove("tl_2010_22_tabblock10.shp")
# file.remove("tl_2010_22_tabblock10.dbf")
# file.remove("tl_2010_22_tabblock10.prj")  
# file.remove("tl_2010_22_tabblock10.shx")  
# file.remove("tl_2010_22_tabblock10.shp.xml")  # thanks ESRI
# set to feet projection
la.feet <- "+proj=lcc +lat_1=31.16666666666667 +lat_2=32.66666666666666 +lat_0=30.5 +lon_0=-92.5 +x_0=1000000 +y_0=0 +ellps=GRS80 +datum=NAD83 +to_meter=0.3048006096012192 +no_defs"
la <- spTransform(la,CRS(la.feet))


##### TRI data #####
# download the 2010 TRI data from the EPA server
# the download link is hidden behind a script 
# but can be discovered using firefox's
# "copy download link"
download.file(url="http://ofmpub.epa.gov/enviro/efservice/MV_TRI_BASIC_DOWNLOAD/st/=/LA/year/=/2010/EXCEL",
	destfile="tri.csv")
# import the data file as a dataframe
tri.csv <- read.csv("tri.csv")
# file.remove("tri.csv")  # clean up
# promote to a spatialpoints data frame
coords <- cbind(tri.csv$LONGITUDE,tri.csv$LATITUDE)
tri <- SpatialPointsDataFrame(coords,tri.csv,proj4string=CRS(proj4string(la)))
# restrict to naics codes of interest
naics.keep <- naics$n[naics$include==1]
tri.keep <- 
  ( (tri$PRIMARY_NAICS %in% petro) |
      (tri$NAICS_2 %in% petro) |
      (tri$NAICS_3 %in% petro) |
      (tri$NAICS_4 %in% petro) |
      (tri$NAICS_5 %in% petro) |
      (tri$NAICS_6 %in% petro) )
petrochemical <- tri[keep,]
# set to same projection as census data
petrochemical <- spTransform(petrochemical,CRS(la.feet))

##### Census Data #####
### TODO: Make this an automatic download.
# extract the geoid data from shapefile
geoid <- as.character(la$GEOID10)

# load census data.
census.csv <- read.csv("DEC_10_SF1_QTP5.csv",as.is=TRUE)
# TODO: download this automatically so don't have to clean
# this was downloaded as 5 files from the census website.
# remove old headers (left over from concatenation)
census.csv <- census.csv[c(-42795,-57401,-104086,-153798,-157679),]
pop.total <- as.numeric(census.csv$HD01_S01)
pop.black <- as.numeric(census.csv$HD01_S06)
# build and order census appendix dataset
census <- data.frame(pop.total,pop.black,
                     geoid=as.character(census.csv$GEO.id2))
census <- census[match(geoid,census$geoid),]
# append to shapefile
la@data <- data.frame(la@data,census)
# restrict to populated blocks
la <- la[la$pop.total>0,]


##### Save #####
# save in RData format to facilitate loading later
save(la,file="la.RData")
save(petrochemical,file="petrochemical.RData")

cat("Data downloaded successfully\n")
