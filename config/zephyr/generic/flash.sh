pushd $FW_TARGETDIR > /dev/null

ZEPHYR_BUILD_DIR="$FW_TARGETDIR/build/zephyr"

# Host platform (=native_posix) is special, as flashing is actually just executing the binary
if [ "$PLATFORM" = "host" ]; then

    if [ ! -f "$ZEPHYR_BUILD_DIR/zephyr.exe" ]; then
        echo "Error: $ZEPHYR_BUILD_DIR/zephyr.exe not found. Please compile before flashing."
        exit 1
    fi

    $ZEPHYR_BUILD_DIR/zephyr.exe

else

    if [ ! -f "$ZEPHYR_BUILD_DIR/zephyr.bin" ]; then
        echo "Error: $ZEPHYR_BUILD_DIR/zephyr.bin not found. Please compile before flashing."
        exit 1
    fi



    # Choose flash method based on board
    if [ "$PLATFORM" = "discovery_l475_iot1" ] || [ "$PLATFORM" = "nucleo_f401re" ]; then

        export ZEPHYR_TOOLCHAIN_VARIANT=zephyr
        export ZEPHYR_SDK_INSTALL_DIR=$FW_TARGETDIR/zephyr-sdk

        source $FW_TARGETDIR/zephyrproject/zephyr/zephyr-env.sh

        export PATH=~/.local/bin:"$PATH"

        west flash

    elif [ "$PLATFORM" = "olimex-stm32-e407" ]; then

        if lsusb -d 15BA:002a; then
            PROGRAMMER=interface/ftdi/olimex-arm-usb-tiny-h.cfg
        elif lsusb -d 15BA:0003;then
            PROGRAMMER=interface/ftdi/olimex-arm-usb-ocd.cfg
        elif lsusb -d 15BA:002b;then
            PROGRAMMER=interface/ftdi/olimex-arm-usb-ocd-h.cfg
        else
            echo "Error: Unsuported OpenOCD USB programmer"
            exit 1
        fi

        openocd -f $PROGRAMMER -f target/stm32f4x.cfg -c init -c "reset halt" -c "flash write_image erase build/zephyr/zephyr.bin 0x08000000" -c "reset" -c "exit"

    elif [ "$PLATFORM" = "nucleo_h743zi" ]; then

        if lsusb -d 0483:374e;then
            PROGRAMMER=interface/stlink.cfg
            TARGET=stm32h7x.cfg
        else
            echo "Error: Unsupported OpenOCD programmer"
            exit 1
        fi

        openocd -f $PROGRAMMER -f target/$TARGET -c init -c "reset halt" -c "flash write_image erase build/zephyr/zephyr.bin 0x08000000" -c "reset run; exit"

    else

        echo "Unrecognized board: $PLATFORM"
        exit 1

    fi

fi

popd > /dev/null
