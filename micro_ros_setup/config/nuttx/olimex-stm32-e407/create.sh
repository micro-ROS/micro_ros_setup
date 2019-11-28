
apt install -y ed flex bison libncurses5-dev gcc-arm-none-eabi clang clang-tidy usbutils

SKIP="microxrcedds_client microcdr rosidl_typesupport_connext_cpp rosidl_typesupport_connext_c rosidl_typesupport_opensplice_cpp rosidl_typesupport_opensplice_c rmw_connext_cpp rmw_opensplice_cpp"

[ -d $FW_TARGETDIR ] || mkdir $FW_TARGETDIR
pushd $FW_TARGETDIR >/dev/null
    touch COLCON_IGNORE

    vcs import --input $PREFIX/config/$RTOS/$PLATFORM/uros_packages.repos >/dev/null

    # install uclibc
    if [ ! -d "NuttX/libs/libxx/uClibc++" ]
    then
      pushd uclibc >/dev/null
      ./install.sh ../NuttX
      popd >/dev/null
    fi

    # Creating dev directory
    [ -d dev_ws ] || mkdir dev_ws
    ros2 run micro_ros_setup create_ws.sh dev_ws $PREFIX/config/dev_ros2_packages.txt  $PREFIX/config/dev_uros_packages.repos
    rosdep install -y --from-paths dev_ws -i dev_ws --rosdistro dashing --skip-keys="$SKIP"

    # Creating mcu directory
    [ -d mcu_ws ] || mkdir mcu_ws
    ros2 run micro_ros_setup create_ws.sh mcu_ws $PREFIX/config/client_ros2_packages.txt $PREFIX/config/$RTOS/$PLATFORM/client_uros_packages.repos
    cp $PREFIX/config/$RTOS/$PLATFORM/client-colcon.meta mcu_ws/colcon.meta

    # ignore broken packages
    touch mcu_ws/ros2/rcl_logging/rcl_logging_log4cxx/COLCON_IGNORE
    touch mcu_ws/ros2/rcl/rcl_action/COLCON_IGNORE

    # in the event there are buildtools required, we also run rosdep on the client_ws
    rosdep install -y --from-paths mcu_ws -i mcu_ws --rosdistro dashing --skip-keys="$SKIP"

    # turn off features which don't compile on NuttX currently
    echo -e ",s/PROFILE_DISCOVERY=TRUE/PROFILE_DISCOVERY=FALSE/\n,s/PROFILE_TCP_TRANSPORT=TRUE/PROFILE_TCP_TRANSPORT=FALSE/g\nw" | ed $(find mcu_ws -name client.config) >/dev/null

popd >/dev/null