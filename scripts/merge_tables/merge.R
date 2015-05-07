imi <- read.csv('data/imi/projected/imi.csv')
nao <- read.csv('data/nao/projected/nao.csv')
soi <- read.csv('data/soi/projected/soi.csv')

chl <- read.csv('data/chl_oc_cci/projected/chl_oc_cci.csv')
aot <- read.csv('data/aot/projected/aot.csv')
par <- read.csv('data/par/projected/par.csv')
rain <- read.csv('data/rain/projected/rain.csv')
ssh <- read.csv('data/ssh/projected/ssh.csv')
sst <- read.csv('data/sst/projected/sst.csv')
wind <- read.csv('data/wind/projected/wind.csv')

df <- merge(imi, nao, all=TRUE, sort=TRUE)
df <- merge(df, soi, all=TRUE, sort=TRUE)
df <- merge(df, aot, all=TRUE, sort=TRUE)

df <- merge(df, chl, all=TRUE, sort=TRUE)
df <- merge(df, par, all=TRUE, sort=TRUE)
df <- merge(df, par, all=TRUE, sort=TRUE)
df <- merge(df, rain, all=TRUE, sort=TRUE)
df <- merge(df, ssh, all=TRUE, sort=TRUE)
df <- merge(df, sst, all=TRUE, sort=TRUE)
df <- merge(df, wind, all=TRUE, sort=TRUE)

df$X <- as.Date(df$X)
df <- df[order(df$X),]

dir.create('data/merged')
write.csv(df, 'data/merged/data.csv', row.names=FALSE)