# naics.R
# extracts relevant naics codes from the TRI dataset.
# should be called when the correct environment is already loaded.

# shouldn't need to run this again unless changing NAICS inclusion
# in this case, just edit the csv and run part II again.

### Part I - prepare NAICS list (only do this once) ###
# first, create a table to populate
# stack a vector of NAICS codes
# n1 <- tri$PRIMARY_NAICS
# n2 <- tri$NAICS_2
# n3 <- tri$NAICS_3
# n4 <- tri$NAICS_4
# n5 <- tri$NAICS_5
# n6 <- tri$NAICS_6

# save a .csv file of codes and frequencies
# n <- c(n1,n2,n3,n4,n5,n6)
# naics <- table(n)
# naics <- data.frame(naics)
# write.csv(naics,file="naics.csv")

# next step: look up naics codes manually in database and decide if 
# they should be included in the study. Report on this.
# note the following conventions
# 212 mining
# 31-33 manufacturing
# 324 petroleum & coal products
# 325 chemicals
# 326 plastics


### Part II - Restrict TRI to included industries ### 

# create a list of NAICS codes for petrochemical industries
naics <- read.csv("naics.csv")
petro <- naics$n[naics$include==1]

# copy over the NAICS codes from the TRI dataset
n1 <- tri$PRIMARY_NAICS
n2 <- tri$NAICS_2
n3 <- tri$NAICS_3
n4 <- tri$NAICS_4
n5 <- tri$NAICS_5
n6 <- tri$NAICS_6

keep <- 
( (n1 %in% petro) |
  (n2 %in% petro) |
  (n3 %in% petro) |
  (n4 %in% petro) |
  (n5 %in% petro) |
  (n6 %in% petro) )

petrochemical <- tri[keep,]
save(petrochemical,file="petrochemical.RData")

