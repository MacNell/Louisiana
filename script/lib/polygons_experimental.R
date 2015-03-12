# polygons.R
# routines for handling the polygon operations
# transforms spatial polygons into a spatial grid object


# function to calculate the distribution of density
# or closest point (by defauly when d=0)
# defaults to large iteration n so it won't fail on strange geometries
DescribePolygon <- function(poly,pts,d,n=1000) {
    pts <- RestrictPoints(poly,pts,d)  # simplify distance matrix
    people <- spsample(poly,n,type="regular")  # regular is faster
    
    # first create a matrix of distances between each simulated person
    # and each tri site (rows=people, columns=tri sites)
    # application needs to be across rows (so that we have the same
    # number of rows as people!). This is margin 1

    dists <- spDists(people,pts)
        
    # calculate distance to the closest site
    if(d==0){
        dists <- apply(dists,1,min)  # extract the closest distance for each person 
        mu <- mean(dists)  # find the mean of these closest distances
        s2 <- var(dists)   # find the variance
        return(data.frame(mu,s2))
    }

    # calculate the number of points within distance
    if(d!=0){
        close <- (dists<d)*1  # 1 if close
        near <- sum(close)  # total number of close ones
        return(near/n) # probability of being close
    }

    # return the results
    
}

# function to apply the polygon description to an entire shapefile
DescribeShapefile <- function(shape,points,d=0,n=1000) {
    # TODO: is this the most efficient approach?
    distances = sapply(1:length(shape),simplify=TRUE,function(i)
        DescribePolygon(shape[i,],points,d,n)
        )
    return(data.frame(t(distances)))  # orient the output
}
