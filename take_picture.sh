#!/bin/bash

# MQTT broker details
MQTT_BROKER="192.5.85.172"
MQTT_USERNAME="will"
MQTT_PASSWORD="PlayBallGame83"
MQTT_TOPIC="picamera/image"
MQTT_PORT=1883 

while true; do
    libcamera-still --nopreview -o /usr/src/app/image.png --width 1920 --height 1080

    ls /usr/src/app/

    mosquitto_pub -h "$MQTT_BROKER" -p "$MQTT_PORT" -u "$MQTT_USERNAME" -P "$MQTT_PASSWORD" -t "$MQTT_TOPIC" -f /usr/src/app/image.png

    sleep 60
done