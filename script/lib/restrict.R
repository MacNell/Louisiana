# restrict.R
# functions to restrict the set of points to worry about

# function to find the "diameter" of a geometry
# really, the diagonal of its bounding box
# this is more efficient and minially increases search area
gDiameter <- function(poly){
    sqrt(sum((poly@bbox[,2]-poly@bbox[,1])^2))
}

# function to restrict points to points of interest
# if no buffer distance, return points relevant for closest-distance
# this is 2.5 times the diameter distance from the centroid
RestrictPoints <- function(poly,points,d=0) {

	# first ,establish true search distance
    if(d==0) {  
		# if no distance is specified, use 2.5 times diameter
        d <- 2.5*gDiameter(poly)
    }
    else{
		# increase search distance by diameter of polygon
		# helps handle elongated polygons
        d <- d+gDiameter(poly)
    }

	# calculate distance from centroid to points
    dists <- spDistsN1(points,gCentroid(poly))
    close <- dists<d

    if(sum(close)==0) {  
		#if there are no points, return closest point(s)
        points <- points[dists==min(dists),]
    }
    else{
		# return points of interest.
        points <- points[close,]
    }
    return(points)
}
