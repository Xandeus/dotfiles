#!/bin/sh

get_icon() {
    case $1 in
        01d) icon="";; #Clear Sky Day
        01n) icon="";; #Clear sky night
        02d) icon="";; #Few clouds
        02n) icon="";;
        03*) icon="";; #Scattered clouds
        04*) icon="";; #Broken clouds
        09d) icon="";; #Shower rain
        09n) icon="";;
        10d) icon="";; #Rain
        10n) icon="";;
        11d) icon="";; #Thunderstorm
        11n) icon="";;
        13d) icon="";; #Snow
        13n) icon="";;
        50d) icon="";; #Mist
        50n) icon="";;
        *) icon="17";
    esac

    echo $icon
}

get_duration() {

    osname=$(uname -s)

    case $osname in
        *BSD) date -r "$1" -u +%H:%M;;
        *) date --date="@$1" -u +%H:%M;;
    esac

}

KEY="2ff5155be7224f4686e592d880ac1188"
CITY="Minneapolis, US"
UNITS="metric"
SYMBOL="°"

API="https://api.openweathermap.org/data/2.5"
if [ -n "$CITY" ]; then
    if [ "$CITY" -eq "$CITY" ] 2>/dev/null; then
        CITY_PARAM="id=$CITY"
    else
        CITY_PARAM="q=$CITY"
    fi

    current=$(curl -sf "$API/weather?appid=$KEY&$CITY_PARAM&units=$UNITS")
    forecast=$(curl -sf "$API/forecast?appid=$KEY&$CITY_PARAM&units=$UNITS&cnt=7")
else
    location=$(curl -sf https://location.services.mozilla.com/v1/geolocate?key=geoclue)

    if [ -n "$location" ]; then
        location_lat="$(echo "$location" | jq '.location.lat')"
        location_lon="$(echo "$location" | jq '.location.lng')"

        current=$(curl -sf "$API/weather?appid=$KEY&lat=$location_lat&lon=$location_lon&units=$UNITS")
        forecast=$(curl -sf "$API/forecast?appid=$KEY&lat=$location_lat&lon=$location_lon&units=$UNITS&cnt=5")
    fi
fi

if [ -n "$current" ] && [ -n "$forecast" ]; then
    current_temp=$(echo "$current" | jq ".main.temp" | cut -d "." -f 1)
    current_icon=$(echo "$current" | jq -r ".weather[0].icon")

    forecast_temp=$(echo "$forecast" | jq ".list[6].main.temp" | cut -d "." -f 1)
    forecast_icon=$(echo "$forecast" | jq -r ".list[6].weather[0].icon")


    if [ "$current_temp" -gt "$forecast_temp" ]; then
        trend=""
    elif [ "$forecast_temp" -gt "$current_temp" ]; then
        trend=""
    else
        trend=""
    fi


    sun_rise=$(echo "$current" | jq ".sys.sunrise")
    sun_set=$(echo "$current" | jq ".sys.sunset")
    now=$(date +%s)

    if [ "$sun_rise" -gt "$now" ]; then
        daytime=" $(get_duration "$((sun_rise-now))")"
    elif [ "$sun_set" -gt "$now" ]; then
        daytime=" $(get_duration "$((sun_set-now))")"
    else
        daytime=" $(get_duration "$((sun_rise-now))")"
    fi
    echo "$(get_icon "$current_icon") $current_temp$SYMBOL $daytime"
    #echo "$(get_icon "$current_icon") $current_temp$SYMBOL  $trend  $(get_icon "$forecast_icon") $forecast_temp$SYMBOL   $daytime"
fi
