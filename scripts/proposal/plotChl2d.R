library(R.matlab)
library(ggplot2)
library(reshape2)
library(RColorBrewer)

data <- readMat('scripts/proposal/data/data1.mat')

assim <- data$assim
chl <- assim[,12,]

drange <- seq(as.Date('2003-01-01'), by='day', length.out=dim(chl)[1])
zrange <- c(1, 5, 10, 15, 20, 25, 30, 35, 40,
            50, 80, 100, 120, 160, 200, 240, 280,
            340, 420, 500, 620, 850, 1250, 1750, 2000)
clevs <- c(0, 0.01, 0.02, 0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.5, 0.7, 20)

rownames(chl) <- as.character(drange)
colnames(chl) <- zrange

df <- melt(chl, value.name='chl', varnames=c('date', 'level'))
df <- subset(df, chl>0 & level<120)
df$level <- as.factor(df$level)
df$date <- as.Date(df$date)
df$clevs <- cut(df$chl, clevs)

p <- ggplot(df, aes(x=date, y=level, fill=clevs)) + geom_tile()
p <- p + scale_y_discrete(limits = rev(levels(df$level)))
p <- p + scale_fill_brewer(name='chl (mg/m3)', palette='PRGn')
p <- p + ggtitle('Assimilated chlorophyll for the Central Red Sea')
p <- p + ylab('level (m)')
p <- p + theme(text=element_text(size=16))
ggsave('results/proposal/figures/chl1.png', p)

##########################################################################

data <- readMat('scripts/proposal/data/data2.mat')

assim <- data$assim
chl <- assim[,12,]

rownames(chl) <- as.character(drange)
colnames(chl) <- zrange

df <- melt(chl, value.name='chl', varnames=c('date', 'level'))
df <- subset(df, chl>0 & level<120)
df$level <- as.factor(df$level)
df$date <- as.Date(df$date)
df$clevs <- cut(df$chl, clevs)

p <- ggplot(df, aes(x=date, y=level, fill=clevs)) + geom_tile()
p <- p + scale_y_discrete(limits = rev(levels(df$level)))
p <- p + scale_fill_brewer(name='chl (mg/m3)', palette='PRGn')
p <- p + ggtitle('Assimilated chlorophyll for the Northern Red Sea')
p <- p + ylab('level (m)')
p <- p + theme(text=element_text(size=16))
ggsave('results/proposal/figures/chl2.png', p)

##########################################################################

data <- readMat('scripts/proposal/data/data3.mat')

assim <- data$assim
chl <- assim[,12,]

rownames(chl) <- as.character(drange)
colnames(chl) <- zrange

clevs <- c(0, 0.03, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 1.5, 20)

df <- melt(chl, value.name='chl', varnames=c('date', 'level'))
df <- subset(df, chl>0 & level<120)
df$level <- as.factor(df$level)
df$date <- as.Date(df$date)
df$clevs <- cut(df$chl, clevs)

p <- ggplot(df, aes(x=date, y=level, fill=clevs)) + geom_tile()
p <- p + scale_y_discrete(limits = rev(levels(df$level)))
p <- p + scale_fill_brewer(name='chl (mg/m3)', palette='PRGn')
p <- p + ggtitle('Assimilated chlorophyll for the Southern Red Sea')
p <- p + ylab('level (m)')
p <- p + theme(text=element_text(size=16))
ggsave('results/proposal/figures/chl3.png', p)


