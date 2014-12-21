#!/usr/bin/env bash

for i in $(seq 1997 2013)
do
	wget -r -N -nH --cut-dirs=7 --random-wait --wait 1 \
	-P data/rain/raw --accept *.bin \
	ftp://disc3.nascom.nasa.gov/data/s4pa/TRMM_L3/TRMM_3B42_daily/$i
done