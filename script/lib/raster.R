# file for using raster package

install.packages("raster")
library(sp)
library(raster)

filename <- system.file("external/test.grd",package="raster")
r <- raster(filename)

pdf("raster.pdf")
plot(r)
dev.off()



