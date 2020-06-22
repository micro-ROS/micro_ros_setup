NUCLEO_EXTENSIONS_DIR=$FW_TARGETDIR/freertos_apps/microros_nucleo_f446ze_extensions

pushd $NUCLEO_EXTENSIONS_DIR > /dev/null

#TODO: fix into st-link

  if [ -f build/nucleof446ze_uros_template.bin ]; then
    echo "Flashing firmware for $RTOS platform $PLATFORM"

      if lsusb -d 0483:374b; then
        PROGRAMMER=interface/stlink-v2.cfg
      else
        echo "Error. Unsuported OpenOCD USB programmer"
        exit 1
      fi

     # openocd -f $PROGRAMMER -f target/stm32f4x.cfg -c init -c "reset halt" -c "flash write_image erase build/nucleof446ze_uros_template.bin 0x08000000" -c "reset" -c "exit"
     st-flash --reset write build/nucleof446ze_uros_template.bin 0x8000000
  else
    echo "build/nucleof446ze_uros_template.bin not found: please compile before flashing."
  fi

popd > /dev/null
