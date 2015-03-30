### characterize.R
# computes spatial proximity distributions from R data

data.dir <- "D:/Louisiana"

library(sp)
library(rgdal)
library(rgeos)
source("C:/GitHub/Louisiana/script/polygons.R")

setwd(data.dir)
load("petrochemical.RData")
load("la.RData")

### characterize spatial polygons: takes about 2 hours, run once
# distances <- c(5280/2,5280,5280*3)
# result <- PolygonsProximity(la,petrochemical,d=distances)
# save(result,file="result.RData")

### resample distributions

# let's try one resample (200 seconds per full sample?)
black <- la$pop.black
white <- la$pop.total - la$pop.black

load("result.RData")
# test replicator
samp54 <- replicate(5,calculate(n0=white,n1=black,bayes=result),simplify=FALSE)
save(samp54,file="samp54.RData")

# subset to the louisiana petrochemical corridor.
lcc <- c("033", # East Baton Rouge
"005",# Ascension
"047",# Iberville
"051",# Jeffreson
"071",# Orleans
"075",# Plaquemines
"087",# St. Bernard
"089",# St. Charles
"093",# St. James
"095",# St. John
"121")# West Baton Rouge
result.lcc <- result[la$COUNTYFP10 %in% lcc]
white.lcc <- white[la$COUNTYFP10 %in% lcc]
black.lcc <- black[la$COUNTYFP10 %in% lcc]
result.ebr <- result[la$COUNTYFP10 == "033"]
white.ebr <- white[la$COUNTYFP10 == "033"]
black.ebr <- black[la$COUNTYFP10 == "033"]


# run replicator for ebr alone
samp.ebr <- replicate(10,calculate(n0=white.ebr,n1=black.ebr,bayes=result.ebr),simplify=FALSE)
save(samp.ebr,file="sampebr.RData")

# ebr analysis
flat.ebr <- do.call(rbind,samp.ebr)
# means
means <- aggregate(flat.ebr,by=list(flat.ebr$Group),mean)
# ucl
sds <- aggregate(flat.ebr,by=list(flat.ebr$Group),sd)
ucl <- means + 1.96*sds
lcl <- means - 1.96*sds
means
ucl
lcl
ucl/5280
lcl/5280
means/5280

# run replicator for lcc alone
samp.lcc <- replicate(10,calculate(n0=white.lcc,n1=black.lcc,bayes=result.lcc),simplify=FALSE)
save(samp.lcc,file="samplcc.RData")
flat.lcc <- do.call(rbind,samp.lcc)
# means
means <- aggregate(flat.lcc,by=list(flat.lcc$Group),mean)
# ucl
sds <- aggregate(flat.lcc,by=list(flat.lcc$Group),sd)
ucl <- means + 1.96*sds
lcl <- means - 1.96*sds
means
ucl
lcl
ucl/5280
lcl/5280
means/5280



# growth method that dumps failed simulations
root <- calculate(n0=white,n1=black,bayes=result)
stem <- calculate(n0=white,n1=black,bayes=result)
tree <- list(root,stem)

# try to grow the tree
for(i in 1:5) {
  try( {leaf <- calculate(n0=white,n1=black,bayes=result)
  tree[[length(tree)+1]] <- leaf })
}
tree
save(tree,file="tree.RData")

# summarize preliminary results
load("samp5.RData")
load("samp53.RData")

# concatenate lists
samp <- c(samp53,samp53)

flat <- do.call(rbind,samp)

# means
means <- aggregate(flat,by=list(flat$Group),mean)
# ucl
sds <- aggregate(flat,by=list(flat$Group),sd)
ucl <- means + 1.96*sds
lcl <- means - 1.96*sds
ucl
lcl
ucl/5280
lcl/5280
means/5280



means
lcl
ucl



names(la)
sum(la$pop.total)
sum(la$pop.total)-sum(la$pop.black)
