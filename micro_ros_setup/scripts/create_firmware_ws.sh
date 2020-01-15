#! /bin/bash

set -e
set -o nounset
set -o pipefail

FW_TARGETDIR=firmware
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
apt install -y ed flex bison libncurses5-dev curl usbutils

if [ $RTOS != "host" ]; then
    pushd $FW_TARGETDIR >/dev/null

        # Creating dev directory
        mkdir dev_ws
        ros2 run micro_ros_setup create_ws.sh dev_ws $PREFIX/config/dev_ros2_packages.txt  $PREFIX/config/dev_uros_packages.repos
        rosdep install -y --from-paths dev_ws -i dev_ws --rosdistro dashing --skip-keys="$SKIP"

         # Creating mcu directory
        mkdir mcu_ws
        ros2 run micro_ros_setup create_ws.sh mcu_ws $PREFIX/config/client_ros2_packages.txt $PREFIX/config/$RTOS/$PLATFORM/client_uros_packages.repos
        cp $PREFIX/config/$RTOS/$PLATFORM/client-colcon.meta mcu_ws/colcon.meta
        rosdep install -y --from-paths mcu_ws -i mcu_ws --rosdistro dashing --skip-keys="$SKIP"

    popd >/dev/null
else

# Creating specific firmware folder
. $PREFIX/config/$RTOS/$PLATFORM/create.sh

