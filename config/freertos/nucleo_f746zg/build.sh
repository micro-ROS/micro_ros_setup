EXTENSIONS_DIR=$FW_TARGETDIR/freertos_apps/microros_nucleo_f746zg_extensions

. $PREFIX/config/utils.sh

pushd $EXTENSIONS_DIR >/dev/null

    export UROS_APP=$(head -n1 $FW_TARGETDIR/APP | tail -n1)

    if [ -v UROS_CUSTOM_APP_FOLDER ]; then
        export UROS_APP_FOLDER="$UROS_CUSTOM_APP_FOLDER/$UROS_APP"
    else
        export UROS_APP_FOLDER="$FW_TARGETDIR/freertos_apps/apps/$UROS_APP"
    fi

    if [ -d "$UROS_APP_FOLDER" ]; then
        echo "Selected app: $UROS_APP"
    else
        echo "App not found: $UROS_APP"
        print_available_apps
        exit 1
    fi

    if [ "$UROS_FAST_BUILD" = "off" ] || [ ! -d "build" ]; then
        # Clean micro-ROS build
        rm -rf $FW_TARGETDIR/mcu_ws/build $FW_TARGETDIR/mcu_ws/install $FW_TARGETDIR/mcu_ws/log

        # Clean build
        make clean

        # Build micro-ROS stack
        make libmicroros
    fi

    # Build firmware
    make -j$(nproc) UROS_APP_FOLDER=$UROS_APP_FOLDER
popd >/dev/null
