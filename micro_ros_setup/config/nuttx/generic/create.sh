#! /bin/bash

set -e
set -o nounset
set -o pipefail


[ -d $FW_TARGETDIR ] || mkdir $FW_TARGETDIR
pushd $FW_TARGETDIR >/dev/null

    vcs import --input $PREFIX/config/$RTOS/generic/uros_packages.repos >/dev/null

    # install uclibc
    if [ ! -d "NuttX/libs/libxx/uClibc++" ]
    then
      pushd uclibc >/dev/null
      ./install.sh ../NuttX
      popd >/dev/null
    fi

    # ignore broken packages
    touch mcu_ws/ros2/rcl_logging/rcl_logging_log4cxx/COLCON_IGNORE
    touch mcu_ws/ros2/rcl/rcl_action/COLCON_IGNORE

    rosdep install -y --from-paths mcu_ws -i mcu_ws --rosdistro dashing --skip-keys="$SKIP"

    # turn off features which don't compile on NuttX currently
    echo -e ",s/PROFILE_DISCOVERY=TRUE/PROFILE_DISCOVERY=FALSE/\n,s/PROFILE_TCP_TRANSPORT=TRUE/PROFILE_TCP_TRANSPORT=FALSE/g\nw" | ed $(find mcu_ws -name client.config) >/dev/null

popd >/dev/null

cp $PREFIX/config/$RTOS/generic/package.xml $FW_TARGETDIR/apps/package.xml
rosdep install -y --from-paths $FW_TARGETDIR/apps -i $FW_TARGETDIR/apps --rosdistro dashing
