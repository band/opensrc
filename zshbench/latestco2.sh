latestco2 ()
{
    : retrieve latest CO2 reading from Scripps Mauna Loa Observatory
    : uses: convert, curl, echo, head, sed, tesseract
    : run:  source latestco2.sh
    : note: this script OCRs an image file - date of reading not available
    : to see the "canonical format", declare -f latestco2
    : date: 2020-12-19 -- scripps url updated
    : date: 2021-02-10 -- display data source as Scripps
    set -- https://scripps.ucsd.edu/bluemoon/co2_400/daily_value.png
    curl -q $1 > latestValue.png || { echo curl error >&2; return 1; }
    convert -sharpen 0x1 latestValue.png lValue.jpg
    tesseract lValue.jpg latestValue --psm 13 -l eng
    echo "Latest co2 concentration at Scripps Mauna Loa Observatory: $(head -n1 latestValue.txt | sed -e 's/^.*reading: // ; s/,/./')"
    rm latestValue.png lValue.jpg latestValue.txt
    return
}
latestco2 2> /tmp/.latest.er
