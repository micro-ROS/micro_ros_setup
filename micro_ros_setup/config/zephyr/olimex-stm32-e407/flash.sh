pushd $FW_TARGETDIR > /dev/null

  if [ -f build/zephyr/zephyr.bin ]; then
    echo "Flashing firmware for $RTOS platform $PLATFORM"

      if lsusb -d 15BA:002a; then
        PROGRAMMER=interface/ftdi/olimex-arm-usb-tiny-h.cfg
      elif lsusb -d 15BA:0003;then
        PROGRAMMER=interface/ftdi/olimex-arm-usb-ocd.cfg
      elif lsusb -d 15BA:002b;then
        PROGRAMMER=interface/ftdi/olimex-arm-usb-ocd-h.cfg
      else
        echo "Error. Unsuported OpenOCD USB programmer"
        exit 1
      fi

      openocd -f $PROGRAMMER -f target/stm32f4x.cfg -c init -c "reset halt" -c "flash write_image erase build/zephyr/zephyr.bin 0x08000000" -c "reset" -c "exit"
  else
    echo "build/zephyr/zephyr.bin not found: please compile before flashing."
  fi

popd > /dev/null

