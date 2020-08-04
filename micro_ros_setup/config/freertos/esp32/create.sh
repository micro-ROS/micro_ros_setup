pushd $FW_TARGETDIR >/dev/null
    # Install toolchain
    mkdir toolchain

    pushd toolchain >/dev/null
        git clone -b v4.0.1 --recursive https://github.com/espressif/esp-idf.git
        mkdir espressif
        export IDF_TOOLS_PATH=$(pwd)/espressif
        pushd esp-idf >/dev/null
            ./install.sh
        popd >/dev/null
    popd >/dev/null

    # Import repos
    vcs import --input $PREFIX/config/$RTOS/$PLATFORM/board.repos >/dev/null

    # ignore broken packages
    touch mcu_ws/ros2/rcl_logging/rcl_logging_log4cxx/COLCON_IGNORE
    touch mcu_ws/ros2/rcl/COLCON_IGNORE

    rosdep install -y --from-paths mcu_ws -i mcu_ws --rosdistro dashing --skip-keys="$SKIP"
popd >/dev/null
