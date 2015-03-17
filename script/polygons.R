##### polygons.R
### functions for handling the polygon operations

gDiameter <- function(poly){
  # Find a simple diameter bound of a geometry
  # (the diagonal of its bounding box)
  sqrt(sum((poly@bbox[,2]-poly@bbox[,1])^2))
}


RestrictPoints <- function(polygon,points,d=0) {
  # Restrict potential points to those in a region of interest.
  # Points relevant to buffer: distance plus polygon diameter
  d <- d + gDiameter(polygon)
  
  # find flags for points within buffer distance
  distances <- spDistsN1(points,gCentroid(polygon))
  inbuffer  <- distances < d
  
  # Expand search to points that could influence minimum distance
  # these are within one diameter of identified minimum.
  d2 <- min(distances) + gDiameter(polygon)
  proximate <- distances < d2
  
  return(points[inbuffer | proximate,])  
}


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
  result <- cbind(closest,dens.mat)
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

resample.block <- function(n0,n1,df) {
  # internal function to resample block distribution.
  width <- dim(df)[2]
  race <- c(rep(0,n0),rep(1,n1)) 
  samp <- apply(df,2,function(i) sample(i,length(race),replace=TRUE))
  mat <- matrix(samp,ncol=width)
  cbind(race,mat) 
}


resample <- function(n0,n1,bayes) {
  # function to resample an entire geometry
  do.call(rbind,lapply(1:length(bayes), function(i) resample.block(n0[i],n1[i],bayes[[i]])))
}

calculate <- function(n0,n1,bayes) {
  # calculate the aggregate statistics
  result <- resample(n0,n1,bayes)
  tab <- apply(result[,-1],2, function(i) aggregate(i,by=list(result[,1]),mean))
  tab <- do.call(cbind,tab)
  tab <- tab[c(1,seq(from=2,to=dim(tab)[2],by=2))] # remove redeundant columns
  colnames(tab) <- c("Group",colnames(bayes[[1]]))
  tab
}

