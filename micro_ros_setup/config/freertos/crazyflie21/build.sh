CF_DIR=$FW_TARGETDIR/crazyflie_firmware
CF_EXTENSIONS_DIR=$FW_TARGETDIR/crazyflie_microros_extensions
DEV_WS_DIR=$FW_TARGETDIR/dev_ws

pushd $DEV_WS_DIR >/dev/null
if [ "$UROS_FAST_BUILD" = "off" ] && [ -d "install" ]; then
    # build workspace
	colcon build
fi
set +o nounset
# source dev workspace
. install/setup.bash
popd > /dev/null

pushd $CF_DIR >/dev/null
git submodule init
git submodule update
popd >/dev/null

pushd $CF_EXTENSIONS_DIR >/dev/null
make clean
if [ "$UROS_FAST_BUILD" = "off" ] && [ -d "bin" ]; then
    # build micro-ROS stack
	make libmicroros
fi
# build crayflie firmware
make PLATFORM=cf2 DEBUG=0 CLOAD=0
popd >/dev/null
