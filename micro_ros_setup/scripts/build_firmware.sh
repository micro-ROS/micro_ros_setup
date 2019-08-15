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

PREFIXES_TO_CLEAN=$COLCON_PREFIX_PATH

function clean {
    echo $(echo $(echo $1 | sed 's/:/\n/g' | \
      grep -v -E "($(echo $PREFIXES_TO_CLEAN | sed 's/:/\|/g'))" ) | sed 's/ /:/g' )
}

export LD_LIBRARY_PATH=$(clean $LD_LIBRARY_PATH)
export CMAKE_PREFIX_PATH=$(clean $CMAKE_PREFIX_PATH)
export PYTHONPATH=$(clean $PYTHONPATH)
export PATH=$(clean $PATH)

unset AMENT_PREFIX_PATH
unset COLCON_PREFIX_PATH

# build and source dev workspace
pushd $DEV_WS_DIR >/dev/null
colcon build
set +o nounset
. install/setup.bash
popd > /dev/null

pushd $NUTTX_DIR >/dev/null
make
RET=$?
popd >/dev/null

exit $RET