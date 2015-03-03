library(ggplot2)
library(R.matlab)

data <- readMat('scripts/proposal/data/data1.mat')

free <- data$free
chl_lev0_free <- free[,12,1]

assim <- data$assim
chl_lev0_assim <- assim[,12,1]
chl_lev0_assim <- c(chl_lev0_assim, rep(NA, 3))

drange <- seq(as.Date('2003-01-01'), by='day', along.with=chl_lev0_free)
df <- data.frame(date=drange, chl_free=chl_lev0_free,
                 chl_assim=chl_lev0_assim)

modis <- c(data$modis, NA)
ncrs <- read.csv('scripts/proposal/data/chlNCRS.csv')
modis_dates <- as.Date(ncrs$date)
modis_dates <- modis_dates[modis_dates<as.Date('2005-01-01') & modis_dates>=as.Date('2003-01-01')]
df_obs <- data.frame(date=modis_dates, chl=modis)

p <- ggplot() + geom_line(aes(x=date, y=chl_assim, color='Assimilated'), df)
p <- p + geom_line(aes(x=date, y=chl_free, color='Free run'), df, ylim=c(0, 0.5))
p <- p + geom_point(aes(x=date, y=chl, color='Observations'), df_obs)
p <- p + scale_colour_manual(name='', values=c('Assimilated'='red',
                             'Free run'='blue', 'Observations'='green'))
p <- p + ylab('chl concentration in mg/m3')
p <- p + coord_cartesian(ylim=c(0, 0.5))
p <- p + ggtitle('Central Red Sea')
ggsave('results/proposal/figures/chl_models1.png', p, units='cm', height=16,
       width=28)

###############################################################

data <- readMat('scripts/proposal/data/data2.mat')

free <- data$free
chl_lev0_free <- free[,12,1]

assim <- data$assim
chl_lev0_assim <- assim[,12,1]
chl_lev0_assim <- c(chl_lev0_assim, rep(NA, 3))

df <- data.frame(date=drange, chl_free=chl_lev0_free,
                 chl_assim=chl_lev0_assim)

modis <- c(data$modis, NA)
df_obs <- data.frame(date=modis_dates, chl=modis)

p <- ggplot() + geom_line(aes(x=date, y=chl_assim, color='Assimilated'), df)
p <- p + geom_line(aes(x=date, y=chl_free, color='Free run'), df, ylim=c(0, 0.5))
p <- p + geom_point(aes(x=date, y=chl, color='Observations'), df_obs)
p <- p + scale_colour_manual(name='', values=c('Assimilated'='red',
                             'Free run'='blue', 'Observations'='green'))
p <- p + ylab('chl concentration in mg/m3')
#p <- p + coord_cartesian(ylim=c(0, 0.5))
p <- p + ggtitle('Northern Red Sea')
ggsave('results/proposal/figures/chl_models2.png', p, units='cm', height=16,
       width=28)

###############################################################

data <- readMat('scripts/proposal/data/data3.mat')

free <- data$free
chl_lev0_free <- free[,12,1]

assim <- data$assim
chl_lev0_assim <- assim[,12,1]
chl_lev0_assim <- c(chl_lev0_assim, rep(NA, 3))

df <- data.frame(date=drange, chl_free=chl_lev0_free,
                 chl_assim=chl_lev0_assim)

modis <- c(data$modis, NA)
df_obs <- data.frame(date=modis_dates, chl=modis)

p <- ggplot() + geom_line(aes(x=date, y=chl_assim, color='Assimilated'), df)
p <- p + geom_line(aes(x=date, y=chl_free, color='Free run'), df, ylim=c(0, 0.5))
p <- p + geom_point(aes(x=date, y=chl, color='Observations'), df_obs)
p <- p + scale_colour_manual(name='', values=c('Assimilated'='red',
                             'Free run'='blue', 'Observations'='green'))
p <- p + ylab('chl concentration in mg/m3')
#p <- p + coord_cartesian(ylim=c(0, 0.5))
p <- p + ggtitle('Southern Red Sea')
p <- p + coord_cartesian(ylim=c(0, 0.85))
ggsave('results/proposal/figures/chl_models3.png', p, units='cm', height=16,
       width=28)