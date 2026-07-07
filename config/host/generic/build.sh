#!/bin/bash
colcon build --packages-up-to rosidl_typesupport_microxrcedds_c --metas src --cmake-args -DBUILD_TESTING=OFF -DBUILD_SHARED_LIBS=ON $@
colcon build --packages-up-to rosidl_typesupport_microxrcedds_cpp --metas src --cmake-args -DBUILD_TESTING=OFF -DBUILD_SHARED_LIBS=ON $@

set +o nounset
. install/local_setup.bash
set -o nounset

# Pre-build foundational message packages with the workspace microxrcedds type supports
# already in the path.  These packages are implicit dependencies of many interface
# packages (added by rosidl's action/service expansion), but are NOT declared in those
# packages' package.xml files.  Without pre-building them in the workspace, cmake would
# find the system /opt/ros/jazzy versions (which have no microxrcedds type support) and
# the generated libraries would fail to link.
#
# Build order matters:
#   builtin_interfaces      - no workspace deps
#   unique_identifier_msgs  - no workspace deps (UUID.msg only)
#   service_msgs            - depends on builtin_interfaces (ServiceEventInfo.msg)
#   action_msgs             - depends on all three above; has CancelGoal.srv
colcon build --packages-select builtin_interfaces unique_identifier_msgs service_msgs action_msgs --metas src --cmake-args -DBUILD_TESTING=OFF -DBUILD_SHARED_LIBS=ON $@

# Re-source so the pre-built packages appear in CMAKE_PREFIX_PATH *before* the system
# /opt/ros/jazzy path.  This ensures cmake prefers workspace versions (with microxrcedds
# type support) when configuring packages in the full workspace build below.
set +o nounset
. install/local_setup.bash
set -o nounset

colcon build --metas src --cmake-args -DBUILD_TESTING=OFF -DBUILD_SHARED_LIBS=ON $@
