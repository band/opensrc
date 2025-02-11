latestco2 () {
	: retrieve latest CO2 reading from Scripps Mauna Loa Observatory
	: uses: curl, echo, head, magick, sed, tesseract
	: run: source latestco2.sh
	: note: this script OCRs an image file - date of reading not available
	: to see the "canonical format", which latestco2
	: date: 2020-12-19 -- scripps url updated
	: date: 2021-02-10 -- display data source as Scripps
	: date: 2024-12-31 -- ImageMagick and tesseract updates
	: date: 2025-01-24 -- get latest NOAA MLO value
	set -- https://scripps.ucsd.edu/bluemoon/co2_400/daily_value.png
	curl --connect-timeout 5 -q $1 > latestValue.png || {
		echo curl error >&2
		return 1
	}
	magick latestValue.png lValue.jpg
	tesseract lValue.jpg latestValue --oem 1 -l eng
	echo "Latest co2 concentration at Scripps Mauna Loa Observatory: $(head -n 1 latestValue.txt | sed -e 's/^.*reading: // ; s/,/./')"
	rm latestValue.png lValue.jpg latestValue.txt
	: retrieve lastest CO2 reading from NOAA Mauna Loa Observatory
	set -- https://gml.noaa.gov/webdata/ccgg/trends/co2/co2_daily_mlo.txt
	set -- $1 $(basename $1)
	curl --connect-timeout 5 -q $1 > $2 || {
		echo curl error >&2
		return 1
	}
	tail -n 1 $2 | awk '
	     { fmt = "Latest (%s-%02d-%02d) NOAA Mauna Loa Observatory co2 value: %s ppm\n" }
	     { printf( fmt, $1, $2, $3, $5 ) }
	     '
	rm $(basename $1)
	return
}
latestco2 2> /tmp/.latest.er
