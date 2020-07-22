EXTENSIONS_DIR=$FW_TARGETDIR/freertos_apps/microros_esp32_extensions

pushd $EXTENSIONS_DIR/build > /dev/null

  make flash/fast

popd > /dev/null

