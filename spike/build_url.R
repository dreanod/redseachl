fileConn <- file('url.list')
writeLines(c('url1', 'url2', 'url3') , fileConn)
close(fileConn)
