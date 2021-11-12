#!/bin/bash
colcon build --packages-up-to rosidl_typesupport_microxrcedds_c --metas src $@
colcon build --packages-up-to rosidl_typesupport_microxrcedds_cpp --metas src $@

set +o nounset
. install/local_setup.bash
set -o nounset

colcon build --metas src $@
