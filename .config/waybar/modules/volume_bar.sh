#!/bin/bash

vol=$(pulsemixer --get-volume | awk '{print $1}')
mute=$(pulsemixer --get-mute)

[ "$vol" -le "100" ] && icon=""
[ "$vol" -le "50" ] && icon=""
[ "$vol" = "0" ] && icon=""
[ "$mute" = "1" ] && icon=""

bar=""
used=0

# Add full blocks (every 20%)
while [ "$vol" -ge 20 ]; do
  bar+="█"
  vol=$((vol - 20))
  used=$((used + 1))
done

# Add partial block
if [ "$vol" -ge 15 ]; then
  bar+="▊"
  used=$((used + 1))
elif [ "$vol" -ge 10 ]; then
  bar+="▋"
  used=$((used + 1))
elif [ "$vol" -ge 5 ]; then
  bar+="▌"
  used=$((used + 1))
fi

# Fill rest with spaces to keep bar length consistent
while [ "$used" -lt 5 ]; do
  bar+=" "
  used=$((used + 1))
done

echo "{\"text\": \"$icon $bar\", \"class\": \"volume\"}"
