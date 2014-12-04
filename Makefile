LOAD = ./scripts/load
DIR = $(wildcard $(LOAD)/*)

all: $(DIR)/download.Rout
	echo all_rule
	echo $(DIR)/download.Rout

$(DIR)/download.Rout: dummy.R
	

dummy.R:
	echo dummy

$(LOAD)/chl/aggregate.Rout: $(LOAD)/chl/download.Rout
	R CMD BATCH $(LOAD)/chl/aggregate.R $(LOAD)/chl/aggregate.Rout

%.Rout: %.R
	R CMD BATCH $< $@

clean:
	rm -fv $(LOAD)/*/*.Rout
