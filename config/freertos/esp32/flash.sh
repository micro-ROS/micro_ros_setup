EXTENSIONS_DIR=$FW_TARGETDIR/freertos_apps/microros_esp32_extensions

export IDF_TOOLS_PATH=$FW_TARGETDIR/toolchain/espressif
export IDF_PATH=$FW_TARGETDIR/toolchain/esp-idf

eval $(python3 $FW_TARGETDIR/toolchain/esp-idf/tools/idf_tools.py export --prefer-system)

. $IDF_PATH/export.sh

pushd $EXTENSIONS_DIR/build > /dev/null

  make flash/fast

popd > /dev/null

