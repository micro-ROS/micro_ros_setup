#! /bin/bash

set -e
set -o nounset
set -o pipefail


[ -d $FW_TARGETDIR ] || mkdir $FW_TARGETDIR
pushd $FW_TARGETDIR >/dev/null

    vcs import --input $PREFIX/config/$RTOS/$PLATFORM/uros_packages.repos --recursive

    # copy uros apps from nuttx_apps to spresense/sdk/apps
    cp -a apps/uros spresense/sdk/apps
    sed -i 's#default "../mcu_ws/"#default "../../../mcu_ws/"#' spresense/sdk/apps/uros/Kconfig
    sed -i "/\${NUTTX_TOPDIR}\/include\/uClibc++/a \${NUTTX_TOPDIR}\/..\/sdk\/include" spresense/sdk/apps/uros/arm_toolchain.cmake.in
    sed -i "/\${NUTTX_APPDIR}\/configs\/olimex-stm32-e407\/src/d" spresense/sdk/apps/uros/arm_toolchain.cmake.in
    sed -i '2 a \        "rcutils": {' spresense/sdk/apps/uros/rmw_config.meta.in
    sed -i '3 a \            "cmake-args": [' spresense/sdk/apps/uros/rmw_config.meta.in
    sed -i '4 a \                "-DRCUTILS_NO_64_ATOMIC=ON"' spresense/sdk/apps/uros/rmw_config.meta.in
    sed -i '5 a \            ]' spresense/sdk/apps/uros/rmw_config.meta.in
    sed -i '6 a \        },' spresense/sdk/apps/uros/rmw_config.meta.in

    # install uclibc
    if [ ! -d "spresense/nuttx/libs/libxx/uClibc++" ]
    then
      pushd uclibc >/dev/null
      ./install.sh ../spresense/nuttx
      popd >/dev/null
    fi

    # ignore broken packages
    touch mcu_ws/ros2/rcl_logging/rcl_logging_log4cxx/COLCON_IGNORE
    touch mcu_ws/ros2/rcl_logging/rcl_logging_spdlog/COLCON_IGNORE
    touch mcu_ws/ros2/rcl/rcl_action/COLCON_IGNORE

    touch mcu_ws/ros2/rcl/COLCON_IGNORE
    touch mcu_ws/ros2/rosidl/rosidl_typesupport_introspection_c/COLCON_IGNORE
    touch mcu_ws/ros2/rosidl/rosidl_typesupport_introspection_cpp/COLCON_IGNORE
    touch mcu_ws/ros2/rcpputils/COLCON_IGNORE
    touch mcu_ws/uros/rcl/rcl_yaml_param_parser/COLCON_IGNORE
    touch mcu_ws/uros/rclc/rclc_examples/COLCON_IGNORE

    rosdep install -y --from-paths mcu_ws -i mcu_ws --rosdistro foxy --skip-keys="$SKIP"

popd >/dev/null

cp $PREFIX/config/$RTOS/generic/package.xml $FW_TARGETDIR/apps/package.xml
rosdep install -y --from-paths $FW_TARGETDIR/apps -i $FW_TARGETDIR/apps --rosdistro foxy
