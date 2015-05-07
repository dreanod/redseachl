library(raster)
library(yaml)
library(R.matlab)

data_dir <- 'data/chl_oc_cci/aggregate'
chl_file <- paste(data_dir, 'chl_oc_cci.grd', sep='/')
nb_weeks <- 46
config_file <- 'scripts/load/config.yml'
out_dir <- 'data/chl_oc_cci/filled/seasonal_filling'

dir.create(out_dir, recursive=TRUE)

chl_b <- brick(chl_file)
chl_b <- dropLayer(chl_b, c(1,2)) # fist two layers are empty
chl_b <- log(chl_b) # working in log concentrations
nb_layers <- nlayers(chl_b)

config <- yaml.load_file(config_file)
ext <- config$red_sea_extent
ext <- extent(c(ext$lon_min, ext$lon_max, ext$lat_min, ext$lat_max))
chl_b <- crop(chl_b, ext)

climat_b <- brick()
# Compute climatologies
for (w in 1:nb_weeks) {
  ind <- seq(w, nb_layers, nb_weeks)
  weekly_climat <- mean(subset(chl_b, ind), na.rm=TRUE)
  climat_b <- brick(list(climat_b, weekly_climat))
}

# count pixel if observed at least once for each week in a year
mask <- sum(is.na(climat_b))
mask <- mask > 0
mask[100:408, 1:60] <- TRUE # remove Nasser lake

# Filling data with climatology
chl_filled_b <- stack()
for (i in 1:nb_layers) {
  seas_ind <- i %% nb_weeks + 1
  chl_r <- raster(chl_b, layer=i)
  seas_r <- raster(climat_b, layer=seas_ind)
  is_missing <- !mask & is.na(chl_r)
  chl_r[is_missing] <- seas_r[is_missing]
  chl_r[mask] <- NA
  chl_filled_b <- stack(list(chl_filled_b, chl_r))
}
chl_filled_b <- exp(chl_filled_b)

# saving results
fn <- paste(out_dir, 'chl_filled.grd', sep='/')
writeRaster(chl_filled_b, fn, overwrite=TRUE)

chl_r <- as.array(chl_filled_b)
fn <- paste(out_dir, 'chl_filled.mat', sep='/')
writeMat(fn, chl=chl_r)

mask_r <- as.array(mask)
mask_r[mask_r] <- 1
mask_r <- mask_r[,,1]
fn <- paste(out_dir, 'mask.mat', sep='/')
writeMat(fn, mask=mask_r)
