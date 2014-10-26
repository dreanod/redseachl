library(knitr)

setwd("~/Dropbox/repos/redseachl/results/")

knit(input="~/Dropbox/repos/redseachl/scripts/load.Rnw", 
     output="load.tex")

texi2pdf("load.tex")

