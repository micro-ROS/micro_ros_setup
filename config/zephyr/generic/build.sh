. $PREFIX/config/utils.sh

pushd $FW_TARGETDIR >/dev/null
    source $FW_TARGETDIR/zephyrproject/zephyr/zephyr-env.sh

    export ZEPHYR_TOOLCHAIN_VARIANT=zephyr
    export ZEPHYR_SDK_INSTALL_DIR=$FW_TARGETDIR/zephyr-sdk
    export PATH=~/.local/bin:"$PATH"


    # Retrieve user app
    unset UROS_APP

    export UROS_APP=$(head -n1 $FW_TARGETDIR/APP | tail -n1)

    if [ -v UROS_CUSTOM_APP_FOLDER ]; then
        export UROS_APP_FOLDER="$UROS_CUSTOM_APP_FOLDER/$UROS_APP"
    else
        export UROS_APP_FOLDER="$FW_TARGETDIR/zephyr_apps/apps/$UROS_APP"
    fi

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
    if [ "$PLATFORM" = "nucleo_f746zg" ]; then
        export BOARD="nucleo_f746zg"
    elif [ "$PLATFORM" = "discovery_l475_iot1" ]; then
        export BOARD="disco_l475_iot1"
    elif [ "$PLATFORM" = "olimex-stm32-e407" ]; then
        export BOARD="olimex_stm32_e407"
    elif [ "$PLATFORM" = "nucleo_f401re" ]; then
        export BOARD="nucleo_f401re"
    elif [ "$PLATFORM" = "nucleo_h743zi" ]; then
        export BOARD="nucleo_h743zi"
    elif [ "$PLATFORM" = "host" ]; then
        export BOARD="native_posix"
    else
        echo "Unrecognized board: $PLATFORM. Trying to build"
        export BOARD=$PLATFORM
    fi

    # Choose configuration based on transport and host
    if [ -z "$TRANSPORT" ]; then
        echo "Configuration: No transport set, using prj.conf"
        export CONF_FILE="prj.conf"

    elif [ "$PLATFORM" = "host" ]; then
        echo "Configuration: Platform 'host' detected, using host-udp.conf"
        export CONF_FILE="host-udp.conf"

    else
        if [ ! -f "$UROS_APP_FOLDER/$TRANSPORT.conf" ]; then
            echo "Configuration: Specific config for transport $TRANSPORT not found, using prj.conf"
            export CONF_FILE="prj.conf"
        else
            echo "Configuration: Using transport-specific $TRANSPORT.conf"
            export CONF_FILE="$TRANSPORT.conf"
        fi
    fi

    UROS_BUILD_CMD="
        west build
          -b $BOARD
          -p auto
          $UROS_APP_FOLDER
          -- -DCONF_FILE=$UROS_APP_FOLDER/$CONF_FILE
             -G'Unix Makefiles'
             -DCMAKE_VERBOSE_MAKEFILE=$UROS_VERBOSE_BUILD
             -DMICRO_ROS_FIRMWARE_DIR=$FW_TARGETDIR
             -DMICRO_ROS_TRANSPORT=$TRANSPORT
             ${UROS_EXTRA_BUILD_ARGS[@]}"

    if [ "$UROS_VERBOSE_BUILD" = "on" ]; then
        echo ""
        echo "-----------------------------"
        echo "| Verbose build information |"
        echo "-----------------------------"
        echo "Fast build:                  $UROS_FAST_BUILD"
        echo "App name:                    $UROS_APP"
        echo "Full app path:               $UROS_APP_FOLDER"
        echo "Zephyr board:                $BOARD"
        echo "Zephyr configuration file:   $UROS_APP_FOLDER/$CONF_FILE"
        echo "Extra build arguments:       ${UROS_EXTRA_BUILD_ARGS[@]}"
        echo "Full build command:          "${UROS_BUILD_CMD[@]}
        echo ""
    fi

    # Build zephyr + app
    eval ${UROS_BUILD_CMD[@]}

popd >/dev/null
