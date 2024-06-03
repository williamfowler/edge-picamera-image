# edge-picamera-image
Jupyter Notebook Trovi artifact detailing how to use a Pi Camera Module 3 on CHI@Edge

This Dockerfile packages a manually compiled libcamera package with a
modification to bypass the platform check that currently fails when
running in a container on CHI@Edge. Alongside libcamera, this dockerfile
compiles rpicam apps, a series of apps that showcase how to use
libcamera on the raspberry pi platform. For proper functionality,
libcamera requires access to the following /dev devices inside the
container:

- dma_heap: required for contiguous memory allocation used for capture
  buffers
- media0:4
- v4l-subdev0 and v4l-subdev1, both of which are only available after
  specifying the imx-703 Raspberry Pi device tree overlay in /boot/config.txt
  (imx-703 refers to the driver specific to the pi camera module 3)
- vchiq
- vcsm-cma
- video0, video1, video10:16, video18:23, and video31

The /boot/config.txt options used to enable the device to expose the above are as
follows:
- gpu_mem_1024=256
- gpu_mem_256=64
- gpu_mem_512=128
- start_x=1
- camera_auto_detect=1
- disable_fw_kms_setup=0
- dtoverlay=imx708,cma-256
- avoid_warnings=1
- disable_splash=0
- dtparam=i2c_arm=on
- dtparam=spi=on
- dtparam=audio=on
- enable_uart=0
- gpu_mem=128

With all the above options in place, libcamera detect the
camera and be able to use the sensor to capture pictures and videos.
