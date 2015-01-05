
load('data/chl/formated/chl.Rda')

## Generate time series according to Dio's regions

chl_NRS <- subset(chl_df2, y < 27.75 & y > 25.5)
dates <- unique(chl_NRS$date)

chl_agg = NULL
chl_percNA = NULL
chl_std = NULL

for (d in dates[1:10]) {
  chl_d <- subset(chl_NRS, date == d)
  chl_agg <- c(chl_agg, mean(chl_d$chl, na.rm=TRUE))
  chl_std <- c(chl_std, sd(chl_d$chl, na.rm=TRUE))
  chl_percNA <- c(chl_percNA, sum(is.na(chl_d$chl))/length(is.na(chl_d$chl)))
}

## Time series according to clustering