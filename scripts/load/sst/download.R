
URLs <- readLines('scripts/load/sst/files_list.txt')

for (url in URLs) {
	flags <- '-N --wait=0.5 --random-wait --force-html -i - -P data/sst/raw'
	cmd <- paste('wget', url, flags)
	system(cmd)
}

