
path <- 'ftp://disc3.nascom.nasa.gov/data/s4pa/TRMM_L3/TRMM_3B42_daily'

for (year in 1997:2013) {
	url <- file.path(path, year)
	flags <- '-r -np -nH --cut-dirs=7 --random-wait --wait 1 -P data/rain/raw'
	cmd <- paste('wget', flags, url)
	system(cmd)
}
