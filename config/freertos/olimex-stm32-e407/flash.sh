OLIMEX_EXTENSIONS_DIR=$FW_TARGETDIR/freertos_apps/microros_olimex_e407_extensions

pushd $OLIMEX_EXTENSIONS_DIR > /dev/null

  if [ -f build/micro-ROS.bin ]; then
    echo "Flashing firmware for $RTOS platform $PLATFORM"

      if lsusb -d 15BA:002a; then
        PROGRAMMER=interface/ftdi/olimex-arm-usb-tiny-h.cfg
      elif lsusb -d 15BA:0003;then
        PROGRAMMER=interface/ftdi/olimex-arm-usb-ocd.cfg
      elif lsusb -d 15BA:002b;then
        PROGRAMMER=interface/ftdi/olimex-arm-usb-ocd-h.cfg
      elif lsusb -d 0483:374b; then
        PROGRAMMER=interface/stlink-v2-1.cfg
      elif lsusb -d 0483:3748; then
        PROGRAMMER=interface/stlink-v2.cfg
      elif lsusb -d 1366:0101 || lsusb -d 1366:0105; then
        PROGRAMMER=interface/jlink.cfg
      else
        echo "Error. Unsuported OpenOCD USB programmer"
        exit 1
      fi

      openocd -f $PROGRAMMER -f target/stm32f4x.cfg -c init -c "reset halt" -c "flash write_image erase build/micro-ROS.bin 0x08000000" -c "reset" -c "exit"
  else
    echo "build/micro-ROS.bin not found: please compile before flashing."
  fi

popd > /dev/null


