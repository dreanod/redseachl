
url <- 'ftp://ftp.cpc.ncep.noaa.gov/cwlinks/norm.daily.aao.index.b790101.current.ascii'
system(paste('wget', url, '-P', dataDir))
