
for (year in 2002:2013) {
  list_cmd <- paste('wget -q -O - http://oceandata.sci.gsfc.nasa.gov/MODISA/Mapped/8Day/9km/par', year, sep='/')
  grep_cmd <- 'grep par'
  get_cmd <- 'wget -N --wait=0.5 --random-wait --force-html -i - -P ../../data/raw/PAR'
  cmd <- paste(list_cmd, grep_cmd, get_cmd, sep='|')
  system(cmd)
}
