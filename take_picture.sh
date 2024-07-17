#!/bin/bash

while true; do
    rpicam-still -o /usr/src/app/image.png --width 1920 --height 1080
    sleep 60
done
