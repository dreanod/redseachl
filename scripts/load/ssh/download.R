# Fetch daily Sea Level Anomaly (SLA) from AVISO ftp service.
# Download from 1993 to 2013.
library(yaml)

conf <- yaml.load_file('scripts/load/ssh/config.yml')

host <- 'ftp.aviso.altimetry.fr'
path <- "/global/delayed-time/grids/msla/all-sat-merged/h"
password <- conf$password
login <- conf$login
url <- paste('ftp://', login, ':', password, '@', host, path, sep='')


for (year in 1993:2013) {
	flags <- '-r -np -nH --cut-dirs=7 --random-wait --wait 1 -P data/ssh/raw'
	cmd <- paste('wget', ' ', flags, ' ', url, '/', year, sep='')
	system(cmd)
}
