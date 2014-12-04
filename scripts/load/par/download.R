
URLs <- readLines('scripts/load/par/files_list.txt')

for (url in URLs) {
	flags <- '-N --wait=0.5 --force-html -P data/par/raw'
	cmd <- paste('wget', url, flags)
	system(cmd)
}

