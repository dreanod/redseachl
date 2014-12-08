# Fetch daily Sea Level Anomaly (SLA) from AVISO ftp service.
# Download from 1993 to 2013.
library(yaml)

conf <- yaml.load_file('scripts/load/ssh/config.yml')
password <- conf$password
login <- conf$login

lonmin <- 25
lonmax <- 55
latmin <- 5
latmax <- 35
dirOut <- 'data/ssh/raw'

script <- 'python ~/tools/motu-client-python/motu-client.py'
f_user <- paste('-u', login)
f_pass <- paste('-p', password)
f_url <- '-m http://motu.aviso.oceanobs.com/aviso-gateway-servlet/Motu'
f_service <- '-s AvisoDT'
f_dataset <- '-d dataset-duacs-dt-global-allsat-msla-h'
f_lonmin <- paste('-x', lonmin)
f_lonmax <- paste('-X', lonmax)
f_latmin <- paste('-y', latmin)
f_latmax <- paste('-Y', latmax)
cmd1 <- paste(script, f_user, f_pass, f_url, f_service, f_dataset, 
	          f_lonmin, f_lonmax, f_latmin, f_latmax)

f_data <- '-v crs -v lon_bnds -v err -v lat_bnds -v sla -v nv'
f_dir <- paste('-o', dirOut)
cmd3 <- paste(f_data, f_dir)


for (year in 1993:2013) {
	f_dateBeg <- paste('-t "', year, '-01-01"', sep='')
	f_dateEnd <- paste('-T "', year, '-12-31"', sep='')
	f_filename <- paste('-f ', 'sla_', year, '.nc', sep='')
	cmd <- paste(cmd1, f_dateBeg, f_dateEnd, cmd3, f_filename)
	system(cmd)
}

