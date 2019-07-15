#! /bin/bash -xe

FW_TARGETDIR=firmware
PREFIX=$(ros2 pkg prefix micro_ros_setup)

SKIP="microxrcedds_client microcdr rosidl_typesupport_connext_cpp rosidl_typesupport_connext_c rosidl_typesupport_opensplice_cpp rosidl_typesupport_opensplice_c rmw_connext_cpp rmw_opensplice_cpp"

[ -d $FW_TARGETDIR ] || mkdir $FW_TARGETDIR
pushd $FW_TARGETDIR

    vcs import --input $PREFIX/config/uros_packages.repos

    # install uclibc
    pushd uclibc
    ./install.sh ../NuttX
    popd

    mkdir dev_ws
    ros2 run micro_ros_setup create_dev_ws.sh dev_ws
    rosdep install -y --from-paths dev_ws -i dev_ws --rosdistro crystal --skip-keys="$SKIP"

    mkdir mcu_ws
    ros2 run micro_ros_setup create_client_ws.sh mcu_ws
    touch mcu_ws/ros2/rcl_logging/rcl_logging_log4cxx -type d)/COLCON_IGNORE
    # in the event there are buildtools required, we also run rosdep on the client_ws
    rosdep install -y --from-paths mcu_ws -i mcu_ws --rosdistro crystal --skip-keys="$SKIP"
    # turn off features which don't compile on NuttX currently
    echo -e ",s/PROFILE_DISCOVERY=TRUE/PROFILE_DISCOVERY=FALSE/\n,s/PROFILE_TCP_TRANSPORT=TRUE/PROFILE_TCP_TRANSPORT=FALSE/g\nw" | ed $(find mcu_ws -name client.config)
popd

