# polygons.R
# routines for handling the polygon operations

# Calculate a list of distances & minimum distance
# TODO: fix bug when there are no/few "hits"
PolygonProximity <- function(poly,pts,d=0,n=100) {
  hazards <- RestrictPoints(poly,pts,d=max(d))
  people <- spsample(poly,n,type="regular")
  dist.mat <- spDists(people,hazards)
  # closest facility
  closest <- apply(spDists(people,hazards),1,min)
  # run through each distance value
  dens.mat <- sapply(d, function(i)
    apply(dist.mat < i,1,sum)
  )  
  # organize into a data frame
  result <- cbind(closest,as.numeric(dens.mat))
  colnames(result) <- c("d",d)
  return(result)  
}
 
# apply to a whole polygons object at once
# returns a list of matrices, one for each polygon
PolygonsProximity <- function(shape,points,d=0,n=100) {
  # TODO: is this the most efficient approach?
  sapply(1:length(shape),simplify=TRUE,function(i)
    PolygonProximity(shape[i,],points,d=d,n=n)
  )
}
