export UROS_APP=$(head -n1 $FW_TARGETDIR/APP | tail -n1)
export UROS_APP_FOLDER="$FW_TARGETDIR/micro_ros_renesas_demos/$UROS_APP"

if [ -d "$UROS_APP_FOLDER" ]; then
    echo "Selected app: $UROS_APP"
else
    echo "App not found: $UROS_APP"
    print_available_apps
    exit 1
fi

pushd $UROS_APP_FOLDER
    git submodule init
    git submodule update

    print "Use Renesas e2studio to build and flash the project in $UROS_APP_FOLDER"

popd