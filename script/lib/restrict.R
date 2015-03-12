### restrict.R
# functions to restrict the set of points to worry about

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
