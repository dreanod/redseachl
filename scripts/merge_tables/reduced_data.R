df <- read.csv('data/merged/data_and_eof.csv')

new_df <- df[1082:1545,]

write.csv(new_df, 'data/merged/data_reduced.csv', row.names=FALSE)