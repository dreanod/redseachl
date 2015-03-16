#!/usr/bin/env bash
mkdir data/imi/raw
for i in $(seq 1997 2013)
do
	wget -nH -r -N --random-wait --wait 1 -P data/imi/raw --cut-dirs=5 \
	http://apdrc.soest.hawaii.edu/projects/monsoon/ismidx/data/ismidx.${i}.day.txt
done
