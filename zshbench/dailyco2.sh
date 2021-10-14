dailyco2 ()
{
    : retrieve latest average CO2 reading from NOAA
    : uses: awk, tail, curl
    : run:  source dailyc02.sh   
    : note: a change to echo messages onto STDERR.
    : to see the "canonical format", declare -f dailyco2
    : date: 2020-07-20 -- do not leave data files in cwd
    : date: 2021-02-10 -- display data source is NOAA
    set -- ftp://aftp.cmdl.noaa.gov/products/trends/co2/co2_trend_gl.txt
    set -- $1 $(basename $1)
    curl -q $1 > $2 || { echo curl error                    1>&2; return 1; }
    :
    tail -n 1 $2 | awk '

    BEGIN { fmt = "Latest (%s-%02d-%02d) average global co2 value (NOAA): %s ppm\n" }
          { printf( fmt, $1, $2, $3, $4 ) }
    '
    rm $(basename $1)
    return
}
dailyco2 2> /tmp/.daily.er
