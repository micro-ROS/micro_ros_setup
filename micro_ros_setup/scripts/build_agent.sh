#! /bin/bash

set -e
set -o nounset
set -o pipefail

echo "Building micro-ROS Agent"

colcon build --cmake-args \
    "-DUAGENT_BUILD_EXECUTABLE=OFF" \
    "--no-warn-unused-cli"
