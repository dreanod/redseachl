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
p <- p + scale_fill_discrete(breaks=c('FALSE', 'NRS', 'NCRS', 'SCRS', 'SRS'),
                             labels=c('NA', 'North Red Sea', 
                                      'North Central Red Sea', 
                                      'South Central Red Sea', 'South Red Sea'))
p <- p + geom_tile()
p <- p + ggtitle('Regions as defined by Raitsos')
p <- p + ylab('latitude') + xlab('longitude')
ggsave('results/export/chl_ts/regions.png')

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

## Generate climatological data
chl_NRS_clim <- NULL
for (i in 1:46) {
  chl_NRS_clim[i] <- mean(chl_NRS$mean[seq(1, nrow(chl_NRS), 46)])
}

chl_NRS <- chl[regions == 'NRS',]
chl_NRS <- sum_reg(chl_NRS)
chl_NRS$mean <- exp(chl_NRS$mean)
write.csv(chl_NRS, file='results/export/chl_ts/chlNRS.csv', row.names=FALSE)
chl_NRS$mean <- log(chl_NRS$mean)

chl_NCRS <- chl[regions == 'NCRS',]
chl_NCRS <- sum_reg(chl_NCRS)
chl_NCRS$mean <- exp(chl_NCRS$mean)
write.csv(chl_NCRS, file='results/export/chl_ts/chlNCRS.csv', row.names=FALSE)
chl_NCRS$mean <- log(chl_NCRS$mean)

chl_SCRS <- chl[regions == 'SCRS',]
chl_SCRS <- sum_reg(chl_SCRS)
chl_SCRS$mean <- exp(chl_SCRS$mean)
write.csv(chl_SCRS, file='results/export/chl_ts/chlSCRS.csv', row.names=FALSE)
chl_SCRS$mean <- log(chl_SCRS$mean)

chl_SRS <- chl[regions == 'SRS',]
chl_SRS <- sum_reg(chl_SRS)
chl_SRS$mean <- exp(chl_SRS$mean)
write.csv(chl_SRS, file='results/export/chl_ts/chlSRS.csv', row.names=FALSE)
chl_SRS$mean <- log(chl_SRS$mean)

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
p <- p + ylab('logchl (mg/m^3)') + xlab('date')
ggsave('results/export/chl_ts/mean.png')

p <- ggplot(subset(chl, variable=='std'), aes(as.Date(date), value, group=reg))
p <- p + geom_line(linewidth=.001)
p <- p + facet_grid(reg ~ .)
p <- p + ggtitle('standard deviation of logCHL mean')
p <- p + ylab('std (mg/m^3)') + xlab('date')
ggsave('results/export/chl_ts/std.png')

p <- ggplot(subset(chl, variable=='mis'), aes(as.Date(date), value, group=reg))
p <- p + geom_line(linewidth=.001)
p <- p + facet_grid(reg ~ .)
p <- p + ggtitle('ratio of missing values for each region')
p <- p + ylab('ratio') + xlab('date')
ggsave('results/export/chl_ts/mis.png')

## Generate climatological data
chl_NRS <- read.csv('results/export/chl_ts/chlNRS.csv')
meanNRS <- chl_NRS$mean
chl_NRS_clim <- NULL
for (i in 1:46) {
  chl_NRS_clim = c(chl_NRS_clim, mean(meanNRS[seq(i, nrow(chl_NRS), 46)], 
                                      na.rm=TRUE))
}

chl_NCRS <- read.csv('results/export/chl_ts/chlNCRS.csv')
meanNCRS <- chl_NCRS$mean
chl_NCRS_clim <- NULL
for (i in 1:46) {
  chl_NCRS_clim = c(chl_NCRS_clim, mean(meanNCRS[seq(i, nrow(chl_NCRS), 46)], 
                                        na.rm=TRUE))
}

chl_SCRS <- read.csv('results/export/chl_ts/chlSCRS.csv')
meanSCRS <- chl_SCRS$mean
chl_SCRS_clim <- NULL
for (i in 1:46) {
  chl_SCRS_clim = c(chl_SCRS_clim, mean(meanSCRS[seq(i, nrow(chl_SCRS), 46)],
                                        na.rm=TRUE))
}

chl_SRS <- read.csv('results/export/chl_ts/chlSRS.csv')
meanSRS <- chl_SRS$mean
chl_SRS_clim <- NULL
for (i in 1:46) {
  chl_SRS_clim = c(chl_SRS_clim, mean(meanSRS[seq(i, nrow(chl_SRS), 46)],
                                      na.rm=TRUE))
}

chl_clim <- data.frame(date=dates[1:46], NRS=chl_NRS_clim, NCRS=chl_NCRS_clim,
                       SCRS=chl_SCRS_clim, SRS=chl_SRS_clim)

p <- ggplot(chl_clim, aes(as.Date(date), exp(NRS))) + geom_line()
p <- p + ggtitle('CHL climatology of NRS')
p <- p + ylab('chl concentration (mg/m^3)') + xlab('month (discard the year)')
ggsave('results/export/chl_ts/NRS_climatology.png')

p <- ggplot(chl_clim, aes(as.Date(date), exp(NCRS))) + geom_line()
p <- p + ggtitle('CHL climatology of NCRS')
p <- p + ylab('chl concentration (mg/m^3)') + xlab('month (discard the year)')
ggsave('results/export/chl_ts/NCRS_climatology.png')

p <- ggplot(chl_clim, aes(as.Date(date), exp(SCRS))) + geom_line()
p <- p + ggtitle('CHL climatology of SCRS')
p <- p + ylab('chl concentration (mg/m^3)') + xlab('month (discard the year)')
ggsave('results/export/chl_ts/SCRS_climatology.png')

p <- ggplot(chl_clim, aes(as.Date(date), exp(SRS))) + geom_line()
p <- p + ggtitle('CHL climatology of SRS')
p <- p + ylab('chl concentration (mg/m^3)') + xlab('month (discard the year)')
ggsave('results/export/chl_ts/SRS_climatology.png')

chl_clim$NRS  <- exp(chl_clim$NRS)
chl_clim$NCRS <- exp(chl_clim$NCRS)
chl_clim$SCRS <- exp(chl_clim$SCRS)
chl_clim$SRS  <- exp(chl_clim$SRS)
 
write.csv(chl_clim, 'results/export/chl_ts/climatology.csv', row.names=FALSE)
