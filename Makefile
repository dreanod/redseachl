LOAD = ./scripts/load

all: $(LOAD)/download_chl.Rout

$(LOAD)/download_chl.Rout: $(LOAD)/download_chl.R
	R CMD BATCH $< $@

clean:
	rm -fv $(LOAD)/*.Rout
