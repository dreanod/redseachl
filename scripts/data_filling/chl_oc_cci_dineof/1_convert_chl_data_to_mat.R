library(raster)
library(yaml)
library(R.matlab)

out_dir <- 'derived/data_filling/chl_oc_cci'
chl_f <- 'data/chl_oc_cci/aggregate/chl_oc_cci.grd'
config_f <- 'scripts/load/config.yml'
mask_f <- 'mask.mat'
chl_out_f <- 'chl.mat'
threshold_missing <- 0.5

dir.create(out_dir, recursive=TRUE)

chl_b <- brick(chl_f)

ext <- yaml.load_file(config_f)$red_sea_extent
ext <- extent(c(ext$lon_min, ext$lon_max, ext$lat_min, ext$lat_max))

chl_b <- crop(chl_b, ext)
chl_a <- as.array(chl_b)
chl_a <- chl_a[,,3:687] # remove two first images that are empty

mask <- apply(is.na(chl_a), c(1,2), sum)
# pixel masked if missing more than threshold
# mask has value true if pixel is not observable
mask <- mask > threshold_missing * dim(chl_a)[3]
mask[mask] <- 1

chl_a[is.na(chl_a)] <- NaN

writeMat(paste(out_dir, mask_f, sep='/'), mask=mask)
writeMat(paste(out_dir, chl_out_f, sep='/'), chl=chl_a)