set +o nounset

OLIMEX_EXTENSIONS_DIR=$FW_TARGETDIR/olimex_e407_extensions

pushd $OLIMEX_EXTENSIONS_DIR >/dev/null
    if [[ -v UROS_EXTERNAL_DEPS ]]; then
        echo "Using external deps: $UROS_EXTERNAL_DEPS"
        EXTRA="CROSS_COMPILE=$UROS_EXTERNAL_DEPS"
    fi

    if [ "$UROS_FAST_BUILD" = "off" ] || [ ! -d "build" ]; then
        # clean build
        make clean

        # build micro-ROS stack
        make libmicroros $EXTRA
    fi

    # build firmware
    make $EXTRA
popd >/dev/null
