LOADDIR = scripts/load
EXPLDIR = scripts/explore
VPATH = $(LOADDIR) $(EXPLDIR)

all: load_all

.PHONY: load_all
load_all: load_chl load_sst load_poc load_cdom load_par

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

poc/2_crop.log: poc/2_crop.sh poc/1_download.log
	bash $< 2>&1 | tee $(LOADDIR)/$@

poc/1_download.log: poc/1_download.sh
	bash $< 2>&1 | tee $(LOADDIR)/$@

.PHONY: load_cdom
load_cdom: cdom/3_clean.Rout

cdom/3_clean.Rout: cdom/3_clean.R cdom/2_crop.log
	R CMD BATCH $< $(LOADDIR)/$@

cdom/2_crop.log: cdom/2_crop.sh cdom/1_download.log
	bash $< 2>&1 | tee $(LOADDIR)/$@

cdom/1_download.log: cdom/1_download.sh
	bash $< 2>&1 | tee $(LOADDIR)/$@

.PHONY: load_par
load_par: par/3_clean.Rout

par/3_clean.Rout: par/3_clean.R par/2_crop.log
	R CMD BATCH $< $(LOADDIR)/$@

par/2_crop.log: par/2_crop.sh par/1_download.log
	bash $< 2>&1 | tee $(LOADDIR)/$@

par/1_download.log: par/1_download.sh
	bash $< 2>&1 | tee $(LOADDIR)/$@

.PHONY: explore_all
explore_all: explore_chl

.PHONY: explore_chl
explore_chl: chl/maps.Rout chl/climatology_maps.Rout chl/explore.Rout\
             chl/region_ts.Rout chl/coverage.Rout chl/ts_coverage.Rout

chl/maps.Rout: chl/maps.R load_chl
	R CMD BATCH $< $(LOADDIR)/$@

chl/climatology_maps.Rout: chl/climatology_maps.R load_chl
	R CMD BATCH $< $(LOADDIR)/$@

chl/explore.Rout: chl/explore.R load_chl
	R CMD BATCH $< $(LOADDIR)/$@

chl/region_ts.Rout: chl/region_ts.R load_chl
	R CMD BATCH $< $(LOADDIR)/$@

chl/coverage.Rout: chl/coverage.R load_chl
	R CMD BATCH $< $(LOADDIR)/$@

chl/ts_coverage.Rout: chl/ts_coverage.R load_chl
	R CMD BATCH $< $(LOADDIR)/$@
