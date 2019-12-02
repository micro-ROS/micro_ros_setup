#! /bin/bash

set -e
set -o nounset
set -o pipefail

PREFIXES_TO_CLEAN=$AMENT_PREFIX_PATH
FW_TARGETDIR=firmware
PREFIX=$(ros2 pkg prefix micro_ros_setup)

UROS_FAST_BUILD=off
if [ $# -gt 0 ]
then
	if [ "$1" = "-f" ]
	then
    echo "Fast-Build active, ROS workspace will not be re-built!"
		export UROS_FAST_BUILD=y
		shift
	fi
fi
export UROS_FAST_BUILD

# Checking if firmware exists
if [ -d $FW_TARGETDIR ]; then
    RTOS=$(head -n1 $FW_TARGETDIR/PLATFORM)
    PLATFORM=$(tail -n1 $FW_TARGETDIR/PLATFORM)
else
    echo "Firmware folder not found. Please use ros2 run micro_ros_setup create_firmware_ws.sh to create a new project."
    exit 1
fi

# Cleaning paths
function clean {
    echo $(echo $(echo $1 | sed 's/:/\n/g' | \
      grep -v -E "($(echo $PREFIXES_TO_CLEAN | sed 's/:/\|/g'))" ) | sed 's/ /:/g' )
}

if [ RTOS == "host" ]; then
  echo "Compiling for host environment: not cleaning path"
else
  echo "Crosscompiled environment: cleaning path"
  if [ ! -z ${LD_LIBRARY_PATH+x} ]
  then
    MRS_TEMP_VAR=$(clean $LD_LIBRARY_PATH)
    if [ ! -z "$MRS_TEMP_VAR" ]  
    then
      export LD_LIBRARY_PATH=$MRS_TEMP_VAR
    else
      unset LD_LIBRARY_PATH
    fi
    unset MRS_TEMP_VAR
  fi
  if [ ! -z ${CMAKE_PREFIX_PATH+x} ]
  then
    MRS_TEMP_VAR=$(clean $CMAKE_PREFIX_PATH)
    if [ ! -z "$MRS_TEMP_VAR" ]  
    then
      export CMAKE_PREFIX_PATH=$MRS_TEMP_VAR
    else
      unset CMAKE_PREFIX_PATH
    fi
    unset MRS_TEMP_VAR
  fi
  if [ ! -z ${PYTHONPATH+x} ]
  then
    MRS_TEMP_VAR=$(clean $PYTHONPATH)
    if [ ! -z "$MRS_TEMP_VAR" ]  
    then
      export PYTHONPATH=$MRS_TEMP_VAR
    else
      unset PYTHONPATH
    fi
    unset MRS_TEMP_VAR
  fi
  export PATH=$(clean $PATH)
  unset AMENT_PREFIX_PATH
  unset COLCON_PREFIX_PATH
fi

# Building specific firmware folder
echo "Building firmware for $RTOS platform $PLATFORM"
. $PREFIX/config/$RTOS/$PLATFORM/build.sh
