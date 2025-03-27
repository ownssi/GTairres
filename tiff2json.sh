#!/bin/bash

# Find all .nc files under the base directory
find "./HiRes2" -type f -name "*.tif" | grep "/202503" | while read -r tif_file; do

    filename=${tif_file##*/}
    outputpath=$(dirname "$(dirname "$(dirname "$tif_file")")")
    hourly_daily=$(basename $(dirname "$tif_file"))
    
    cycle=$(basename $outputpath)
    cycle_parsed=${cycle%00}
    
    outputpath_daily=$outputpath/polygon/daily
    mkdir -p $outputpath_daily
    outputpath_hourly=$outputpath/polygon/hourly
    mkdir -p $outputpath_hourly
    
    variable_name=$(echo "$tif_file" | sed -E 's/.*[0-9]{10}Z\.([A-Za-z0-9_]+)\.[0-9]+\.[tif]+$/\1/')
    conus_hires=$(echo "$filename" | sed -E 's/^([a-zA-Z0-9]+)_raster.*$/\1/')
    tstep=$(echo "$filename" | sed -E 's/^.*\.([0-9]+)\.tif$/\1/')
    
    if [[ $variable_name == "WDIR10" || $variable_name == "WSPD10" || $variable_name == "WSPD10" || $variable_name == "PM25_TOT" || $variable_name == "O3" || $variable_name == "RH" ]]; then
        continue
    fi
    
    
    if [[ $hourly_daily == "hourly" ]]; then
        gdal_polygonize $tif_file $outputpath_hourly/${conus_hires}_polygon.${cycle_parsed}Z.${variable_name}.${tstep}.geojson
    elif [[ $hourly_daily == "daily" ]]; then
        gdal_polygonize $tif_file $outputpath_daily/${conus_hires}_polygon.${cycle_parsed}Z.${variable_name}.${tstep}.geojson
    
    fi
done
