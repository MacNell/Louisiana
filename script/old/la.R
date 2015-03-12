# la.R

# functions for the louisiana project

# TODO: Fix this function again
weighted = distanceDataFrame$mu*distanceDataFrame$n
    n = sum(distanceDataFrame$n)
    mu = sum(weighted)/n
    # we need to calculate the sum of the variances in a similar way
    # Var[mu] = Var[sum(1/n xi)]
    #        = sum(1/n^2 Var[xi])
    #        = 1/n^2 sum(Var[xi])
    weighted = distanceDataFrame$v*distanceDataFrame$n
    v = sum(weighted)/n^2
    return(data.frame(mu,v)
}

polygonNumber = function(polygon, points, d,times=1000) {
# returns the mean and variance of the number of facilities within d miles
# for a single polygon and a selection of tri points
    points = restrictPoints(polygon, points, d) # trim to important points
    people = spsample(polygon,times)
    distances = spDists(people, points)
    close = apply(distances,1,function(x) (x<d)*1)
    number = apply(close,2,sum)
    mu = mean(number)
    v = var(number)
    return(data.frame(mu,v))
} 

number = function(polygons,points,d,n)
# returns a data frame of number values for an entire polygons object
# outputs mu, var, n values
    result = lapply(1:length(polygons),function(x)
        polygonNumber(polygons[x,],points,d))
    return(data,frame(unlist(result),n))

# TODO: stats(number)
