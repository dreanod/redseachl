RDIR = .
OUTDIR = $(RDIR)/generated

URL_BUILD = $(RDIR)/construct_URL.R
URL_BUILD_OUT = $(OUTDIR)/construct_URL.Rout

all: $(URL_BUILD_OUT)

$(URL_BUILD_OUT):$(URL_BUILD)
	R CMD BATCH $< $@

clean:
	rm -fv $(OUTDIR)/*
