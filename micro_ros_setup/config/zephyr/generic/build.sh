. $PREFIX/config/utils.sh

pushd $FW_TARGETDIR >/dev/null
    source $FW_TARGETDIR/zephyrproject/zephyr/zephyr-env.sh

    export ZEPHYR_TOOLCHAIN_VARIANT=zephyr
    export ZEPHYR_SDK_INSTALL_DIR=$FW_TARGETDIR/zephyr-sdk
    export PATH=~/.local/bin:"$PATH"


    # Retrieve user app
    unset UROS_APP
            
    export UROS_APP=$(head -n1 $FW_TARGETDIR/APP | tail -n1)
    export UROS_APP_FOLDER="$FW_TARGETDIR/zephyr_apps/apps/$UROS_APP"

    if [ -d "$UROS_APP_FOLDER" ]; then
        echo "Selected app: $UROS_APP"
    else
        echo "App not found: $UROS_APP"
        print_available_apps
        exit 1
    fi

    # Clean previous builds
    rm -rf build

    if [ "$UROS_FAST_BUILD" = "off" ] || [ ! -d "mcu_ws/build" ]; then
        rm -rf mcu_ws/build mcu_ws/install mcu_ws/log
    fi

    # Platform renaming for Zephyr
    if [ "$PLATFORM" = "discovery_l475_iot1" ]; then
        export BOARD="disco_l475_iot1"
    elif [ "$PLATFORM" = "olimex-stm32-e407" ]; then
        export BOARD="olimex_stm32_e407"
    elif [ "$PLATFORM" = "nucleo_f401re" ]; then
        export BOARD="nucleo_f401re"
    elif [ "$PLATFORM" = "host" ]; then
        export BOARD="native_posix"
    else
        echo "Unrecognized board: $PLATFORM"
        exit 1
    fi

    # Use transport specific conf if given and exists.
    if [ -z "$TRANSPORT" ];then
        export CONF_FILE="prj.conf"
    else
        if [ ! -f "$UROS_APP_FOLDER/$TRANSPORT.conf" ]; then
            echo "Specific config for transport not found. Using prj.conf."
            export CONF_FILE="prj.conf"
        else
            export CONF_FILE="$TRANSPORT.conf"
        fi
    fi

    if [ "$PLATFORM" = "host" ]; then
        echo "Zephyr native-posix detected. Using host-udp.conf."

        export CONF_FILE="host-udp.conf"
    fi

    # Build Zephyr + app
    west build -b $BOARD -p auto $UROS_APP_FOLDER -- -DCONF_FILE=$UROS_APP_FOLDER/$CONF_FILE -G'Unix Makefiles' -DCMAKE_VERBOSE_MAKEFILE=ON -DCMAKE_BUILD_TYPE=Debug
popd >/dev/null
