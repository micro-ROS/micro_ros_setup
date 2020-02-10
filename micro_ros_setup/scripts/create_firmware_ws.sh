#! /bin/bash

set -e
set -o nounset
set -o pipefail

DEV_WS_DIR=dev_ws
FW_TARGETDIR=$(pwd)/firmware
PREFIX=$(ros2 pkg prefix micro_ros_setup)

print_available_platforms () {
  echo "Available platforms:"
  pushd $PREFIX/config >/dev/null
  for rtos in $(ls -d */ | cut -f1 -d'/'); do 
    echo ". $rtos"
    pushd $rtos >/dev/null
    for platform in $(ls -d */ | cut -f1 -d'/'); do 
          echo "+-- $platform"
    done
    popd >/dev/null
  done
  popd >/dev/null
}

# Retrieving RTOS and Platform

if [ $# -ge 1 ]; then
    RTOS=$1
else
    echo "Syntax: ros2 run micro_ros_setup create_firmware_ws.sh <RTOS name> [<platform>]"
    print_available_platforms
    exit 1
fi

if [ $# -ge 2 ]; then
    PLATFORM=$2
else
    PLATFORM=generic
fi

# Checking if firmware exists
if [ -d $FW_TARGETDIR ]; then
    echo "Firmware already created. Please delete $FW_TARGETDIR folder if you want a fresh installation."
    exit 1
fi

# Checking folders
if [ -d $PREFIX/config/$RTOS/$PLATFORM ]; then
    echo "Creating firmware for $RTOS platform $PLATFORM"
    FOLDER=$PREFIX/config/$RTOS/$PLATFORM
else
    echo "Non valid RTOS/Platform: $RTOS/$PLATFORM"
    print_available_platforms
    exit 1 
fi

mkdir $FW_TARGETDIR
touch $FW_TARGETDIR/COLCON_IGNORE

echo $RTOS > $FW_TARGETDIR/PLATFORM
echo $PLATFORM >> $FW_TARGETDIR/PLATFORM

# Setting common enviroment
SKIP="microxrcedds_client microcdr rosidl_typesupport_connext_cpp rosidl_typesupport_connext_c rosidl_typesupport_opensplice_cpp rosidl_typesupport_opensplice_c rmw_connext_cpp rmw_opensplice_cpp"

# Installing common packages 
rosdep update
rosdep install -y --from-paths src -i src --rosdistro dashing --skip-keys="$SKIP"


if [ $RTOS != "host" ]; then
    pushd $FW_TARGETDIR >/dev/null
        # Creating dev directory
        mkdir $DEV_WS_DIR
        ros2 run micro_ros_setup create_ws.sh $DEV_WS_DIR $PREFIX/config/$RTOS/dev_ros2_packages.txt \
            $PREFIX/config/$RTOS/dev_uros_packages.repos
        rosdep install -y --from-paths $DEV_WS_DIR -i $DEV_WS_DIR --rosdistro dashing --skip-keys="$SKIP"

         # Creating mcu directory
        mkdir mcu_ws
        ros2 run micro_ros_setup create_ws.sh mcu_ws $PREFIX/config/client_ros2_packages.txt $PREFIX/config/$RTOS/$PLATFORM/client_uros_packages.repos
        cp $PREFIX/config/$RTOS/$PLATFORM/client-colcon.meta mcu_ws/colcon.meta
    popd >/dev/null
fi

# build the dev_ws
. $(dirname $0)/clean_env.sh
if [ $RTOS != "host" ]; then
    pushd $FW_TARGETDIR/$DEV_WS_DIR >/dev/null
else
    pushd $FW_TARGETDIR >/dev/null
fi
  colcon build
  set +o nounset
  # source dev workspace
  . install/setup.bash
popd > /dev/null

# CHECKME: this is probably no longer necessary
rosdep install -y --from-paths $FW_TARGETDIR -i $FW_TARGETDIR --rosdistro dashing --skip-keys="$SKIP"

# Creating specific firmware folder
. $PREFIX/config/$RTOS/$PLATFORM/create.sh

