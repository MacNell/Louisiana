##### download.R #####
### Script to download the census, shapefile, and tri data files

##### Setup #####
data.dir <- "D:/Users/Nathaniel/Documents/Louisiana"  # workspace location
library(sp)
library(rgeos)
library(rgdal)
setwd(data.dir)
naics <- read.csv("naics.csv") # spreadsheet of naics codes to include in analysis

##### Shapefile Data #####
# get and project the shapefile from the census bureau ftp site
download.file(
	url="ftp://ftp2.census.gov/geo/pvs/tiger2010st/22_Louisiana/22/tl_2010_22_tabblock10.zip",
	destfile="la.zip")
unzip("la.zip")                             # unpack the file
la.shp <- readOGR(".","tl_2010_22_tabblock10")  # import
la.feet <- paste("+proj=lcc +lat_1=31.16666666666667",
  "+lat_2=32.66666666666666 +lat_0=30.5 +lon_0=-92.5",
  "+x_0=1000000 +y_0=0 +ellps=GRS80 +datum=NAD83",
  "+to_meter=0.3048006096012192 +no_defs")
la <- spTransform(la.shp,CRS(la.feet))          # set to feet projection

##### TRI data #####
# download the 2010 TRI data from the EPA server
download.file(url=paste("http://ofmpub.epa.gov/enviro/efservice/",
  "MV_TRI_BASIC_DOWNLOAD/st/=/LA/year/=/2010/EXCEL",setp=""),
	destfile="tri2.csv")
# import the data file as a dataframe
tri.csv <- read.csv("tri.csv")
# this file has multiple lines per release, so reduce to one per facility
tri.one <- tri.csv[!duplicated(tri.csv$TRI_FACILITY_ID),]
# promote to a spatialpoints data frame
coords <- cbind(tri.one$LONGITUDE,tri.one$LATITUDE)
tri <- SpatialPointsDataFrame(coords,tri.one,proj4string=CRS(proj4string(la.shp)))  # in default gov't projection
writeOGR(tri, ".", "tri", driver="ESRI Shapefile")  # for checking manually
tri <- spTransform(tri,CRS(la.feet))

### restrict to naics codes of interest
petro <- naics$n[naics$include==1]
tri.keep <- 
  ( (tri$PRIMARY_NAICS %in% petro) |
      (tri$NAICS_2 %in% petro) |
      (tri$NAICS_3 %in% petro) |
      (tri$NAICS_4 %in% petro) |
      (tri$NAICS_5 %in% petro) |
      (tri$NAICS_6 %in% petro) )
tri <- tri[tri.keep,]

##### Census Data #####
### TODO: Make this an automatic download.
# extract the geoid data from shapefile
geoid <- as.character(la$GEOID10)
# load census data.
# census.csv <- read.csv("DEC_10_SF1_QTP5.csv",as.is=TRUE)
# TODO: download this automatically so don't have to clean
# this was downloaded as 5 files from the census website.
# remove old headers (left over from concatenation)
# census.csv <- census.csv[c(-42795,-57401,-104086,-153798,-157679),]
census.csv <- read.csv("census.csv",as.is=TRUE)
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
save(la,tri,file="la.RData")
