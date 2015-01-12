#!/usr/bin/env bash

mkdir data/sst/temp
mkdir data/sst/aggregate

for f in data/sst/raw/*.bz2; do
  filename=$(basename "$f")
  filename=data/sst/temp/"${filename%.*}"
  bzcat $f > $filename
  
  gdal_translate -a_srs EPSG:4326 -a_ullr -180 90 180 -90 \
  HDF4_SDS:UNKNOWN:\"$filename\":0 $filename

  gdal_translate -projwin 25 35 55 5 $filename $filename
done