#!/usr/bin/env bash

mkdir data/sst/temp
mkdir data/sst/aggregate

for f in data/sst/raw/*.bz2; do
  filename=$(basename "$f")
  f_temp=data/sst/temp/"${filename%.*}"
  f_fin=data/sst/aggregate/"${filename%.*}"
  bzcat $f > $f_temp
  
  gdal_translate -a_srs EPSG:4326 -a_ullr -180 90 180 -90 \
  HDF4_SDS:UNKNOWN:\"$f_temp\":0 $f_temp

  gdal_translate -projwin 25 35 55 5 $f_temp $f_fin

  rm $_temp
done

rm -r data/sst/temp