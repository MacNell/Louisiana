# result.RData
# appends census data to calculated distance data
# louisiana EJ project

# set up workspace
library(sp)
library(rgeos)
library(rgdal)
setwd("D:/la")
load("result/la0.RData")

# investigate dataset
class(result)
dim(result)
names(result)

# unlist data (a result of apply)
mu <- unlist(result$mu)
s2 <- unlist(result$s2)

# let's see what's going on
par(bg="black",fg="green",col="green",col.axis="green",col.lab="green")
plot(density(mu/5280))
summary(mu/5280)
summary(s2/5280^2)  # feet squared

# load up louisiana data
load("data/la.RData")

result <- data.frame(mu,s2)
result$geoid <- as.character(la$GEOID10)

# match to census data.
# TODO: download this automatically so don't have to clean
census <- read.csv("data/DEC_10_SF1_QTP5.csv",as.is=TRUE)
# remove blank rows left over from manual merge
census <- census[c(-42795,-57401,-104086,-153798,-157679),]
# extract relevant data
pop.all <- as.numeric(census$HD01_S01)
pop.black <- as.numeric(census$HD01_S06)

geoid <- census$GEO.id2



head(census$GEO.id2)
head(result$geoid)

cen <- data.frame(geoid,pop.all,pop.black)

# manual merge 
result <- data.frame(result,cen[match(result$geoid,cen$geoid),])
result <- result[,-4]
names(result)

save(result,file="result/result0.RData")



