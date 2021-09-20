export UROS_APP=$(head -n1 $FW_TARGETDIR/APP | tail -n1)
export UROS_APP_FOLDER="$FW_TARGETDIR/micro_ros_renesas_demos/$UROS_APP"

pushd $UROS_APP_FOLDER
    print "Use Renesas e2studio to build and flash the project in $UROS_APP_FOLDER"
popd