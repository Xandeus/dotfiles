#!/usr/bin/env sh

#Terminate already running bar instance
killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

polybar mybar &


echo "Bars launched..."
