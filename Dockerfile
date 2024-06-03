# Use a base Debian Bullseye image
FROM debian:bullseye

# Install necessary dependencies and tools
RUN apt-get update && \
    apt-get install -y \
    # openssh-server \
    dkms \
    build-essential \
    git \
    v4l-utils \
    python3-dev \
    python3-pip \
    python3-yaml \
    python3-ply \
    cmake \
    libboost-dev \
    libgnutls28-dev openssl libtiff5-dev libjpeg-dev libpng-dev pybind11-dev \
    qtbase5-dev libqt5core5a libqt5gui5 libqt5widgets5 \
    libboost-program-options-dev libdrm-dev libexif-dev \
    && apt-get clean

# Install the required Python modules using pip
RUN pip3 install meson ninja jinja2 
#ply pyyaml

# Clone and build libcamera
RUN git clone https://github.com/raspberrypi/libcamera.git /libcamera && \
    cd /libcamera && \
    meson setup build --buildtype=release -Dpipelines=rpi/vc4,rpi/pisp -Dipas=rpi/vc4,rpi/pisp -Dv4l2=true -Dgstreamer=disabled -Dtest=false -Dlc-compliance=disabled -Dcam=disabled -Dqcam=disabled -Ddocumentation=disabled -Dpycamera=enabled && \
    ninja -C build && \
    ninja -C build install

# Clone and build rpicam-apps
RUN git clone https://github.com/raspberrypi/rpicam-apps.git /rpicam-apps && \
    cd /rpicam-apps && \
    sed -i 's/platform = options_->GetPlatform();/platform = Platform::VC4;/' core/rpicam_app.cpp && \
    meson setup build -Denable_libav=disabled -Denable_drm=enabled -Denable_egl=disabled -Denable_qt=disabled -Denable_opencv=disabled -Denable_tflite=disabled && \
    meson compile -C build && \
    meson install -C build

RUN usermod -a -G video root

# Ensure the container has access to video devices
ENV UDEV=on
ENV LD_LIBRARY_PATH=/usr/local/lib/aarch64-linux-gnu:/libcamera/build/src/libcamera:${LD_LIBRARY_PATH}
# Set up SSH access 
# RUN mkdir /var/run/sshd
# RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# RUN sed -i 's|#AuthorizedKeysFile     .ssh/authorized_keys .ssh/authorized_keys2|AuthorizedKeysFile     .ssh/authorized_keys .ssh/authorized_keys2|' /etc/ssh/sshd_config
# RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
# RUN mkdir /root/.ssh
# RUN touch /root/.ssh/authorized_keys 
# EXPOSE 22

WORKDIR /usr/src/app

CMD ["sleep", "infinity"]
