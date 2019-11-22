CF_DIR=$FW_TARGETDIR/crazyflie_firmware
DEV_WS_DIR=$FW_TARGETDIR/dev_ws

# build and source dev workspace
pushd $DEV_WS_DIR >/dev/null
colcon build
set +o nounset
. install/setup.bash
popd > /dev/null

pushd $CF_DIR >/dev/null
git submodule init
git submodule update
make clean
make PLATFORM=cf2
popd >/dev/null
