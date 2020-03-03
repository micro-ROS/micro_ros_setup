#! /bin/bash 

set -e
set -o nounset
set -o pipefail

export FW_TARGETDIR=$(pwd)/firmware
export PREFIX=$(ros2 pkg prefix micro_ros_setup)

# Checking if firmware exists
if [ -d $FW_TARGETDIR ]; then
    RTOS=$(head -n1 $FW_TARGETDIR/PLATFORM)
    PLATFORM=$(head -n2 firmware/PLATFORM | tail -n1)
else
    echo "Firmware folder not found. Please use ros2 run micro_ros_setup create_firmware_ws.sh to create a new project."
    exit 1
fi

# Configure specific firmware folder if needed
if [ $PLATFORM != "generic" ] && [ -d "$PREFIX/config/$RTOS/generic" ]; then
    if [ -f $PREFIX/config/$RTOS/generic/configure.sh ]; then
      echo "Configuring firmware for $RTOS platform $PLATFORM"
      exec $PREFIX/config/$RTOS/generic/configure.sh $@
    else
      echo "No configuration step needed for $RTOS platform $PLATFORM"
    fi
else
    if [ -f $PREFIX/config/$RTOS/$PLATFORM/configure.sh ]; then
      echo "Configuring firmware for $RTOS platform $PLATFORM"
      exec $PREFIX/config/$RTOS/$PLATFORM/configure.sh $@
    else
      echo "No configuration step needed for $RTOS platform $PLATFORM"
    fi
fi

