#! /bin/bash

set -e
set -o nounset
set -o pipefail

PREFIXES_TO_CLEAN=$AMENT_PREFIX_PATH
FW_TARGETDIR=$(pwd)/firmware
PREFIX=$(ros2 pkg prefix micro_ros_setup)

# Parse cli arguments
UROS_FAST_BUILD=off
UROS_VERBOSE_BUILD=off
UROS_EXTRA_BUILD_ARGS=""

while getopts "vf" o
do
    case "$o" in
        f)
            echo "Fast-Build active, ROS workspace will not be re-built!"
            UROS_FAST_BUILD=on
            ;;
        v)
            echo "Building in verbose mode"
            UROS_VERBOSE_BUILD=on
            ;;
        [?])
            echo "Usage: ros2 run micro_ros_setup build_firmware.sh [options] -- [build_args]"
            echo "Options:"
            echo "  -v   Print verbose build output."
            echo "  -f   Activate Fast-Build. Without this, mcu_ws will get rebuilt completely."
            echo "Build args: These options will get directly forwarded to the build system (currently only supported for zephyr)."
            exit 1
            ;;
  esac
done
shift $((OPTIND-1))

if [[ -n "$@" ]]; then
    UROS_EXTRA_BUILD_ARGS=("$@")
fi

export UROS_FAST_BUILD
export UROS_VERBOSE_BUILD
export UROS_EXTRA_BUILD_ARGS

# Checking if firmware exists
if [ -d $FW_TARGETDIR ]; then
    RTOS=$(head -n1 $FW_TARGETDIR/PLATFORM)
    PLATFORM=$(head -n2 $FW_TARGETDIR/PLATFORM | tail -n1)
    if [ -f $FW_TARGETDIR/TRANSPORT ]; then
        TRANSPORT=$(head -n1 $FW_TARGETDIR/TRANSPORT)
    fi
else
    echo "Firmware folder not found. Please use ros2 run micro_ros_setup create_firmware_ws.sh to create a new project."
    exit 1
fi

# clean paths
. $(dirname $0)/clean_env.sh

# source dev_ws
if [ $RTOS != "host" ]; then
    set +o nounset
    . $FW_TARGETDIR/dev_ws/install/setup.bash
    set -o nounset
fi

# Building specific firmware folder
echo "Building firmware for $RTOS platform $PLATFORM"

# Use the generic platform if directory found
if [ -d "$PREFIX/config/$RTOS/generic" ]; then
    . $PREFIX/config/$RTOS/generic/build.sh
else
    . $PREFIX/config/$RTOS/$PLATFORM/build.sh
fi

