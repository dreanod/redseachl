download_files <- function(urls) {
  for (url in urls) {
    print(paste('Downloading:', url))
  }
}

remove_files <- function(urls) {
  for (url in urls) {
    print(paste('Removing:', url))
  }
}

write_files <- function(urls) {
  fileConn <- file('url.list.old')
  writeLines(urls, fileConn)
  close(fileConn)
}

con <- file('url.list', open='r')
url.list <- readLines(con)
close(con)

if (file.exists('url.list.old')) {
  con <- file('url.list.old', open = 'r')
  url.list.old <- readLines(con)
  close(con)
  
  url.removed.ind <- !(url.list.old %in% url.list)
  url.removed <- url.list.old[url.removed.ind]
  remove_files(url.removed)
  
  url.added.ind <- !(url.list %in% url.list.old)
  url.added <- url.list[url.added.ind]
  download_files(url.added)
  
  url.unchanged.ind url.list %in% url.list.old
  url.unchanged <- url.list[url.unchanged.ind]
  write_new_list(url.unchanged, url.added)
  
} else {
  download_files(url.list)
  write_new_list(url.list, NULL)
}
