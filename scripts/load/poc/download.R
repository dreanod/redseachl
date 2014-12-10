 
URLs <- readLines('scripts/load/poc/files_list.txt')

for (url in URLs) {
	flags <- '-N --wait=0.5 --force-html -P data/poc/raw'
	cmd <- paste('wget', url, flags)
	system(cmd)
}

