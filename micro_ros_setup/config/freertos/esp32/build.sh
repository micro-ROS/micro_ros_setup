EXTENSIONS_DIR=$FW_TARGETDIR/freertos_apps/microros_esp32_extensions

. $PREFIX/config/utils.sh

export IDF_PATH=$FW_TARGETDIR/toolchain/esp-idf
export IDF_TOOLS_PATH=$FW_TARGETDIR/toolchain/espressif
export PATH=$PATH:$IDF_TOOLS_PATH/tools/xtensa-esp32-elf/esp-2019r2-8.2.0/xtensa-esp32-elf/bin

export UROS_APP=$(head -n1 $FW_TARGETDIR/APP | tail -n1)
export UROS_APP_FOLDER="$FW_TARGETDIR/freertos_apps/apps/$UROS_APP"

if [ -d "$UROS_APP_FOLDER" ]; then
    echo "Selected app: $UROS_APP"
else
    echo "App not found: $UROS_APP"
    print_available_apps
    exit 1
fi

pushd $EXTENSIONS_DIR/build >/dev/null
    make $@
popd >/dev/null