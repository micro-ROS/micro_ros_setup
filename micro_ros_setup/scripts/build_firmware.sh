#! /bin/bash

set -e
set -o nounset
set -o pipefail

PREFIXES_TO_CLEAN=$AMENT_PREFIX_PATH
FW_TARGETDIR=$(pwd)/firmware
PREFIX=$(ros2 pkg prefix micro_ros_setup)

UROS_FAST_BUILD=off
if [ $# -gt 0 ]
then
  if [ "$1" = "-f" ]
  then
    echo "Fast-Build active, ROS workspace will not be re-built!"
    export UROS_FAST_BUILD=y
    shift
  fi
fi
export UROS_FAST_BUILD

# Checking if firmware exists
if [ -d $FW_TARGETDIR ]; then
    RTOS=$(head -n1 $FW_TARGETDIR/PLATFORM)
    PLATFORM=$(tail -n1 $FW_TARGETDIR/PLATFORM)
else
    echo "Firmware folder not found. Please use ros2 run micro_ros_setup create_firmware_ws.sh to create a new project."
    exit 1
fi

# clean paths
. $(dirname $0)/clean_env.sh

# source dev_ws
DEV_WS_DIR=$FW_TARGETDIR/dev_ws
. $DEV_WS_DIR/install/local_setup.bash

# Building specific firmware folder
echo "Building firmware for $RTOS platform $PLATFORM"
. $PREFIX/config/$RTOS/$PLATFORM/build.sh
