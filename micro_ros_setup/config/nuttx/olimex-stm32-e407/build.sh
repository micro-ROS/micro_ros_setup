NUTTX_DIR=$FW_TARGETDIR/NuttX
DEV_WS_DIR=$FW_TARGETDIR/dev_ws

if [ "$UROS_FAST_BUILD" = "off" ]
then
	pushd $DEV_WS_DIR >/dev/null
	colcon build
	set +o nounset
	. install/setup.bash
	popd > /dev/null
fi

pushd $NUTTX_DIR >/dev/null
make
popd >/dev/null
