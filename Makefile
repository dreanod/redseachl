LOAD = ./scripts/load

all: $(LOAD)/chl/download.Rout

$(LOAD)/download_chl.Rout: $(LOAD)/chl/download.R
	R CMD BATCH $< $@

clean:
	rm -fv $(LOAD)/*/*.Rout
