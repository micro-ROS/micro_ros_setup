pushd $FW_TARGETDIR > /dev/null

if [ "$PLATFORM" = "discovery_l475_iot1" ] || [ "$PLATFORM" = "nucleo_f401re" ]|| [ "$PLATFORM" = "stm32f4_disco" ]; then
  export ZEPHYR_TOOLCHAIN_VARIANT=zephyr
  export ZEPHYR_SDK_INSTALL_DIR=$FW_TARGETDIR/zephyr-sdk

  source $FW_TARGETDIR/zephyrproject/zephyr/zephyr-env.sh

  export PATH=~/.local/bin:"$PATH"

  west flash
elif [ "$PLATFORM" = "olimex-stm32-e407" ]; then
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
elif [ "$PLATFORM" = "host" ]; then
  ./build/zephyr/zephyr.exe 
else
  echo "Unrecognized board: $PLATFORM"
  exit 1
fi

popd > /dev/null

