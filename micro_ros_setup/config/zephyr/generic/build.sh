print_available_apps () {
  echo "Available apps for :"
  pushd $FW_TARGETDIR/zephyr_apps/apps >/dev/null
  for app in $(ls -d */ | cut -f1 -d'/'); do 
    echo "+-- $app"
  done
  popd >/dev/null
}

pushd $FW_TARGETDIR >/dev/null
    source $FW_TARGETDIR/zephyrproject/zephyr/zephyr-env.sh
    export ZEPHYR_TOOLCHAIN_VARIANT=zephyr
    export ZEPHYR_SDK_INSTALL_DIR=$(pwd)/zephyr-sdk-0.11.1

    export PATH=~/.local/bin:"$PATH"

    rm -rf build

    unset UROS_APP
    
    if [ "$UROS_FAST_BUILD" = "off" ] || [ ! -d "mcu_ws/build" ]; then
        rm -rf mcu_ws/build mcu_ws/install mcu_ws/log
        export UROS_APP=$1
    else
        export UROS_APP=$2
    fi

    if [ -d "$FW_TARGETDIR/zephyr_apps/apps/$UROS_APP" ]; then
        echo "Selected app: $UROS_APP"
    else
        echo "App not found: $UROS_APP"
        print_available_apps
        exit 1
    fi

    if [ "$PLATFORM" = "st-b-l475e-iot01a" ]; then
        export BOARD="disco_l475_iot1"
    elif [ "$PLATFORM" = "olimex-stm32-e407" ]; then
        export BOARD="olimex_stm32_e407"
    else
        echo "Unrecognized board: $PLATFORM"
        exit 1
    fi


    west build -b $BOARD -p auto $FW_TARGETDIR/zephyr_apps/apps/$UROS_APP -- -G'Unix Makefiles' -DCMAKE_VERBOSE_MAKEFILE=ON
    # west build -p auto -b olimex_stm32_e407 olimex_e407_extensions -- -G'Unix Makefiles'
popd >/dev/null
