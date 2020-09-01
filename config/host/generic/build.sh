#!/bin/bash
colcon build --packages-up-to rosidl_typesupport_microxrcedds_c --metas src $@
colcon build --packages-up-to rosidl_typesupport_microxrcedds_cpp --metas src $@
colcon build --metas src $@
