EXTENSIONS_DIR=$FW_TARGETDIR/freertos_apps/microros_esp32_extensions

. $PREFIX/config/utils.sh

export IDF_PATH=$FW_TARGETDIR/toolchain/esp-idf
export IDF_TOOLS_PATH=$FW_TARGETDIR/toolchain/espressif
export PATH=$PATH:$IDF_TOOLS_PATH/tools/xtensa-esp32-elf/esp-2019r2-8.2.0/xtensa-esp32-elf/bin

pushd $FW_TARGETDIR >/dev/null

    export UROS_APP=$(head -n1 $FW_TARGETDIR/APP | tail -n1)
    export UROS_APP_FOLDER="$FW_TARGETDIR/freertos_apps/apps/$UROS_APP"

    if [ -d "$UROS_APP_FOLDER" ]; then
        echo "Selected app: $UROS_APP"
    else
        echo "App not found: $UROS_APP"
        print_available_apps
        exit 1
    fi


    if [ "$UROS_FAST_BUILD" = "off" ] || [ ! -d "mcu_ws/build" ]; then
        rm -rf build
        # Clean micro-ROS build
        rm -rf mcu_ws/build mcu_ws/install mcu_ws/log
        mkdir build
    fi

    pushd build >/dev/null

        cmake -G'Unix Makefiles' \
            -DCMAKE_VERBOSE_MAKEFILE=ON \
            -DUROS_APP_FOLDER=$UROS_APP_FOLDER \
            -DIDF_PATH=$IDF_PATH \
            -DUROS_APP=$UROS_APP \
            $EXTENSIONS_DIR
        make all
    # make UROS_APP_FOLDER=$UROS_APP_FOLDER

    popd >/dev/null
popd >/dev/null
