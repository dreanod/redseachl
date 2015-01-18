library(maptools)
library(PBSmapping)
library(R.utils)

data_dir <- 'data/common'
dir.create(data_dir)

crs <- CRS("+proj=longlat +datum=WGS84")

x_min <- 31
x_max <- 45
y_min <- 10
y_max <- 31

bbox <- matrix(c(x_min,x_max,x_max,x_min,x_min,
                 y_min,y_min,y_max,y_max,y_min),
               nrow = 5, ncol =2)
bbox <- Polygon(bbox, hole=FALSE)
bbox <- Polygons(list(bbox), "bbox")
bbox <- SpatialPolygons(Srl=list(bbox), pO=1:1, proj4string=crs)

#---- Shapefiles for Red Sea ----#

countries <- getData("countries", path=data_dir)
proj4string <- crs
gI <- gIntersects(countries , bbox , byid = TRUE )
red.sea.countries <- countries[ which(gI) , ]
red.sea.countries <- SpatialPolygons2PolySet(red.sea.countries)
red.sea.countries <- clipPolys(red.sea.countries, xlim = c(x_min, x_max), ylim = c(y_min, y_max))
red.sea.outside <- PolySet2SpatialPolygons(red.sea.countries, close_polys=TRUE)
projection(red.sea.outside) <- crs
red.sea.inside  <- gDifference(bbox, red.sea.outside)

plot(red.sea.outside)
plot(red.sea.inside)

save(red.sea.outside, file=paste(data_dir, "red_sea_outside.Rdata", sep="/"))
save(red.sea.inside,  file=paste(data_dir, "red_sea_inside.Rdata",  sep="/"))

