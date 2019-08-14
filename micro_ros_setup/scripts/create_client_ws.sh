#! /bin/bash

set -e
set -o nounset

# populate the workspace
ros2 run micro_ros_setup create_ws.sh $1 client_ros2_packages.txt client_uros_packages.repos

# add appropriate colcon.meta
cp $(ros2 pkg prefix micro_ros_setup)/config/client-colcon.meta $1/colcon.meta
