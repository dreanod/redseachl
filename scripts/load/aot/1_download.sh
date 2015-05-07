#!/usr/bin/env bash

mkdir data/aot/raw
wget -i scripts/load/aot/files_list.txt -N --wait=0.5 -P data/aot/raw 
