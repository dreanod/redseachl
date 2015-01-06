load('data/chl/formated/chlCast.Rda')

chl <- chl_df
dates <- colnames(chl_df)
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

chl_NRS  <- chl[regions == 'NRS',]
chl_NRS <- sum_reg(chl_NRS)

chl_NCRS <- chl[regions == 'NCRS',]
chl_mean <- colMeans(chl_NCRS, na.rm=TRUE)
chl_std  <- apply(chl_NCRS, 2, sd, na.rm =TRUE)
chl_mis  <- apply(chl_NCRS, 2, rat_NA)
chl_NCRS <- data.frame(date=dates, mean=chl_mean, std=chl_std, mis=chl_mis)

chl_SCRS <- chl[regions == 'SCRS',]
chl_mean <- colMeans(chl_NRS, na.rm=TRUE)
chl_std  <- apply(chl_NRS, 2, sd, na.rm =TRUE)
chl_mis  <- apply(chl_NRS, 2, rat_NA)
chl_NRS <- data.frame(date=date, mean=chl_mean, std=chl_std, mis=chl_mis)

chl_SRS  <- chl[regions == 'SRS',]
chl_mean <- colMeans(chl_NRS, na.rm=TRUE)
chl_std  <- apply(chl_NRS, 2, sd, na.rm =TRUE)
chl_mis  <- apply(chl_NRS, 2, rat_NA)
chl_NRS <- data.frame(date=date, mean=chl_mean, std=chl_std, mis=chl_mis)

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