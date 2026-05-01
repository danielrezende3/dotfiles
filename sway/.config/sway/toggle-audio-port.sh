#!/bin/sh

SINK=$(pactl get-default-sink)

PORT=$(pactl list sinks | awk -v sink="$SINK" '
$0 ~ "Name: "sink { in_sink=1; next }
/^Sink #/ && in_sink { exit }
/Active Port:/ && in_sink { print $3; exit }
')

if [ "$PORT" = "analog-output-lineout" ]; then
    pactl set-sink-port "$SINK" analog-output-headphones
else
    pactl set-sink-port "$SINK" analog-output-lineout
fi
