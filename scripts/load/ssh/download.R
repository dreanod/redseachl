# Fetch daily Sea Level Anomaly (SLA) from AVISO ftp service.
# Download from 1993 to 2013.

path <- "ftp://ftp.aviso.altimetry.fr/global/delayed-time/grids/msla/all-sat-merged/h"
prefix <- 'dt_global_allsat_msla_h_'
suffix <-  '_20140106.nc.gz'

build_urls <- function() {
	days <- seq(as.Date("1993/1/1"), as.Date("2013/12/31"), "days")
	days <- format(days, "%Y%m%d")

	URLs <- NULL

	for (day in days) {
		filename <- paste(prefix, day, suffix, sep='')
		year <- substring(day, 1, 4)
		url <- paste(path, year, filename, sep='/')
		URLs <- c(URLs, url)
	}
	return(URLs)
}

URLs <- build_urls()
# URLs <- readLines('scripts/load/par/files_list.txt')

# for (url in URLs) {
# 	flags <- '-N --wait=0.5 --force-html -P data/par/raw'
# 	cmd <- paste('wget', url, flags)
# 	system(cmd)
# }

