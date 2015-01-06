load('data/chl/formated/chlCast.Rda')

chl <- chl_df
chl <- data.matrix(chl)
lon <- chl[,1]
lat <- chl[,2]
chl <- chl[,3:ncol(chl)]

## Plot Dio's regions

regions <- vector(length = length(lat))
regions[lat < 27.75 & lat >= 25.5]  <- 'NRS'
regions[lat < 25.5  & lat >= 22 & lon >= 33]    <- 'NCRS'
regions[lat < 22    & lat >= 17.5]  <- 'SCRS'
regions[lat < 17.5  & lat >= 13.25] <- 'SRS'

library(ggplot2)
data <- data.frame(x=lon, y=lat, region=regions)
p <- ggplot(aes(x, y, fill=region), data = data)
p <- p + geom_tile()
p

## Generate time series according to Dio's regions

chl_NRS <- subset(chl, region == 'NRS')
chl_NCRS <- subset(chl, )
chl_SCRS <- subset(chl_df2, y < 22 & y >= 17.5)
chl_SRS <- subset(chl_df2, y < 17.5 & y >= 13.25)
dates <- unique(chl_NRS$date)

aggregate_chl <- function(chl_df) {
  chl_agg = NULL
  chl_percNA = NULL
  chl_std = NULL
  
  for (d in dates) {
    chl_d <- subset(chl_df, date == d)
    chl_agg <- c(chl_agg, mean(chl_d$chl, na.rm=TRUE))
    chl_std <- c(chl_std, sd(chl_d$chl, na.rm=TRUE))
    chl_percNA <- c(chl_percNA, sum(is.na(chl_d$chl))/length(is.na(chl_d$chl)))
  }
  
  aggregate <- data.frame(dates=dates, logChl=chl_agg, std=chl_std, 
                          percNA=chl_percNA)
  return(aggregate)
}

chl_NRS <- aggregate_chl(chl_NRS)
chl_NCRS <- aggregate_chl(chl_NCRS)
chl_SCRS <- aggregate_chl(chl_SCRS)
chl_SRS <- aggregate_chl(chl_SRS)

dir.create('results/export')
dir.create('results/export/chl_ts')
save(chl_NRS, chl_NCRS, chl_SCRS, chl_SRS, 
     file='results/export/chl_ts/diosReg.Rda')

## Time series according to clustering