co2trends ()
{
    : retrieve latest, 1 year ago, and 10 year ago average CO2 trend values from NOAA
    : uses: awk, basename, curl, grep, tail, tr
    : run:  source co2trends.sh
    : to see the "canonical format", declare -f co2trends
    : date: 2025-02-11 -- set curl connection timeout
    set -- ftp://aftp.cmdl.noaa.gov/products/trends/co2/co2_trend_gl.txt
    local df=$(basename $1)
    curl --connect-timeout 5 -q $1 | tr -s ' ' > $df || { echo curl error 1>&2; return 1; }
    :
    set -- $(tail -n 1 $df) && yr=$1 && mo=$2 && dy=$3
    :
    grep "$yr $mo $dy " $df | awk '
    BEGIN { fmt = "Latest (%s-%02d-%02d) average global co2 trend value (NOAA): %s ppm\n" } 
          {  printf( fmt, $1, $2, $3, $5 )
          }
'
    grep "$(($yr-1)) $mo $dy " $df | awk '
    BEGIN { fmt = "One year ago (%s-%02d-%02d) average global co2 trend value (NOAA): %s ppm\n" } 
          {  printf( fmt, $1, $2, $3, $5 )
          }
'
    grep "$(($yr-10)) $mo $dy " $df | awk '
    BEGIN { fmt = "Ten years ago (%s-%02d-%02d) average global co2 trend value (NOAA): %s ppm\n" } 
          {  printf( fmt, $1, $2, $3, $5 )
          }
'
    rm $df
    return
}
co2trends 2> /tmp/.daily.er
