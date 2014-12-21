LOADDIR = scripts/load
VPATH = $(LOADDIR)

all: bathy/download.log chl/download.Rout cdom/download.log  nao/download.log \
     par/download.log poc/download.log soi/download.log ssh/download.Rout \
     sst/download.log

%.log: %.sh
	bash $< 2>&1 | tee $(LOADDIR)/$@
	
%.Rout: %.R
	R CMD BATCH $< $@