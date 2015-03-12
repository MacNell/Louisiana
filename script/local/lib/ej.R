# ej.R
# ej class definition

# requires: aggregate.R

ej <- setClass("ej", 
	slots = c(mu="numeric", s2="numeric",nframe="data.frame"))

ejmap <- setClass("ejmap",
	slots = c(ej="ej", map="SpatialPolygons"))

summary.ej <- function(ej) {
	aggregate.ej(mu=ej@mu,s2=ej@s2,nframe=ej@nframe)
}