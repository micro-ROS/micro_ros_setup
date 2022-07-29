#! /bin/bash

set -e
set -o nounset
set -o pipefail

PREFIX=$(ros2 pkg prefix micro_ros_setup)
TARGETDIR=src

if [ -z ${EXTERNAL_SKIP+x} ]; then
  EXTERNAL_SKIP=""
fi

SKIP="rosidl_typesupport_opensplice_c rosidl_typesupport_opensplice_cpp rmw_opensplice_cpp rmw_connext_cpp rosidl_typesupport_connext_c rosidl_typesupport_connext_cpp microxrcedds_agent microxrcedds_client microcdr rmw_connextdds $EXTERNAL_SKIP"

if [ $# -gt 0 ]
then
  TARGETDIR=$1
fi

[ -d $TARGETDIR ] || mkdir $TARGETDIR

# populate the workspace
ros2 run micro_ros_setup create_ws.sh $TARGETDIR $PREFIX/config/agent_ros2_packages.txt $PREFIX/config/agent_uros_packages.repos

rosdep install --from-paths $TARGETDIR -i $TARGETDIR -y --skip-keys="$SKIP"
