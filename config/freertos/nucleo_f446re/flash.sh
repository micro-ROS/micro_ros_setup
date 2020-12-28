EXTENSIONS_DIR=$FW_TARGETDIR/freertos_apps/microros_nucleo_f446re_extensions

USE_STFLASH=false

pushd $EXTENSIONS_DIR > /dev/null

  if [ -f build/micro-ROS.bin ]; then
    
    echo "Flashing firmware for $RTOS platform $PLATFORM"
    if [ $USE_STFLASH = true ]; then 
      st-flash --reset write build/micro-ROS.bin 0x8000000
    else
      if lsusb -d 0483:374b; then
        ST_INTERFACE=interface/stlink-v2-1.cfg
      elif lsusb -d 0483:3748; then
        ST_INTERFACE=interface/stlink-v2.cfg
      else
      # TODO: add stlink v3, should it be stlink.cfg ?
        echo "Error. Unsuported OpenOCD USB programmer"
        exit 1
      fi
      openocd -f $ST_INTERFACE -f target/stm32f4x.cfg -c init -c "reset halt" -c "flash write_image erase build/micro-ROS.bin 0x08000000" -c "reset" -c "exit"
    fi
  else
    echo "build/micro-ROS.bin not found: please compile before flashing."
  fi

popd > /dev/null
