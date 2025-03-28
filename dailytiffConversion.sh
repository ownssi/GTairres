#!/bin/bash


# Find all .nc files under the current working directory(where script is executed)
todaycycle_folder=$(ls -d HiResX/202* | sort -r | head -n 1)
find "./${todaycycle_folder}" -type f -name "*.nc" | while read -r nc_file; do

    filename=${nc_file##*/}
    cycle=$(basename "$(dirname "$(dirname "$nc_file")")")
    cycle_parsed=${cycle%00}
    tmr=$(date --date=$cycle_parsed'+1 day' +'%Y%m%d')
    tmrtmr=$(date --date=$tmr'+1 day' +'%Y%m%d')
    outputpath="./HiRes2/$cycle/geotiff"
    
    if [[ $filename == *web.daily.conus4* ]]; then
        mkdir -p $outputpath/daily
        for (( i=1; i<=2; i++ )); do
            if [[ $i -eq 1 ]]; then
                suffix=$tmr
            else
                suffix=$tmrtmr
            fi
            gdal_translate -a_ullr -2412000 1332000 2340000 -1620000 -of GTiff -b $i NETCDF:$nc_file:maxTEMP2 $outputpath/daily/conus4_raster.${cycle}Z.maxTEMP2.${suffix}.notReprojected.tif
            gdalwarp -s_srs "+proj=lcc +lat_1=33 +lat_2=45 +lat_0=40 +lon_0=-97 +a=6370000 +b=6370000" -t_srs 'EPSG:4326' $outputpath/daily/conus4_raster.${cycle}Z.maxTEMP2.${suffix}.notReprojected.tif $outputpath/daily/conus4_raster.${cycle}Z.maxTEMP2.${suffix}.tif
            rm -f $outputpath/daily/conus4_raster.${cycle}Z.maxTEMP2.${suffix}.notReprojected.tif
            
            gdal_translate -a_ullr -2412000 1332000 2340000 -1620000 -of GTiff -b $i NETCDF:$nc_file:minTEMP2 $outputpath/daily/conus4_raster.${cycle}Z.minTEMP2.${suffix}.notReprojected.tif
            gdalwarp -s_srs "+proj=lcc +lat_1=33 +lat_2=45 +lat_0=40 +lon_0=-97 +a=6370000 +b=6370000" -t_srs 'EPSG:4326' $outputpath/daily/conus4_raster.${cycle}Z.minTEMP2.${suffix}.notReprojected.tif $outputpath/daily/conus4_raster.${cycle}Z.minTEMP2.${suffix}.tif
            rm -f $outputpath/daily/conus4_raster.${cycle}Z.minTEMP2.${suffix}.notReprojected.tif
            
            gdal_translate -a_ullr -2412000 1332000 2340000 -1620000 -of GTiff -b $i NETCDF:$nc_file:avgSOLRAD $outputpath/daily/conus4_raster.${cycle}Z.avgSOLRAD.${suffix}.notReprojected.tif
            gdalwarp -s_srs "+proj=lcc +lat_1=33 +lat_2=45 +lat_0=40 +lon_0=-97 +a=6370000 +b=6370000" -t_srs 'EPSG:4326' $outputpath/daily/conus4_raster.${cycle}Z.avgSOLRAD.${suffix}.notReprojected.tif $outputpath/daily/conus4_raster.${cycle}Z.avgSOLRAD.${suffix}.tif
            rm -f $outputpath/daily/conus4_raster.${cycle}Z.avgSOLRAD.${suffix}.notReprojected.tif
            
            gdal_translate -a_ullr -2412000 1332000 2340000 -1620000 -of GTiff -b $i NETCDF:$nc_file:accPRECIP $outputpath/daily/conus4_raster.${cycle}Z.accPRECIP.${suffix}.notReprojected.tif
            gdalwarp -s_srs "+proj=lcc +lat_1=33 +lat_2=45 +lat_0=40 +lon_0=-97 +a=6370000 +b=6370000" -t_srs 'EPSG:4326' $outputpath/daily/conus4_raster.${cycle}Z.accPRECIP.${suffix}.notReprojected.tif $outputpath/daily/conus4_raster.${cycle}Z.accPRECIP.${suffix}.tif
            rm -f $outputpath/daily/conus4_raster.${cycle}Z.accPRECIP.${suffix}.notReprojected.tif
            
            gdal_translate -a_ullr -2412000 1332000 2340000 -1620000 -of GTiff -b $i NETCDF:$nc_file:maxPBL $outputpath/daily/conus4_raster.${cycle}Z.maxPBL.${suffix}.notReprojected.tif
            gdalwarp -s_srs "+proj=lcc +lat_1=33 +lat_2=45 +lat_0=40 +lon_0=-97 +a=6370000 +b=6370000" -t_srs 'EPSG:4326' $outputpath/daily/conus4_raster.${cycle}Z.maxPBL.${suffix}.notReprojected.tif $outputpath/daily/conus4_raster.${cycle}Z.maxPBL.${suffix}.tif
            rm -f $outputpath/daily/conus4_raster.${cycle}Z.maxPBL.${suffix}.notReprojected.tif
        done
    elif [[ $filename == *web.hourly.conus4* ]]; then
        mkdir -p $outputpath/hourly
        for (( i=1; i<=48; i++ ));
        do
            gdal_translate -a_ullr -2412000 1332000 2340000 -1620000 -of  GTiff -b $i NETCDF:$nc_file:SFC_TMP $outputpath/hourly/conus4_raster.${cycle}Z.SFC_TEMP.$((i-1)).notReprojected.tif
            gdalwarp -s_srs "+proj=lcc +lat_1=33 +lat_2=45 +lat_0=40 +lon_0=-97 +a=6370000 +b=6370000" -t_srs 'EPSG:4326' $outputpath/hourly/conus4_raster.${cycle}Z.SFC_TEMP.$((i-1)).notReprojected.tif $outputpath/hourly/conus4_raster.${cycle}Z.SFC_TEMP.$((i-1)).tif
            rm -f $outputpath/hourly/conus4_raster.${cycle}Z.SFC_TEMP.$((i-1)).notReprojected.tif
            
            gdal_translate -a_ullr -2412000 1332000 2340000 -1620000 -of  GTiff -b $i NETCDF:$nc_file:WDIR10 $outputpath/hourly/conus4_raster.${cycle}Z.WDIR10.$((i-1)).notReprojected.tif
            gdalwarp -s_srs "+proj=lcc +lat_1=33 +lat_2=45 +lat_0=40 +lon_0=-97 +a=6370000 +b=6370000" -t_srs 'EPSG:4326' $outputpath/hourly/conus4_raster.${cycle}Z.WDIR10.$((i-1)).notReprojected.tif $outputpath/hourly/conus4_raster.${cycle}Z.WDIR10.$((i-1)).tif
            rm -f $outputpath/hourly/conus4_raster.${cycle}Z.WDIR10.$((i-1)).notReprojected.tif
            
            gdal_translate -a_ullr -2412000 1332000 2340000 -1620000 -of  GTiff -b $i NETCDF:$nc_file:WSPD10 $outputpath/hourly/conus4_raster.${cycle}Z.WSPD10.$((i-1)).notReprojected.tif
            gdalwarp -s_srs "+proj=lcc +lat_1=33 +lat_2=45 +lat_0=40 +lon_0=-97 +a=6370000 +b=6370000" -t_srs 'EPSG:4326' $outputpath/hourly/conus4_raster.${cycle}Z.WSPD10.$((i-1)).notReprojected.tif $outputpath/hourly/conus4_raster.${cycle}Z.WSPD10.$((i-1)).tif
            rm -f $outputpath/hourly/conus4_raster.${cycle}Z.WSPD10.$((i-1)).notReprojected.tif
            
            gdal_translate -a_ullr -2412000 1332000 2340000 -1620000 -of  GTiff -b $i NETCDF:$nc_file:PM25_TOT $outputpath/hourly/conus4_raster.${cycle}Z.PM25_TOT.$((i-1)).notReprojected.tif
            gdalwarp -s_srs "+proj=lcc +lat_1=33 +lat_2=45 +lat_0=40 +lon_0=-97 +a=6370000 +b=6370000" -t_srs 'EPSG:4326' $outputpath/hourly/conus4_raster.${cycle}Z.PM25_TOT.$((i-1)).notReprojected.tif $outputpath/hourly/conus4_raster.${cycle}Z.PM25_TOT.$((i-1)).tif
            rm -f $outputpath/hourly/conus4_raster.${cycle}Z.PM25_TOT.$((i-1)).notReprojected.tif
            
            gdal_translate -a_ullr -2412000 1332000 2340000 -1620000 -of  GTiff -b $i NETCDF:$nc_file:O3 $outputpath/hourly/conus4_raster.${cycle}Z.O3.$((i-1)).notReprojected.tif
            gdalwarp -s_srs "+proj=lcc +lat_1=33 +lat_2=45 +lat_0=40 +lon_0=-97 +a=6370000 +b=6370000" -t_srs 'EPSG:4326' $outputpath/hourly/conus4_raster.${cycle}Z.O3.$((i-1)).notReprojected.tif $outputpath/hourly/conus4_raster.${cycle}Z.O3.$((i-1)).tif
            rm -f $outputpath/hourly/conus4_raster.${cycle}Z.O3.$((i-1)).notReprojected.tif
            
            gdal_translate -a_ullr -2412000 1332000 2340000 -1620000 -of  GTiff -b $i NETCDF:$nc_file:RH $outputpath/hourly/conus4_raster.${cycle}Z.RH.$((i-1)).notReprojected.tif
            gdalwarp -s_srs "+proj=lcc +lat_1=33 +lat_2=45 +lat_0=40 +lon_0=-97 +a=6370000 +b=6370000" -t_srs 'EPSG:4326' $outputpath/hourly/conus4_raster.${cycle}Z.RH.$((i-1)).notReprojected.tif $outputpath/hourly/conus4_raster.${cycle}Z.RH.$((i-1)).tif
            rm -f $outputpath/hourly/conus4_raster.${cycle}Z.RH.$((i-1)).notReprojected.tif
        done
    elif [[ $filename == *web.hourly.hiresx4* ]]; then
        mkdir -p $outputpath/hourly
        for (( i=1; i<=48; i++ ));
        do
            gdal_translate -a_ullr 888000 -360000 1608000 -1080000 -of  GTiff -b $i NETCDF:$nc_file:PM25_TOT_B $outputpath/hourly/hiresx4_raster.${cycle}Z.PM25_TOT_B.$((i-1)).notReprojected.tif
            gdalwarp -s_srs "+proj=lcc +lat_1=33 +lat_2=45 +lat_0=40 +lon_0=-97 +a=6370000 +b=6370000" -t_srs 'EPSG:4326' $outputpath/hourly/hiresx4_raster.${cycle}Z.PM25_TOT_B.$((i-1)).notReprojected.tif $outputpath/hourly/hiresx4_raster.${cycle}Z.PM25_TOT_B.$((i-1)).tif
            rm -f $outputpath/hourly/hiresx4_raster.${cycle}Z.PM25_TOT_B.$((i-1)).notReprojected.tif
            
            gdal_translate -a_ullr 888000 -360000 1608000 -1080000 -of  GTiff -b $i NETCDF:$nc_file:O3_B $outputpath/hourly/hiresx4_raster.${cycle}Z.O3_B.$((i-1)).notReprojected.tif
            gdalwarp -s_srs "+proj=lcc +lat_1=33 +lat_2=45 +lat_0=40 +lon_0=-97 +a=6370000 +b=6370000" -t_srs 'EPSG:4326' $outputpath/hourly/hiresx4_raster.${cycle}Z.O3_B.$((i-1)).notReprojected.tif $outputpath/hourly/hiresx4_raster.${cycle}Z.O3_B.$((i-1)).tif
            rm -f $outputpath/hourly/hiresx4_raster.${cycle}Z.O3_B.$((i-1)).notReprojected.tif
        done
    fi

done
