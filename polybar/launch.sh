#!/usr/bin/env sh

#Terminate already running bar instance
killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

polybar -r mybar &


echo "Bars launched..."
