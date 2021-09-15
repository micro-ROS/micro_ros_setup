pushd $FW_TARGETDIR >/dev/null
    # Install toolchain
    mkdir toolchain


    # Install toolchain
    echo "Downloading ARM compiler, this may take a while"
    curl -fsSLO https://developer.arm.com/-/media/Files/downloads/gnu-rm/8-2019q3/RC1.1/gcc-arm-none-eabi-8-2019-q3-update-linux.tar.bz2
    tar --strip-components=1 -xvjf gcc-arm-none-eabi-8-2019-q3-update-linux.tar.bz2 -C toolchain  > /dev/null
    rm gcc-arm-none-eabi-8-2019-q3-update-linux.tar.bz2

    # Import repos
    vcs import --input $PREFIX/config/$RTOS/$PLATFORM/board.repos

    # ignore broken packages
    touch mcu_ws/ros2/rcl_logging/rcl_logging_spdlog/COLCON_IGNORE
    touch mcu_ws/ros2/rcl/COLCON_IGNORE
    touch mcu_ws/ros2/rosidl/rosidl_typesupport_introspection_cpp/COLCON_IGNORE
    touch mcu_ws/ros2/rcpputils/COLCON_IGNORE
    touch mcu_ws/uros/rcl/rcl_yaml_param_parser/COLCON_IGNORE
    touch mcu_ws/uros/rclc/rclc_examples/COLCON_IGNORE

popd >/dev/null
