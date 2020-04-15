CF_DIR=$FW_TARGETDIR/crazyflie_firmware
EXTENSIONS_DIR=$FW_TARGETDIR/freertos_apps/microros_crazyflie21_extensions

. $PREFIX/config/utils.sh

pushd $CF_DIR >/dev/null
    git submodule init
    git submodule update
popd >/dev/null

pushd $EXTENSIONS_DIR >/dev/null

    export UROS_APP=$(head -n1 $FW_TARGETDIR/APP | tail -n1)
    export UROS_APP_FOLDER="$FW_TARGETDIR/freertos_apps/apps/$UROS_APP"

    if [ -d "$UROS_APP_FOLDER" ]; then
        echo "Selected app: $UROS_APP"
    else
        echo "App not found: $UROS_APP"
        print_available_apps
        exit 1
    fi

    if [ "$UROS_FAST_BUILD" = "off" ]; then
        # Clean micro-ROS build
        rm -rf $FW_TARGETDIR/mcu_ws/build $FW_TARGETDIR/mcu_ws/install $FW_TARGETDIR/mcu_ws/log

        # Build micro-ROS stack
        make libmicroros
    fi

    # Clean build
    make clean

    # build firmware
    make PLATFORM=cf2 CLOAD=0 UROS_APP_FOLDER=$UROS_APP_FOLDER
popd >/dev/null
