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
    if [ -f $PREFIX/config/$rtos/generic/supported_platforms ];then

        while read line; do
            echo "+-- $line"
        done < $PREFIX/config/$rtos/generic/supported_platforms
    else
        pushd $rtos >/dev/null
        for platform in $(ls -d */ | cut -f1 -d'/'); do
            echo "+-- $platform"
        done
        popd >/dev/null
    fi
  done
  popd >/dev/null
}

# Retrieving RTOS and Platform

if [ $# -ge 1 ]; then
    RTOS=$1
else
    echo "Syntax: ros2 run micro_ros_setup create_firmware_ws.sh <package> [<platform>]"
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
if [ -d $PREFIX/config/$RTOS/$PLATFORM ] || [ -d "$PREFIX/config/$RTOS/generic" ]; then
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

if [ -z ${EXTERNAL_SKIP+x} ]; then
  EXTERNAL_SKIP=""
fi

SKIP="microxrcedds_agent microxrcedds_client microcdr rosidl_typesupport_connext_cpp rosidl_typesupport_connext_c rosidl_typesupport_opensplice_cpp rosidl_typesupport_opensplice_c rmw_opensplice_cpp ros-${ROS_DISTRO}-cyclonedds  ros-${ROS_DISTRO}-rti-connext-dds-cmake-module ros-${ROS_DISTRO}-rmw-connextdds-common ros-${ROS_DISTRO}-rmw-connextdds ros-${ROS_DISTRO}-rmw-cyclonedds-cpp google_benchmark_vendor performance_test_fixture ros-${ROS_DISTRO}-mimick-vendor rmw_cyclonedds_cpp rmw_connext_cpp rti-connext-dds-5.3.1 rmw_connextdds $EXTERNAL_SKIP"

# Check generic build
if [ -d "$PREFIX/config/$RTOS/generic" ]; then
    TARGET_FOLDER=generic
else
    TARGET_FOLDER=$PLATFORM
fi

pushd $FW_TARGETDIR >/dev/null
    # Creating dev directory
    mkdir $DEV_WS_DIR

    if [ $RTOS != "host" ]; then
        ros2 run micro_ros_setup create_ws.sh $DEV_WS_DIR $PREFIX/config/$RTOS/dev_ros2_packages.txt \
            $PREFIX/config/$RTOS/dev_uros_packages.repos
        rosdep install --os=ubuntu:jammy -y --from-paths $DEV_WS_DIR -i $DEV_WS_DIR --rosdistro $ROS_DISTRO --skip-keys="$SKIP"

         # Creating mcu directory
        mkdir mcu_ws
        ros2 run micro_ros_setup create_ws.sh mcu_ws $PREFIX/config/client_ros2_packages.txt $PREFIX/config/$RTOS/$TARGET_FOLDER/client_uros_packages.repos
        cp $PREFIX/config/$RTOS/$TARGET_FOLDER/client-colcon.meta mcu_ws/colcon.meta || :
    fi
popd >/dev/null

# build the dev_ws
. $(dirname $0)/clean_env.sh
if [ $RTOS != "host" ]; then
    pushd $FW_TARGETDIR/$DEV_WS_DIR >/dev/null
        colcon build
        set +o nounset
        # source dev workspace
        . install/setup.bash
    popd > /dev/null
fi

# Install dependecies for specific platform
rosdep install --os=ubuntu:jammy -y --from-paths $PREFIX/config/$RTOS/$TARGET_FOLDER -i $PREFIX/config/$RTOS/$TARGET_FOLDER --rosdistro $ROS_DISTRO --skip-keys="$SKIP"

# Creating specific firmware folder
. $PREFIX/config/$RTOS/$TARGET_FOLDER/create.sh

