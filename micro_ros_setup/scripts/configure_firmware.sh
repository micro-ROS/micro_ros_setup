#! /bin/bash

set -e
set -o nounset
set -o pipefail

PREFIXES_TO_CLEAN=$COLCON_PREFIX_PATH
FW_TARGETDIR=firmware
PREFIX=$(ros2 pkg prefix micro_ros_setup)

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


# Configure specific firmware folder if needed
if [ -f $PREFIX/config/$RTOS/$PLATFORM/configure.sh ]; then
  echo "Configuring firmware for $RTOS platform $PLATFORM"
  . $PREFIX/config/$RTOS/$PLATFORM/configure.sh
else
  echo "No configuration step needed for $RTOS platform $PLATFORM"
fi

