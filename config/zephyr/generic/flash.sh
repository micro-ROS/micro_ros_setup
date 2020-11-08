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



    # These boards need special openocd rules
    FLASH_OPENOCD=false
    if [ "$PLATFORM" = "olimex-stm32-e407" ]; then

        FLASH_OPENOCD=true
        OPENOCD_TARGET="stm32f4x.cfg"
        if lsusb -d 15BA:002a; then
            OPENOCD_PROGRAMMER=interface/ftdi/olimex-arm-usb-tiny-h.cfg
        elif lsusb -d 15BA:0003;then
            OPENOCD_PROGRAMMER=interface/ftdi/olimex-arm-usb-ocd.cfg
        elif lsusb -d 15BA:002b;then
            OPENOCD_PROGRAMMER=interface/ftdi/olimex-arm-usb-ocd-h.cfg
        else
            echo "Error: Unsuported OpenOCD USB programmer"
            exit 1
        fi

    elif [ "$PLATFORM" = "nucleo_h743zi" ]; then

        FLASH_OPENOCD=true
        OPENOCD_TARGET="stm32h7x.cfg"

        if lsusb -d 0483:374e;then
            OPENOCD_PROGRAMMER=interface/stlink.cfg
        else
            echo "Error: Unsupported OpenOCD programmer"
            exit 1
        fi

    fi



    if [ "$FLASH_OPENOCD" = true ]; then

        openocd -f $OPENOCD_PROGRAMMER -f target/$OPENOCD_TARGET \
                -c init \
                -c "reset halt" \
                -c "flash write_image erase $ZEPHYR_BUILD_DIR/zephyr.bin 0x08000000" \
                -c "reset run; exit"

    else

        export ZEPHYR_TOOLCHAIN_VARIANT=zephyr
        export ZEPHYR_SDK_INSTALL_DIR=$FW_TARGETDIR/zephyr-sdk
        export PATH=~/.local/bin:"$PATH"

        source $FW_TARGETDIR/zephyrproject/zephyr/zephyr-env.sh

        west flash

    fi

fi

popd > /dev/null
