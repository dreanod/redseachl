load('data/chl/formated/chl.Rda')

chl <- chl_df2

## Plot Dio's regions

chl$region <- NA
chl$region[chl$y < 27.75 & chl$y >= 25.5]  <- 'NRS'
chl$region[chl$y < 25.5  & chl$y >= 22]    <- 'NCRS'
chl$region[chl$y < 22    & chl$y >= 17.5]  <- 'SCRS'
chl$region[chl$y < 17.5  & chl$y >= 13.25] <- 'SRS'

p <- ggplot(aes(x, y, fill=region), data = chl)
p <- p + geom_tile()
# p <- p + scale_fill_manual(values=rev(brewer.pal(7, "RdYlBu")), 
#                            labels=seq(7))
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