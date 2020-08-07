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


    # Set platform for Zephyr
    if [ "$PLATFORM" = "discovery_l475_iot1" ]; then
        export BOARD="disco_l475_iot1"
    elif [ "$PLATFORM" = "olimex-stm32-e407" ]; then
        export BOARD="olimex_stm32_e407"
    elif [ "$PLATFORM" = "nucleo_f401re" ]; then
        export BOARD="nucleo_f401re"
    elif [ "$PLATFORM" = "stm32f4_disco" ]; then
        export BOARD="stm32f4_disco"
    elif [ "$PLATFORM" = "host" ]; then
        export BOARD="native_posix"
    else
        echo "Unrecognized board: $PLATFORM"
        exit 1
    fi

    # Build Zephyr + app
    west build -b $BOARD -p auto $UROS_APP_FOLDER -- -G'Unix Makefiles' -DCMAKE_VERBOSE_MAKEFILE=ON
popd >/dev/null
