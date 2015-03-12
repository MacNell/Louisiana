# result.RData
# calculates results from spatial distributions
# louisiana EJ project

# set up workspace
setwd("D:/la")
load("data/census.RData")
source("script/local/lib/aggregate.R")
source("script/local/lib/ej.R")  # ej class definition (convenience)

# inspect results for minimum distance
load("result/la0.RData")
la0 <- combine(census,result)

# calculate statewide
ej0.statewide <- ej(mu=la0$mu,s2=la0$s2,nframe=data.frame(la0$pop.white,la0$pop.black))
summary(ej0.statewide)/5280

# specify lcc parishes
# West Baton Rouge	121
# East Baton Rouge	033
# Iberville			047
# Ascension			005
# St James			093
# St John			095
# Plaquemines		075
# Jefferson			051
# Orleans			071
# St Charles			089	
# St Bernard			087
lcc.code <- c("121","033","047","005","093",
	"095","075","051","071","089","087")
load("la.RData")
lcc0 <- la0[la$COUNTYFP10 %in% lcc.code,]
ej0.lcc <- ej(mu=lcc0$mu,s2=lcc0$s2,nframe=data.frame(lcc0$pop.white,lcc0$pop.black))
summary(ej0.lcc)/5280

# parish-by-parish analysis
parish.list <- names(table(la$COUNTYFP10))
result <- lapply(parish.list,by.parish)
names(result) <- parish.list  # append codes

### Distance ###
load("result/la1.RData")
names(result)
la1 <- combine(census,result)
summary(la1$mu)
summary(la1$s2)  # this might be okay? Ths max is still really high...

# statewide
ej1.statewide <- ej(mu=la1$mu,s2=la1$s2,nframe=data.frame(la1$pop.white,la1$pop.black))
summary(ej1.statewide)







