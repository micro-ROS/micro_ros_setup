# Notes for ESP32

- ESP32 does only have serial ports 0-2 (where UART0 is used for stdout by default)
- You can run idf targets like `menuconfig` or `monitor` by specifing the target as an argument to the `build_firmware.sh` script
- The GPIO pins for the configured serial port can be set with `menuconfig` (see `micro-ROS Transport Settings` menu)
- ESP32 only runs in singlecore mode (`CONFIG_FREERTOS_UNICORE=y` setting)


# Notes for ESP32-CAMERA 

- SPIRAM is requierd only for ESP32-CAMERA and can cause a fatal error in ESP32 (Enable in  `menuconfig Component config > ESP32-specific` OR  add CONFIG_ESP32_SPIRAM_SUPPORT=y to `sdkconfig.defaults` file).
- Make sure that `rtc_gpio_desc` array is supported in `menuconfig: Component config > Driver configurations > RTCIO configuration` (set to TRUE)
- Choose your camera pins configuration in `menuconfig Camera configuration > Camera pins`. (`BOARD_ESP32CAM_AITHINKER` is default).
