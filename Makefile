LOAD = ./scripts/load

all: $(LOAD)/chl/aggregate.Rout

$(LOAD)/chl/aggregate.Rout: $(LOAD)/chl/download.Rout
	R CMD BATCH $(LOAD)/chl/aggregate.R $(LOAD)/chl/aggregate.Rout

$(LOAD)/download_chl.Rout: $(LOAD)/chl/download.R
	R CMD BATCH $(LOAD)/chl/download.R $(LOAD)/chl/download.Rout

clean:
	rm -fv $(LOAD)/*/*.Rout
