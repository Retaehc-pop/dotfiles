#!/bin/bash

#CITY=$(curl -s 'https://ipinfo.io/city' 2>/dev/null)

CITY=$(curl -s 'http://ip-api.com/json/?fields=city' 2>/dev/null | grep -oP '(?<="city":")[^"]*')

if [[ -n "$CITY" ]]; then
  # Fetch weather info for the detected city from wttr.in
  weather_info=$(curl -s "wttr.in/$CITY?format=%c+%C+%t" 2>/dev/null)

  # Check if the weather info is valid
  if [[ -n "$weather_info" ]]; then
    echo "▼ $CITY: $weather_info"
  else
    echo "Weather info unavailable for $CITY"
  fi
else
  echo "Unable to determine your location"
fi
