library(raster)

dir.create('derived/eof/chl_clusters_eof', recursive=TRUE)

chl <- brick('data/chl_oc_cci/filled/seasonal_filling/chl_filled.grd')
clusters <- raster('derived/clustering/with_seasonal_filling/clusters.grd')

clusters[is.na(clusters)] <- -1

cluster_eof <- function(id) {
  mask <- as.matrix(clusters == id)
  data <- array(NA, c(sum(mask), nlayers(chl)))
  for (i in 1:nlayers(chl)) {
    r <- raster(chl, layer=i)
    r <- as.array(r)[,,1]
    data[,i] <- r[mask]
  }
  data <- scale(log(t(data)), scale=FALSE)
  res <- svd(data)
  return(res)
}

save_eof_map <- function(u, fn, id) {
  mask <- as.matrix(clusters == id)
  eof <- clusters
  loadings <- array(NA, dim(clusters)[1:2])
  loadings[mask] <- u
  values(eof) <- loadings
  writeRaster(eof, fn, overwrite=TRUE)
}

df <- read.csv('data/chl_oc_cci/projected/chl_oc_cci.csv')
df <- df[,1:3]

res <- cluster_eof(1)
save_eof_map(res$v[,1], 'derived/eof/chl_clusters_eof/eof_1.1.grd', 1)
save_eof_map(res$v[,2], 'derived/eof/chl_clusters_eof/eof_1.2.grd', 1)
df$eof_1.1 <- res$u[,1]
df$eof_1.2 <- res$u[,2]

res <- cluster_eof(2)
save_eof_map(res$v[,1], 'derived/eof/chl_clusters_eof/eof_2.1.grd', 2)
save_eof_map(res$v[,2], 'derived/eof/chl_clusters_eof/eof_2.2.grd', 2)
df$eof_2.1 <- res$u[,1]
df$eof_2.2 <- res$u[,2]

res <- cluster_eof(3)
save_eof_map(res$v[,1], 'derived/eof/chl_clusters_eof/eof_3.1.grd', 3)
save_eof_map(res$v[,2], 'derived/eof/chl_clusters_eof/eof_3.2.grd', 3)
df$eof_3.1 <- res$u[,1]
df$eof_3.2 <- res$u[,2]

res <- cluster_eof(4)
save_eof_map(res$v[,1], 'derived/eof/chl_clusters_eof/eof_4.1.grd', 4)
save_eof_map(res$v[,2], 'derived/eof/chl_clusters_eof/eof_4.2.grd', 4)
df$eof_4.1 <- res$u[,1]
df$eof_4.2 <- res$u[,2]

write.csv(df, 'derived/eof/chl_clusters_eof/eofs.csv', row.names=FALSE)