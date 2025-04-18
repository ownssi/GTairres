#!/bin/sh

find "." -type f -name "*.nc" | grep "web.transwind.hourly.conus4" | while read -r nc_file; do

    # Run gdal_translate command
    filename=${nc_file##*/}
    cycle=$(basename "$(dirname "$(dirname "$nc_file")")")
    outputpath="./HiRes2/$cycle/geotiff"
    
    mkdir -p $outputpath/hourly
    for (( i=1; i<=48; i++ )); do
    
        gdal_translate -a_ullr -2412000 1332000 2340000 -1620000 -of  GTiff -b $i NETCDF:$nc_file:TRANSWDIR $outputpath/hourly/conus4_raster.${cycle}Z.TRANSWDIR.$((i-1)).notReprojected.tif
        gdalwarp -s_srs "+proj=lcc +lat_1=33 +lat_2=45 +lat_0=40 +lon_0=-97 +a=6370000 +b=6370000" -t_srs 'EPSG:4326' $outputpath/hourly/conus4_raster.${cycle}Z.TRANSWDIR.$((i-1)).notReprojected.tif $outputpath/hourly/conus4_raster.${cycle}Z.TRANSWDIR.$((i-1)).tif
        rm -f $outputpath/hourly/conus4_raster.${cycle}Z.TRANSWDIR.$((i-1)).notReprojected.tif

        gdal_translate -a_ullr -2412000 1332000 2340000 -1620000 -of  GTiff -b $i NETCDF:$nc_file:TRANSWSPD $outputpath/hourly/conus4_raster.${cycle}Z.TRANSWSPD.$((i-1)).notReprojected.tif
        gdalwarp -s_srs "+proj=lcc +lat_1=33 +lat_2=45 +lat_0=40 +lon_0=-97 +a=6370000 +b=6370000" -t_srs 'EPSG:4326' $outputpath/hourly/conus4_raster.${cycle}Z.TRANSWSPD.$((i-1)).notReprojected.tif $outputpath/hourly/conus4_raster.${cycle}Z.TRANSWSPD.$((i-1)).tif
        rm -f $outputpath/hourly/conus4_raster.${cycle}Z.TRANSWSPD.$((i-1)).notReprojected.tif
    done
    

done
