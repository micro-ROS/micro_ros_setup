# this script cleans the environment
# do not run it, source it!

set -e
set -o nounset
set -o pipefail

PREFIXES_TO_CLEAN=$AMENT_PREFIX_PATH
FW_TARGETDIR=$(pwd)/firmware
PREFIX=$(ros2 pkg prefix micro_ros_setup)
# Cleaning paths
function clean {
    echo $(echo $(echo $1 | sed 's/:/\n/g' | \
      grep -v -E "($(echo $PREFIXES_TO_CLEAN | sed 's/:/\|/g'))" ) | sed 's/ /:/g' )
}

if [ $RTOS == "host" ]; then
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