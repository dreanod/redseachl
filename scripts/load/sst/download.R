
URLs <- readLines('scripts/load/chl/files_list.txt')

for (url in URLs) {
	flags <- '-N --wait=0.5 --random-wait --force-html -i - -P data/sst/raw'
	download.file(url, extra=flags)
}

