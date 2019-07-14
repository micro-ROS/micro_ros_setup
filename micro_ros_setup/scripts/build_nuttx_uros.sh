#! /bin/bash
#
# Sets up the environment properly and then builds NuttX with micro-ROS
#
# Syntax: $0 <NuttX-directory> <dev ws location>
#

if [ $# -lt 2 ]
then
    echo "Syntax: $0 <Nuttx-dir> <dev-ws>"
    exit 255
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
pushd $2
colcon build
source install/local_setup.bash
popd

pushd $1
make
popd 