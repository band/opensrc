gosatghg ()
{
    : retrieve latest monthly mean CO2 and CH4 readings from Japan NIES GOSAT project data
    : uses: awk, basename, curl, echo, tail, tr, unzip
    : run:  source gosatghg.sh
    : to see the "canonical format", which gosatghg
    : co2 data first
    set -- https://www.gosat.nies.go.jp/assets/whole-atmosphere-monthly-mean_co2_$(date -v-2m "+%B_%Y" | tr '[:upper:]' '[:lower:]').txt.zip
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
    : ch4 data next
    set -- https://www.gosat.nies.go.jp/assets/whole-atmosphere-monthly-mean_ch4_$(date -v-2m "+%B_%Y" | tr '[:upper:]' '[:lower:]').txt.zip
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
    rm whole-atmosphere*.*
    return
}
gosatghg 2> /tmp/.latest.er
