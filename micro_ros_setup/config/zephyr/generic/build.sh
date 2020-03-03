print_available_apps () {
  echo "Available apps for :"
  pushd $FW_TARGETDIR/zephyr_apps/apps >/dev/null
  for app in $(ls -d */ | cut -f1 -d'/'); do 
    echo "+-- $app"
  done
  popd >/dev/null
}

. $PREFIX/config/utils.sh

pushd $FW_TARGETDIR >/dev/null
    source $FW_TARGETDIR/zephyrproject/zephyr/zephyr-env.sh
    export ZEPHYR_TOOLCHAIN_VARIANT=zephyr
    export ZEPHYR_SDK_INSTALL_DIR=$(pwd)/zephyr-sdk

    export PATH=~/.local/bin:"$PATH"


    # Retrieve user app
    unset UROS_APP

    if [ $# -lt 1 ]; then
        echo "Please insert an app to build"
        print_available_apps
        exit 1
    fi
            
    UROS_APP=$(head -n3 $FW_TARGETDIR/PLATFORM | tail -n1)
    UROS_APP_FOLDER="$FW_TARGETDIR/zephyr_apps/apps/$UROS_APP"

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
    else
        echo "Unrecognized board: $PLATFORM"
        exit 1
    fi

    # Run app configuration if any
    if [ -f "$UROS_APP_FOLDER/micro-ros-conf.sh" ]; then
        . "$UROS_APP_FOLDER/micro-ros-conf.sh"
    fi

    # Build Zephyr + app
    west build -b $BOARD -p auto $UROS_APP_FOLDER -- -G'Unix Makefiles' -DCMAKE_VERBOSE_MAKEFILE=ON
popd >/dev/null
