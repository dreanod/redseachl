library(raster)
library(maptools)
library(PBSmapping)
library(R.utils)
library(yaml)
library(rgeos)

config <- yaml.load_file('scripts/load/config.yml')
extent <- config$large_extent

data_dir <- 'data/common/shapefiles'
dir.create(data_dir, recursive=TRUE)

crs <- CRS("+proj=longlat +datum=WGS84")

x_min <- extent$lon_min
x_max <- extent$lon_max
y_min <- extent$lat_min
y_max <- extent$lat_max

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

plot(red.sea.outside)

save(red.sea.outside, file=paste(data_dir, "red_sea_outside.Rdata", sep="/"))

