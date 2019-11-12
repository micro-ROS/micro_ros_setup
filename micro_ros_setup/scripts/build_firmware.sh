#! /bin/bash
#
# Sets up the environment properly and then builds NuttX with micro-ROS
#
# Syntax: $0 <NuttX-directory> <dev ws location>
#

set -e
set -o nounset
set -o pipefail

NUTTX_DIR=firmware/NuttX
DEV_WS_DIR=firmware/dev_ws
MRS_MAKE=make

UROS_FAST_BUILD=off
if [ $# -gt 0 ]
then
	if [ "$1" = "-f" ]
	then
    echo "Fast-Build active,ROS workspace will not be re-built!"
		export UROS_FAST_BUILD=y
		shift
	fi
fi
export UROS_FAST_BUILD

if [ $# -eq 1 ]
then
  if [ -d $1/NuttX ]
  then
    NUTTX_DIR=$1/NuttX
    DEV_WS_DIR=$1/dev_ws
  else
    NUTTX_DIR=$1
  fi
fi
if [ $# -eq 2 ]
then
  NUTTX_DIR=$1
  DEV_WS_DIR=$2
fi

PREFIXES_TO_CLEAN=$AMENT_PREFIX_PATH

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

# build and source dev workspace
if [ "$UROS_FAST_BUILD" = "off" ]
then
	pushd $DEV_WS_DIR >/dev/null
	colcon build
	set +o nounset
	. install/setup.bash
	popd > /dev/null
fi

pushd $NUTTX_DIR >/dev/null
$MRS_MAKE
RET=$?
popd >/dev/null

exit $RET
