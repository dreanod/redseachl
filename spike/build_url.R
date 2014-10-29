fileConn <- file('url.list')
writeLines(c('url1', 'url2') , fileConn)
close(fileConn)
