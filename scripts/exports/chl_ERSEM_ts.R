library(reshape2)

load('data/chl/formated/chlCast.Rda')

chl <- chl_df
dates <- colnames(chl_df)[3:ncol(chl_df)]
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
write.csv(chl_NRS, file='results/export/chl_ts/chlNRS.csv', row.names=FALSE)

chl_NCRS <- chl[regions == 'NCRS',]
chl_NCRS <- sum_reg(chl_NCRS)
write.csv(chl_NCRS, file='results/export/chl_ts/chlNCRS.csv', row.names=FALSE)

chl_SCRS <- chl[regions == 'SCRS',]
chl_SCRS <- sum_reg(chl_SCRS)
write.csv(chl_SCRS, file='results/export/chl_ts/chlSCRS.csv', row.names=FALSE)

chl_SRS <- chl[regions == 'SRS',]
chl_SRS <- sum_reg(chl_SRS)
write.csv(chl_SRS, file='results/export/chl_ts/chlSRS.csv', row.names=FALSE)

## Generate figures about summaries
chl_NRS$reg <- 'NRS'
chl_NRS <- melt(chl_NRS, id.vars=c('date', 'reg'))
chl_NCRS$reg <- 'NCRS'
chl_NCRS <- melt(chl_NCRS, id.vars=c('date', 'reg'))
chl_SCRS$reg <- 'SCRS'
chl_SCRS <- melt(chl_SCRS, id.vars=c('date', 'reg'))
chl_SRS$reg <- 'SRS'
chl_SRS <- melt(chl_SRS, id.vars=c('date', 'reg'))
chl <- rbind(chl_NRS, chl_NCRS, chl_SCRS, chl_SRS)

p <- ggplot(subset(chl, variable=='mean'), aes(as.Date(date), value, group=reg))
p <- p + geom_line(linewidth=.001)
p <- p + facet_grid(reg ~ .)
p <- p + ggtitle('logCHL mean for each region')
ggsave('results/export/chl_ts/mean.png')

p <- ggplot(subset(chl, variable=='std'), aes(as.Date(date), value, group=reg))
p <- p + geom_line(linewidth=.001)
p <- p + facet_grid(reg ~ .)
p <- p + ggtitle('standard deviation of logCHL mean')
ggsave('results/export/chl_ts/std.png')

p <- ggplot(subset(chl, variable=='mis'), aes(as.Date(date), value, group=reg))
p <- p + geom_line(linewidth=.001)
p <- p + facet_grid(reg ~ .)
p <- p + ggtitle('ratio of missing values for each region')
ggsave('results/export/chl_ts/mis.png')

## Generate climatological data