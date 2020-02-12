CF_DIR=$FW_TARGETDIR/crazyflie_firmware
CF_EXTENSIONS_DIR=$FW_TARGETDIR/crazyflie_microros_extensions

pushd $CF_DIR >/dev/null
    git submodule init
    git submodule update
popd >/dev/null

pushd $CF_EXTENSIONS_DIR >/dev/null
    if [ "$UROS_FAST_BUILD" = "off" ] || [ ! -d "bin" ]; then
        # clean build
        make clean

        # build micro-ROS stack
        if [[ -v UROS_EXTERNAL_DEPS ]]; then
            echo "Using external deps: $UROS_EXTERNAL_DEPS"
            EXTRA="CROSS_COMPILE=$UROS_EXTERNAL_DEPS"
        fi
        make libmicroros $EXTRA
    fi
    # build crayflie firmware
    make PLATFORM=cf2 CLOAD=0 $EXTRA
popd >/dev/null
