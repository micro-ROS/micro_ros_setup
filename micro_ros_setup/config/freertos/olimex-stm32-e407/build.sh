OLIMEX_EXTENSIONS_DIR=$FW_TARGETDIR/olimex_e407_extensions

pushd $OLIMEX_EXTENSIONS_DIR >/dev/null
    if [ "$UROS_FAST_BUILD" = "off" ] || [ ! -d "build" ]; then
        # clean build
        make clean

        # build micro-ROS stack
        make libmicroros
    fi

    # build firmware
    make
popd >/dev/null
