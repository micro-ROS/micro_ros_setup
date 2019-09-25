#! /bin/bash

set -e
set -o nounset
set -o pipefail

TARGETDIR=src

if [ $# -gt 0 ]
then
    TARGETDIR=$1
fi

[ -d $TARGETDIR ] || mkdir $TARGETDIR

# populate the workspace
ros2 run micro_ros_setup create_ws.sh $TARGETDIR client_ros2_packages.txt client_uros_packages.repos

# add appropriate colcon.meta
cp $(ros2 pkg prefix micro_ros_setup)/config/client-colcon.meta $TARGETDIR/colcon.meta
