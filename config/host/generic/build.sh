#!/bin/bash
<<<<<<< HEAD
colcon build --packages-up-to rosidl_typesupport_microxrcedds_c --metas src $@
colcon build --packages-up-to rosidl_typesupport_microxrcedds_cpp --metas src $@
=======
colcon build --packages-up-to rosidl_typesupport_microxrcedds_c --metas src --cmake-args -DBUILD_TESTING=OFF -DBUILD_SHARED_LIBS=ON $@
colcon build --packages-up-to rosidl_typesupport_microxrcedds_cpp --metas src --cmake-args -DBUILD_TESTING=OFF -DBUILD_SHARED_LIBS=ON $@
>>>>>>> 3136ad0 (build dynamic lib of rosidl_typesupport of (#473))

set +o nounset
. install/local_setup.bash
set -o nounset

<<<<<<< HEAD
colcon build --metas src $@
=======
colcon build --metas src --cmake-args -DBUILD_TESTING=OFF -DBUILD_SHARED_LIBS=ON $@
>>>>>>> 3136ad0 (build dynamic lib of rosidl_typesupport of (#473))
