co2trends ()
{
    : retrieve latest, 1 year ago, and 10 year ago average CO2 reading from NOAA
    : uses: awk, basename, curl, grep, tail
    : run:  source co2trends.sh   
    : note: a change to echo messages onto STDERR.
    : to see the "canonical format", declare -f co2trends
    set -- ftp://aftp.cmdl.noaa.gov/products/trends/co2/co2_trend_gl.txt
    set -- $1 $(basename $1)
    curl -q $1 > $2 || { echo curl error                    1>&2; return 1; }
    :
    tail -n 1 $2 | awk '

    BEGIN { fmt = "Latest (%s-%02d-%02d) average global co2 value (NOAA): %s ppm\n" }
          { printf( fmt, $1, $2, $3, $4 ) }
    '
    :
    _p1=$(tail -n 1 $2 | awk '{ print ($1 - 1),"  ",$2,"  ",$3 }')
    grep "$_p1" $2 | awk '

    BEGIN { fmt = "One year ago (%s-%02d-%02d) average global co2 value (NOAA): %s ppm\n" }
          { printf( fmt, $1, $2, $3, $4 ) }
    '
    :
    _p10=$(tail -1 $2 | awk '{ print ($1 - 10),"  ",$2,"  ",$3 }')
    grep "$_p10" $2 | awk '

    BEGIN { fmt = "Ten years ago (%s-%02d-%02d) average global co2 value (NOAA): %s ppm\n" }
          { printf( fmt, $1, $2, $3, $4 ) }
    '
    rm $(basename $1)
    return
}
co2trends 2> /tmp/.daily.er
