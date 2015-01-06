load('data/chl/formated/chlCast.Rda')

chl <- chl_df
dates <- colnames(chl_df)[3:length(dates)]
chl <- data.matrix(chl)
lon <- chl[,1]
lat <- chl[,2]
chl <- chl[,3:ncol(chl)]

## Plot Dio's regions

regions <- vector(length = length(lat))
regions[lat < 27.75 & lat >= 25.5]  <- 'NRS'
regions[lat < 25.5  & lat >= 22 & lon >= 33]    <- 'NCRS'
regions[lat < 22    & lat >= 17.5]  <- 'SCRS'
regions[lat < 17.5  & lat >= 13.25 & lon < 45] <- 'SRS'

library(ggplot2)
data <- data.frame(x=lon, y=lat, region=regions)
p <- ggplot(aes(x, y, fill=region), data = data)
p <- p + geom_tile()
p

## Generate time series according to Dio's regions
rat_NA <- function(x) {
  return(sum(is.na(x))/length(x))
}

sum_reg <- function(df) {
  df_mean <- colMeans(df, na.rm=TRUE)
  df_std  <- apply(df, 2, sd, na.rm=TRUE)
  df_mis  <- apply(df, 2, rat_NA)
  return(data.frame(date=dates, mean=df_mean, std=df_std, mis=df_mis))
}

chl_NRS <- chl[regions == 'NRS',]
chl_NRS <- sum_reg(chl_NRS)

chl_NCRS <- chl[regions == 'NCRS',]
chl_NCRS <- sum_reg(chl_NCRS)

chl_SCRS <- chl[regions == 'SCRS',]
chl_SCRS <- sum_reg(chl_SCRS)

chl_SRS <- chl[regions == 'SRS',]
chl_SRS <- sum_reg(chl_SRS)

dir.create('results/export')
dir.create('results/export/chl_ts')
save(chl_NRS, chl_NCRS, chl_SCRS, chl_SRS, 
     file='results/export/chl_ts/diosReg.Rda')

## Time series according to clustering