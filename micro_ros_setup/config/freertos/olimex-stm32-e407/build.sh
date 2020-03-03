EXTENSIONS_DIR=$FW_TARGETDIR/freertos_apps/microros_olimex_e407_extensions

. $PREFIX/config/utils.sh

print_available_apps () {
  echo "Available apps for :"
  pushd $FW_TARGETDIR/freertos_apps/apps >/dev/null
  for app in $(ls -d */ | cut -f1 -d'/'); do 
    echo "+-- $app"
  done
  popd >/dev/null
}

pushd $EXTENSIONS_DIR >/dev/null

    unset UROS_APP

    if [ $# -lt 1 ]; then
        echo "Please insert an app to build"
        print_available_apps
        exit 1
    fi      

    export UROS_APP=$1
    export UROS_APP_FOLDER="$FW_TARGETDIR/freertos_apps/apps/$UROS_APP"

    if [ -d "$UROS_APP_FOLDER" ]; then
        echo "Selected app: $UROS_APP"
    else
        echo "App not found: $UROS_APP"
        print_available_apps
        exit 1
    fi

    if [ "$UROS_FAST_BUILD" = "off" ] || [ ! -d "build" ]; then
        # Clean micro-ROS build
        rm -rf $FW_TARGETDIR/mcu_ws/build $FW_TARGETDIR/mcu_ws/install $FW_TARGETDIR/mcu_ws/log

        # Clean build
        make clean

        # Build micro-ROS stack
        make libmicroros
    fi

    # Run app configuration if any
    if [ -f "$UROS_APP_FOLDER/micro-ros-conf.sh" ]; then
        . "$UROS_APP_FOLDER/micro-ros-conf.sh"
    fi

    # Build firmware
    make UROS_APP_FOLDER=$UROS_APP_FOLDER
popd >/dev/null
