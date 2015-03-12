# census.R
# cleans census data and orders it to match spatial data
# only needs to be run on local machine
# louisiana EJ project

# set up workspace
setwd("D:/la")

# load up louisiana data
load("data/la.RData")

# extract the geoid data
geoid <- as.character(la$GEOID10)

# load census data.
cen <- read.csv("data/DEC_10_SF1_QTP5.csv",as.is=TRUE)
# TODO: download this automatically so don't have to clean
cen <- cen[c(-42795,-57401,-104086,-153798,-157679),]

pop.all <- as.numeric(cen$HD01_S01)
pop.black <- as.numeric(cen$HD01_S06)

census <- data.frame(pop.all,pop.black,geoid=as.character(cen$GEO.id2))
census$geoid <- as.character(census$geoid)
# put in the right order
census <- census[match(geoid,census$geoid),]

head(census$geoid)
head(geoid)
names(census)

save(census,file="data/census.RData")



