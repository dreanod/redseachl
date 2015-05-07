df <- read.csv('data/merged/data.csv')
eof <- read.csv('derived/eof/chl_clusters_eof/eofs.csv')

df$X <- as.Date(df$X)
eof$X <- as.Date(eof$X)

new_df <- merge(df, eof, all=TRUE, sort=TRUE)
write.csv(new_df, 'data/merged/data_and_eof.csv', row.names=FALSE)