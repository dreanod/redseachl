library(raster)
library(reshape2)

chl_b <- brick('data/chl/transform/chl')
coords <- coordinates(chl_b)

chl_df <- as.data.frame(chl_b)
colnames(chl_df) <- getZ(chl_b)

# Excluding points on land (pixels never observed)
sum_of_rows <- rowSums(chl_df, na.rm=TRUE)
land_index <- which(sum_of_rows != 0)
coords <- coords[land_index,]
chl_df <- chl_df[land_index,]

chl_df <- cbind(coords, chl_df)
chl_df2 <- melt(chl_df, id.vars=c('x', 'y'), 
                variable.name='date', value.name='chl')

dir.create('data/chl/formated')
save(chl_df2, file='data/chl/formated/chlMelt.Rda')
save(chl_df,  file='data/chl/formated/chlCast.Rda')
