#!/bin/sh

RAW="$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null)"

if echo "$RAW" | grep -q MUTED; then
    VOL="muted"
else
    VOL="$(printf '%s\n' "$RAW" | LC_ALL=C awk '{print int($2*100) "%"}')"
fi

# pegar sink padrão
SINK="$(pactl get-default-sink)"

# pegar port ativa desse sink
PORT="$(pactl list sinks | awk -v sink="$SINK" '
$0 ~ "Name: "sink { in_sink=1; next }
/^Sink #/ && in_sink { exit }
/Active Port:/ && in_sink { print $3; exit }
')"

# traduzir nome feio -> algo útil
case "$PORT" in
    analog-output-headphones)
        OUT="Speaker"
        ;;
    analog-output-lineout)
        OUT="headphone"
        ;;
    hdmi-output-*)
        OUT="HDMI"
        ;;
    *)
        OUT="$PORT"
        ;;
esac

DATE="$(LC_TIME=pt_BR.UTF-8 date '+%a %d/%m/%Y %H:%M')"

# checar internet
if ip route get 1.1.1.1 >/dev/null 2>&1; then
    if curl -s --max-time 2 https://1.1.1.1 >/dev/null; then
        NET="🌐"
    else
        NET="⚠️"
    fi
else
    NET="❌"
fi

echo "$OUT $VOL $NET $DATE"
