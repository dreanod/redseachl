LOAD = ./scripts/load

all: $(LOAD)/chl/aggregate.Rout

$(LOAD)/chl/aggregate.Rout: $(LOAD)/chl/download.Rout
	R CMD BATCH $(LOAD)/chl/aggregate.R

$(LOAD)/download_chl.Rout: $(LOAD)/chl/download.R
	R CMD BATCH $(LOAD)/chl/download.R

clean:
	rm -fv $(LOAD)/*/*.Rout
