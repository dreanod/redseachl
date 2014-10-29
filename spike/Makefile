RDIR = .

all: download_urls.Rout

download_urls.Rout: url.list download_urls.R
	R CMD BATCH download_urls.R

url.list: build_url.R
	R CMD BATCH $<



clean:
	rm -fv $(OUTDIR)/*