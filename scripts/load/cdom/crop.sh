#!/usr/bin/env bash

mkdir data/cdom/temp
mkdir data/cdom/crop

for f in data/cdom/raw/*.bz2; do
  filename=$(basename "$f")
  f_temp=data/cdom/temp/"${filename%.*}"
  f_fin=data/cdom/crop/"${filename%.*}".tiff
  bzcat $f > $f_temp
  
  gdal_translate -a_srs EPSG:4326 -a_ullr -180 90 180 -90 \
  HDF4_SDS:UNKNOWN:\"$f_temp\":0 $f_temp
  
  gdal_translate -projwin 25 35 65 5 $f_temp $f_fin

  rm $f_temp
done

rm -r data/cdom/temp