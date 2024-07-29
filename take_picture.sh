#!/bin/bash

# MQTT broker details
MQTT_BROKER="0a611c2211104d4c82b15ec089b0ab68.s1.eu.hivemq.cloud"
MQTT_USERNAME="will"
MQTT_PASSWORD="PlayBallGame83"
MQTT_TOPIC="picamera/image"
MQTT_PORT=30001 

while true; do
    # Take a picture
    rpicam-still -o /usr/src/app/image.png --width 1920 --height 1080
    
    # Publish the image to the MQTT broker
    mosquitto_pub -h "$MQTT_BROKER" -p "$MQTT_PORT" -u "$MQTT_USERNAME" -P "$MQTT_PASSWORD" -t "$MQTT_TOPIC" -f /usr/src/app/image.png
    
    # Wait for 60 seconds
    sleep 60
done
