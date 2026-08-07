pushd $FW_TARGETDIR > /dev/null

ZEPHYR_BUILD_DIR="$FW_TARGETDIR/build/zephyr"

# Host platform (=native_posix) is special, as resetting is stopping and re-executing the binary
if [ "$PLATFORM" = "host" ]; then

    # TODO: stop the previous process
    $ZEPHYR_BUILD_DIR/zephyr.exe

else

    # These boards need special openocd rules
    RESET_OPENOCD=false
    if [ "$PLATFORM" = "olimex-stm32-e407" ]; then

        RESET_OPENOCD=true
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

    elif [ "$PLATFORM" = "nucleo_f446re" ]; then

        RESET_OPENOCD=true
        OPENOCD_TARGET="stm32f4x.cfg"

        if lsusb -d 0483:374b;then
            OPENOCD_PROGRAMMER=interface/stlink-v2-1.cfg
        else
            echo "Error: Unsupported OpenOCD programmer"
            exit 1
        fi

    elif [ "$PLATFORM" = "nucleo_h743zi" ]; then

        RESET_OPENOCD=true
        OPENOCD_TARGET="stm32h7x.cfg"

        if lsusb -d 0483:374e;then
            OPENOCD_PROGRAMMER=interface/stlink.cfg
        else
            echo "Error: Unsupported OpenOCD programmer"
            exit 1
        fi

    fi



    if [ "$RESET_OPENOCD" = true ]; then

        openocd -f $OPENOCD_PROGRAMMER -f target/$OPENOCD_TARGET \
                -c init \
                -c "reset halt" \
                -c "reset run; exit"

    else

	echo "Error: Resetting device is only supported with OpenOCD"
	exit 1

    fi

fi

popd > /dev/null
