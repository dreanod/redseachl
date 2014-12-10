
dataDir <- 'data/soi'
dir.create(dataDir)
dataDir <- file.path(dataDir, 'raw')
dir.create(dataDir)

url <- 'https://www.longpaddock.qld.gov.au/seasonalclimateoutlook/southernoscillationindex/soidatafiles/DailySOI1933-1992Base.txt'
system(paste('wget', url, '-P', dataDir))