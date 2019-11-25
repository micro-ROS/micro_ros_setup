NUTTX_DIR=$FW_TARGETDIR/NuttX
DEV_WS_DIR=$FW_TARGETDIR/dev_ws

pushd $DEV_WS_DIR >/dev/null
colcon build
set +o nounset
. install/setup.bash
popd > /dev/null

pushd $NUTTX_DIR >/dev/null
make
popd >/dev/null
