FROM ghcr.io/chameleoncloud/edge-picamera-image:latest

RUN apt-get update && \
    apt-get install -y \
    mosquitto \
    mosquitto-clients

COPY take_picture.sh /usr/src/app/take_picture.sh

ENV UDEV=on

RUN usermod -a -G video root

RUN chmod +x /usr/src/app/take_picture.sh

EXPOSE 30001

RUN service mosquitto start

CMD ["/usr/src/app/take_picture.sh"]
# CMD ["sleep", "infinity"]