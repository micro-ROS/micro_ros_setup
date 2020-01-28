#! /bin/bash

set -e
set -o nounset
set -o pipefail

FW_TARGETDIR=firmware
PREFIX=$(ros2 pkg prefix micro_ros_setup)

# Checking if firmware exists
if [ -d $FW_TARGETDIR ]; then
    RTOS=$(head -n1 $FW_TARGETDIR/PLATFORM)
    PLATFORM=$(tail -n1 $FW_TARGETDIR/PLATFORM)
else
    echo "Firmware folder not found. Please use ros2 run micro_ros_setup create_firmware_ws.sh to create a new project."
    exit 1
fi

# Flash specific firmware folder if needed
if [ -f $PREFIX/config/$RTOS/$PLATFORM/flash.sh ]; then
  echo "Flashing firmware for $RTOS platform $PLATFORM"
  . $PREFIX/config/$RTOS/$PLATFORM/flash.sh
else
  echo "No flash step found for $RTOS platform $PLATFORM"
fi

