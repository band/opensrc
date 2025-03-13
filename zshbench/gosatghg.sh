gosatghg ()
{
    : retrieve latest monthly mean CO2 and CH4 readings from Japan NIES GOSAT project data
    : uses: awk, basename, curl, echo, egrep, head, sed, tail, tr, unzip
    : run:  source gosatghg.sh
    : to see the "canonical format", which gosatghg
    : co2 data first
    if ! output=$(curl -q https://www.gosat.nies.go.jp/en/recent-global-co2.html > rg-co2.html); then
	echo "$output" >$2
	return $?
    fi
    data_link=$(egrep -o 'href="\.\./assets/[^"]+"' rg-co2.html | head -1 | sed 's|href="\.\./\(.*\)"|\1|g')
    set -- https://www.gosat.nies.go.jp/$data_link
    local wamm_zip="$(basename $1)"
    if ! output=$(curl --connect-timeout 5 -q $1 > $wamm_zip); then
        echo "$output" >&2
        return $?
    fi
    unzip -qo $wamm_zip
    local wamm_text=$(basename $wamm_zip .zip)
    echo "Whole-atmosphere monthly mean CO2 concentration from Japan NIES GOSAT project:"
    tail -n 1 $wamm_text | tr -d '\r\n' | awk '
    	 { fmt = "Latest %s-%02d monthly CO2 mean value: %s (ppm) | trend value: %s (ppm)\n" }
         { printf( fmt, $1, $2, $3, $4 ) }
    '
    rm rg-co2.html $wamm_zip $wamm_text
    : ch4 data next
    if ! output=$(curl -q https://www.gosat.nies.go.jp/en/recent-global-ch4.html > rg-ch4.html); then
	echo "$output" >$2
	return $?
    fi
    data_link=$(egrep -o 'href="\.\./assets/[^"]+"' rg-ch4.html | head -1 | sed 's|href="\.\./\(.*\)"|\1|g')
    set -- https://www.gosat.nies.go.jp/$data_link
    local wamm_zip="$(basename $1)"
    if ! output=$(curl --connect-timeout 5 -q $1 > $wamm_zip); then
        echo "$output" >&2
        return $?
    fi
    unzip -qo $wamm_zip
    local wamm_text=$(basename $wamm_zip .zip)
    echo "\nWhole-atmosphere monthly mean CH4 concentration from Japan NIES GOSAT project:"
    tail -n 1 $wamm_text | tr -d '\r\n' | awk '
    	 { fmt = "Latest %s-%02d monthly CH4 mean value: %s (ppb) | trend value: %s (ppb)\n" }
         { printf( fmt, $1, $2, $3, $4 ) }
    '
    rm rg-ch4.html $wamm_zip $wamm_text
    return
}
gosatghg 2> /tmp/.latest.er
