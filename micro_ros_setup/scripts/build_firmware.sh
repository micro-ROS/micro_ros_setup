#! /bin/bash
#
# Sets up the environment properly and then builds NuttX with micro-ROS
#
# Syntax: $0 <NuttX-directory> <dev ws location>
#

NUTTX_DIR=firmware/NuttX
DEV_WS_DIR=firmware/dev_ws

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

function clean {
    echo $(echo $(echo $1 | sed 's/:/\n/g' | grep -v /opt/ros) | sed 's/ /:/g' )
}

export LD_LIBRARY_PATH=$(clean $LD_LIBRARY_PATH)
export AMENT_PREFIX_PATH=$(clean $AMENT_PREFIX_PATH)
export CMAKE_PREFIX_PATH=$(clean $CMAKE_PREFIX_PATH)
export COLCON_PREFIX_PATH=$(clean $COLCON_PREFIX_PATH)
export PYTHONPATH=$(clean $PYTHONPATH)
export PATH=$(clean $PATH)

# build and source dev workspace
pushd $DEV_WS_DIR
colcon build
. install/local_setup.sh
popd

pushd $NUTTX_DIR
make
RET=$?
popd 

exit $RET