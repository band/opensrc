latestco2 ()
{
    : retrieve latest CO2 readings from Scripps and NOAA Mauna Loa Observatory
    : uses: awk, basename, curl, echo, tail
    : run:  source latestco2.sh
    : note: this script OCRs an image file - date of reading not available
    : to see the "canonical format", which latestco2
    : date: 2020-12-19 -- scripps url updated
    : date: 2021-02-10 -- display data source as Scripps
    : date: 2024-12-31 -- ImageMagick and tesseract updates
    : date: 2025-01-24 -- get latest NOAA MLO value
    : date: 2025-04-22 -- use Scripps ASCII text data file
    : retrieve lastest daily CO2 reading from Scripps Mauna Loa Observatory
    set -- https://scripps.ucsd.edu/bluemoon/co2_400/co2_daily
    if ! output=$(curl --connect-timeout 5 -q $1 > co2_daily.txt); then
        echo "$output" >&2
        return $?
    fi
    cat co2_daily.txt | awk '
    BEGIN { fmt = "Latest (%s) Scripps Mauna Loa Observatory co2 value: %.2f ppm\n" }
          { printf( fmt, $2, $1 ) }
    '
    rm co2_daily.txt
    : retrieve lastest CO2 reading from NOAA Mauna Loa Observatory
    set -- https://gml.noaa.gov/webdata/ccgg/trends/co2/co2_daily_mlo.txt
    set -- $1 $(basename $1)
    curl -q $1 > $2 || { echo curl error 1>&2; return 1; }
    tail -n 1 $2 | awk '
    BEGIN { fmt = "Latest (%s-%02d-%02d) NOAA Mauna Loa Observatory co2 value: %s ppm\n" }
          { printf( fmt, $1, $2, $3, $5 ) }
    '
    rm $(basename $1)
    return
}
latestco2 2> /tmp/.latest.er
