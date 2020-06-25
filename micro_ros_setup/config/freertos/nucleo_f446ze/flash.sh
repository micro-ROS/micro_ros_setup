NUCLEO_EXTENSIONS_DIR=$FW_TARGETDIR/freertos_apps/microros_nucleo_f446ze_extensions

pushd $NUCLEO_EXTENSIONS_DIR > /dev/null

#TODO: fix into st-link

  if [ -f build/nucleof446ze_uros_template.bin ]; then
    echo "Flashing firmware for $RTOS platform $PLATFORM"
    st-flash --reset write build/nucleof446ze_uros_template.bin 0x8000000
  else
    echo "build/nucleof446ze_uros_template.bin not found: please compile before flashing."
  fi

popd > /dev/null
