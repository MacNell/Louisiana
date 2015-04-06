### resample distributions

data.dir <- "D:/Users/Nathaniel/Documents/Louisiana"  # workspace location
library(sp)
library(rgdal)
library(rgeos)
load("proximity.RData")
load("la.RData")

### Louisiana ###
black <- la$pop.black
white <- la$pop.total - la$pop.black
# run
s1 <- replicate(5,calculate(n0=white,n1=black,bayes=proximity),simplify=FALSE)
save(s1,file="s1.RData")
s2 <- replicate(5,calculate(n0=white,n1=black,bayes=proximity),simplify=FALSE)
save(s2,file="s2.RData")
# glue together
flat.la <- do.call(rbind,c(s1,s2))
# statistics
means <- aggregate(flat.la,by=list(flat.la$Group),mean)
# ucl
sds <- aggregate(flat.la,by=list(flat.la$Group),sd)
ucl <- means + 1.96*sds
lcl <- means - 1.96*sds
means
lcl
ucl
means/5280
lcl/5280
ucl/5280

### Chemical Corridor ### 
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
proximity.lcc <- proximity[la$COUNTYFP10 %in% lcc]
white.lcc <- white[la$COUNTYFP10 %in% lcc]
black.lcc <- black[la$COUNTYFP10 %in% lcc]
# run
l1 <- replicate(5,calculate(n0=white.lcc,n1=black.lcc,bayes=proximity.lcc),simplify=FALSE)
save(l1,file="l1.RData")
l2 <- replicate(5,calculate(n0=white.lcc,n1=black.lcc,bayes=proximity.lcc),simplify=FALSE)
save(l2,file="l2.RData")
# glue together
flat.lcc <- do.call(rbind,c(l1,l2))
# statistics
means <- aggregate(flat.lcc,by=list(flat.lcc$Group),mean)
# ucl
sds <- aggregate(flat.lcc,by=list(flat.lcc$Group),sd)
ucl <- means + 1.96*sds
lcl <- means - 1.96*sds
means
lcl
ucl
means/5280
lcl/5280
ucl/5280

### East Baton Rouge Parish ###
proximity.ebr <- proximity[la$COUNTYFP10 == "033"]
white.ebr <- white[la$COUNTYFP10 == "033"]
black.ebr <- black[la$COUNTYFP10 == "033"]
# run replicator for ebr alone
e1 <- replicate(10,calculate(n0=white.ebr,n1=black.ebr,bayes=proximity.ebr),simplify=FALSE)
save(e1,file="e1.RData")
# ebr analysis
flat.ebr <- do.call(rbind,e1)
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
