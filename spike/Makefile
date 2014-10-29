RDIR = .

all: url.list

url.list:build_url.R
	R CMD BATCH $<



clean:
	rm -fv $(OUTDIR)/*