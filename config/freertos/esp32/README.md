# Notes for ESP32

- ESP32 does only have serial ports 0-2 (where UART0 is used for stdout by default)
- You can run idf targets like `menuconfig` or `monitor` by specifing the target as an argument to the `build_firmware.sh` script
- The GPIO pins for the configured serial port can be set with `menuconfig` (see `micro-ROS Transport Settings` menu)
- ESP32 only runs in singlecore mode (`CONFIG_FREERTOS_UNICORE=y` setting)
