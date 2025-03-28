#!/bin/bash


# Find all .nc files under the current working directory(where script is executed)
todaycycle_folder=$(ls -d 202* | sort -r | head -n 1)
find "./HiResX/${todaycycle_folder}" -type f -name "*.nc" | while read -r nc_file; do

    filename=${nc_file##*/}
    cycle=$(basename "$(dirname "$(dirname "$nc_file")")")
    cycle_parsed=${cycle%00}   # Strip the trailing zeros (e.g., from 2025032000 to 20250320)
    tmr=$(date --date=$cycle_parsed'+1 day' +'%Y%m%d')
    tmrtmr=$(date --date=$tmr'+1 day' +'%Y%m%d')
    outputpath="./HiRes2/$cycle/geotiff"
    
    if [[ $filename == *web.daily.conus4* ]]; then
        echo "this is daily filename: ${filename}"
    elif [[ $filename == *web.hourly.conus4* ]]; then
        echo "this is hourly filename: ${filename}"
    elif [[ $filename == *web.hourly.hiresx4* ]]; then
        echo "this is hourly hires filename: ${filename}"
    fi

done
