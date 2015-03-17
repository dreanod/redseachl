library(raster)

b <- brick('data/chl_oc_cci/aggregate/chl_oc_cci.grd')
library(yaml)
config <- yaml.load_file('scripts/load/config.yml')
ext <- config$red_sea_extent
ext <- extent(ext$lon_min, ext$lon_max, ext$lat_min, ext$lat_max)
b <- crop(b, ext)

b <- log(b)

mask <- sum(is.na(b))
mask <- mask > 200
mask <- as.array(mask)[,,1]

chl <- as.array(b)

chl_row <- matrix(NA, nrow=sum(!mask), ncol=687)
for (i in 1:687) {
  a <- chl[,,i]
  chl_row[,i] <- a[!mask]
}

#This function is based on the DINEOF (Data Interpolating Empirical Orthogonal Functions)
#procedure described by Beckers and Rixon (2003).
#
#The arguments are:
#Xo - a gappy data field
#nu - a maximum number of EOFs to iterate (leave equalling "NULL" if algorithm shold proceed until convergence)
#ref.pos - a vector of non-gap reference positions by which errors will be assessed via root mean squared error ("RMS"). 
 #If ref.pos = NULL, then either 30 or 1% of the non-gap values (which ever is larger) will be sampled at random.
#delta.rms - is the threshold for RMS convergence.
#
#The results object includes:
#Xa - the data field with interpolated values (via EOF reconstruction) included.
#n.eof - the number of EOFs used in the final solution
#RMS - a vector of the RMS values from the iteration
#NEOF - a vector of the number of EOFs used at each iteration
#
#Beckers, Jean-Marie, and M. Rixen. "EOF Calculations and Data Filling from Incomplete Oceanographic Datasets."
#Journal of Atmospheric and Oceanic Technology 20.12 (2003): 1839-1856.
#
#4.0: Incorporates irlba algorithm and is only the dineof procedure
#
dineof <- function(Xo, n.max=NULL, ref.pos=NULL, delta.rms=1e-5){
 
 library(irlba)
 
 if(is.null(n.max)){
  n.max=dim(Xo)[2]
 } 
 
 na.true <- which(is.na(Xo))
 na.false <- which(!is.na(Xo))
 if(is.null(ref.pos)) ref.pos <- sample(na.false, max(30, 0.01*length(na.false)))
 
 Xa <- replace(Xo, c(ref.pos, na.true), 0)
 rms.prev <- Inf
 rms.now <- sqrt(mean((Xa[ref.pos] - Xo[ref.pos])^2))
 n.eof <- 1
 RMS <- rms.now
 NEOF <- n.eof
 Xa.best <- Xa
 n.eof.best <- n.eof 
 while(rms.prev - rms.now > delta.rms & n.max > n.eof){ #loop for increasing number of eofs
  while(rms.prev - rms.now > delta.rms){ #loop for replacement
   rms.prev <- rms.now
   SVDi <- irlba(Xa, nu=n.eof, nv=n.eof) 
   RECi <- as.matrix(SVDi$u[,seq(n.eof)]) %*% as.matrix(diag(SVDi$d[seq(n.eof)], n.eof, n.eof)) %*% t(as.matrix(SVDi$v[,seq(n.eof)]))
   Xa[c(ref.pos, na.true)] <- RECi[c(ref.pos, na.true)]
   rms.now <- sqrt(mean((Xa[ref.pos] - Xo[ref.pos])^2))
   print(paste(n.eof, "EOF", "; RMS =", round(rms.now, 8)))
   RMS <- c(RMS, rms.now)
   NEOF <- c(NEOF, n.eof)
   gc()
   if(rms.now == min(RMS)) {
    Xa.best <- Xa
    n.eof.best <- n.eof
   }
  }
  n.eof <- n.eof + 1
  rms.prev <- rms.now
  SVDi <- irlba(Xa, nu=n.eof, nv=n.eof) 
  RECi <- as.matrix(SVDi$u[,seq(n.eof)]) %*% as.matrix(diag(SVDi$d[seq(n.eof)], n.eof, n.eof)) %*% t(as.matrix(SVDi$v[,seq(n.eof)]))
  Xa[c(ref.pos, na.true)] <- RECi[c(ref.pos, na.true)]
  rms.now <- sqrt(mean((Xa[ref.pos] - Xo[ref.pos])^2))
  print(paste(n.eof, "EOF", "; RMS =", round(rms.now, 8)))
  RMS <- c(RMS, rms.now)
  NEOF <- c(NEOF, n.eof)
  gc()
  if(rms.now == min(RMS)) {
   Xa.best <- Xa
   n.eof.best <- n.eof
  }
 }
 
 Xa <- Xa.best
 n.eof <- n.eof.best
 rm(list=c("Xa.best", "n.eof.best", "SVDi", "RECi"))
 
 Xa[ref.pos] <- Xo[ref.pos]
 
 RESULT <- list(
  Xa=Xa, n.eof=n.eof, RMS=RMS, NEOF=NEOF
 )
 
 RESULT
}

RESULT <- dineof(chl_row, n.max=25)

chl_filled <- array(NA, c(408, 288, 687))
for (i in 1:687) {
  tmp <- array(NA, c(408, 288))
  tmp[!mask] <- RESULT$Xa[,i]
  chl_filled[,,i] <- tmp
}

values(b) <- chl_filled
b <- exp(b)
writeRaster(b, 'data/chl_oc_cci/clustering/chl_filled.grd', overwrite=TRUE)

library(R.matlab)
writeMat('data/chl_oc_cci/clustering/chl_filled.mat', chl=RESULT$Xa)
write(mask, file='data/chl_oc_cci/clustering/mask.Rdata')

r <- raster(b, layer=87)

library(ggplot2)
library(RColorBrewer)
library(scales)

load('data/common/shapefiles/red_sea_outside.Rdata')
df <- as.data.frame(r, xy=TRUE)
names(df) <- c('long', 'lat', 'chl')

p <- ggplot() + geom_tile(aes(x=long, y=lat, fill=chl), data=df)
p <- p + scale_fill_gradientn(colours=rev(brewer.pal(7, 'Spectral')),
                              limits=c(0.05, 10), trans='log',
                              name='chl (mg/m^3)', breaks=c(0.1, 1, 10),
                              labels=c('0.1', '1', '10'))
p <- p + coord_cartesian()
p <- p + geom_polygon(aes(x=long, y=lat, group=group), red.sea.outside,
                  fill='white', contour='black')
ggsave('derived/clustering/filled_1999-07-12.png', plot=p)
