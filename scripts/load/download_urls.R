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

write_new_list <- function(urls) {
  fileConn <- file('generated/url.list.old')
  writeLines(urls, fileConn)
  close(fileConn)
}

con <- file('generated/url.list', open='r')
url.list <- readLines(con)
close(con)

if (file.exists('generated/url.list.old')) {
  con <- file('generated/url.list.old', open = 'r')
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
  write_new_list(c(url.unchanged, url.added))
  
} else {
  download_files(url.list)
  write_new_list(url.list)
}
