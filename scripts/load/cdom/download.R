 
URLs <- readLines('scripts/load/cdom/files_list.txt')

for (url in URLs) {
	flags <- '-N --wait=0.5 --force-html -P data/cdom/raw'
	cmd <- paste('wget', url, flags)
	system(cmd)
}

