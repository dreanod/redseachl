OLD_LIST <- 'generated/url.list.downloaded'
NEW_LIST <- 'generated/url.list'

download_files <- function(urls) {
  for (url in urls) {
    print(paste('Downloading:', url))
    write(url, file=OLD_LIST, append=TRUE)
  }
}

remove_files <- function(urls) {
  for (url in urls) {
    print(paste('Removing:', url))
  }
}

con <- file(NEW_LIST, open='r')
url.list <- readLines(con)
close(con)

if (file.exists(OLD_LIST)) {
  con <- file(OLD_LIST, open = 'r')
  url.list.old <- readLines(con)
  close(con)
  
  url.removed.ind <- !(url.list.old %in% url.list)
  url.removed <- url.list.old[url.removed.ind]
  remove_files(url.removed)
  
  url.added.ind <- !(url.list %in% url.list.old)
  url.added <- url.list[url.added.ind]
  if (length(url.added) > 0) {
    download_files(url.added)
  } else {
    print('No new file to download.')
  }
  
  url.unchanged.ind <- url.list %in% url.list.old
  url.unchanged <- url.list[url.unchanged.ind]
  
} else {
  download_files(url.list)
}
