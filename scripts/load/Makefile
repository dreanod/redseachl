RDIR = .
OUT = $(RDIR)/generated

all: $(OUT)/download_urls.Rout

$(OUT)/download_urls.Rout: $(OUT)/url.list $(OUT)/download_urls.R
	R CMD BATCH $(OUT)/download_urls.R

$(OUT)/url.list: $(OUT)/build_urls.R
	R CMD BATCH $<

clean:
	rm -fv $(OUT)/*
