EXTENSIONS_DIR=$FW_TARGETDIR/freertos_apps/microros_esp32_extensions

export IDF_TOOLS_PATH=$FW_TARGETDIR/toolchain/espressif
export IDF_PATH=$FW_TARGETDIR/toolchain/esp-idf

export VIRTUAL_ENV="$FW_TARGETDIR/toolchain/python_env"
export PATH="$VIRTUAL_ENV/bin:$PATH"

. $IDF_PATH/export.sh

pushd $EXTENSIONS_DIR/build > /dev/null

  make flash/fast

popd > /dev/null

