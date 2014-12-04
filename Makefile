LOAD = ./scripts/load

all: $(LOAD)/chl/aggregate.Rout $(LOAD)/sst/download.Rout

$(LOAD)/chl/aggregate.Rout: $(LOAD)/chl/download.Rout
	R CMD BATCH $(LOAD)/chl/aggregate.R $(LOAD)/chl/aggregate.Rout

$(LOAD)/chl/download.Rout: $(LOAD)/chl/download.R
	R CMD BATCH $(LOAD)/chl/download.R $(LOAD)/chl/download.Rout

$(LOAD)/sst/download.Rout: $(LOAD)/sst/download.R
	R CMD BATCH $(LOAD)/sst/download.R $(LOAD)/sst/download.Rout

clean:
	rm -fv $(LOAD)/*/*.Rout
