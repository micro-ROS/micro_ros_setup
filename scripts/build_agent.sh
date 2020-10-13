#! /bin/bash

set -e
set -o nounset
set -o pipefail

echo "Building micro-ROS Agent"

colcon build --packages-select micro_ros_agent microxrcedds_agent drive_base_msgs $@ --cmake-args \
    "-DUAGENT_BUILD_EXECUTABLE=OFF" \
    "-DUAGENT_P2P_PROFILE=OFF" \
    "--no-warn-unused-cli"
