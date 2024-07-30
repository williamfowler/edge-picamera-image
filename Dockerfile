# using Mike's image
FROM shermanm/rpi4-libcamera-debian:bullseye

RUN apt-get update && \
    apt-get install -y \
    mosquitto \
    mosquitto-clients

COPY take_picture.sh /usr/src/app/take_picture.sh

ENV UDEV=on

RUN chmod +x /usr/src/app/take_picture.sh

CMD ["/usr/src/app/take_picture.sh"]
# CMD ["sleep", "infinity"]