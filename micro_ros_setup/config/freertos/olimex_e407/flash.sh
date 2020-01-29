OLIMEX_EXTENSIONS_DIR=$FW_TARGETDIR/olimex_e407_extensions

pushd $OLIMEX_EXTENSIONS_DIR > /dev/null

  if [ -f build/micro-ROS.bin ]; then
    echo "Flashing firmware for $RTOS platform $PLATFORM"
    openocd -f interface/ftdi/olimex-arm-usb-tiny-h.cfg -f target/stm32f4x.cfg -c init -c "reset halt" -c "flash write_image erase build/micro-ROS.bin 0x08000000" -c "reset" -c "exit"
  else
    echo "build/micro-ROS.bin not found: please compile before flashing."
  fi

popd > /dev/null

