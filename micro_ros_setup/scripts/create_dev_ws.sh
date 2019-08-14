#! /bin/bash

set -e
set -o nounset

# populate the workspace
ros2 run micro_ros_setup create_ws.sh $1 dev_ros2_packages.txt dev_uros_packages.repos

