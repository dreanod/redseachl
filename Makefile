LOADDIR = scripts/load
VPATH = $(LOADDIR)

all: bathy/download.log chl/download.Rout cdom/download.log  nao/download.log \
     par/download.log poc/download.log soi/download.log ssh/download.Rout \
     sst/download.log rain/download.log aerosol/download.log

%.log: %.sh
	bash $< 2>&1 | tee $(LOADDIR)/$@
	
%.Rout: %.R
	R CMD BATCH $< $@

.PHONY: load_chl

load_chl: chl/3_clean.Rout

chl/3_clean.Rout: chl/3_clean.R chl/2_crop.log
	R CMD BATCH $< $(LOADDIR)/$@

chl/2_crop.log: chl/2_crop.sh chl/1_download.log
	bash $< 2>&1 | tee $(LOADDIR)/$@

chl/1_download.log: chl/1_download.sh
	bash $< 2>&1 | tee $(LOADDIR)/$@

.PHONY: load_sst

load_sst: sst/3_clean.Rout

sst/3_clean.Rout: sst/3_clean.R sst/2_crop.log
	R CMD BATCH $< $(LOADDIR)/$@

sst/2_crop.log: sst/2_crop.sh sst/1_download.log
	bash $< 2>&1 | tee $(LOADDIR)/$@

sst/1_download.log: sst/1_download.sh
	bash $< 2>&1 | tee $(LOADDIR)/$@

.PHONY: load_poc

load_poc: poc/3_clean.Rout

poc/3_clean.Rout: poc/3_clean.R poc/2_crop.log
	R CMD BATCH $< $(LOADDIR)/$@

sst/2_crop.log: sst/2_crop.sh sst/1_download.log
	bash $< 2>&1 | tee $(LOADDIR)/$@

sst/1_download.log: sst/1_download.sh
	bash $< 2>&1 | tee $(LOADDIR)/$@

