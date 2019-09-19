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
ros2 run micro_ros_setup create_ws.sh $TARGETDIR agent_ros2_packages.txt agent_uros_packages.repos

# add appropriate colcon.meta
cp $(ros2 pkg prefix micro_ros_setup)/config/agent-colcon.meta $TARGETDIR/colcon.meta

rosdep install --from-paths $TARGETDIR -i $TARGETDIR -y \
  --skip-keys="rosidl_typesupport_opensplice_c rosidl_typesupport_opensplice_cpp rmw_opensplice_cpp rmw_connext_cpp rosidl_typesupport_connext_c rosidl_typesupport_connext_cpp"
