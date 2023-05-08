# Reminder: Zephyr recommended dependecies are: git cmake ninja-build gperf ccache dfu-util device-tree-compiler wget python3-pip python3-setuptools python3-tk python3-wheel xz-utils file make gcc gcc-multilib software-properties-common -y

CMAKE_VERSION_NUMBER=$(cmake --version | grep "[0-9]*\.[0-9]*\.[0-9]*" | cut -d ' ' -f 3)
CMAKE_VERSION_MAJOR_NUMBER=$(echo $CMAKE_VERSION_NUMBER | cut -d '.' -f 1)
CMAKE_VERSION_MINOR_NUMBER=$(echo $CMAKE_VERSION_NUMBER | cut -d '.' -f 2)
CMAKE_VERSION_PATCH_NUMBER=$(echo $CMAKE_VERSION_NUMBER | cut -d '.' -f 3)

if ! (( $CMAKE_VERSION_MAJOR_NUMBER > 3 || \
    $CMAKE_VERSION_MAJOR_NUMBER == 3 && $CMAKE_VERSION_MINOR_NUMBER > 13 || \
    $CMAKE_VERSION_MAJOR_NUMBER == 3 && $CMAKE_VERSION_MINOR_NUMBER == 13 && $CMAKE_VERSION_PATCH_NUMBER >= 1 )); then
    echo "Error: installed CMake version must be equal or greater than 3.13.1."
    echo "Your current version is $CMAKE_VERSION_NUMBER."
    echo "Please if not installed follow the instructions: https://docs.zephyrproject.org/latest/getting_started/index.html"
    exit 1
fi

export PATH=~/.local/bin:"$PATH"
export ZEPHYR_VERSION="v0.12.4"
export ARCH=$(uname -m)

pushd $FW_TARGETDIR >/dev/null

    west init zephyrproject
    pushd zephyrproject >/dev/null
        cd zephyr
          git checkout zephyr-v2.6.0
        cd ..
        west update
    popd >/dev/null

    pip3 install -r zephyrproject/zephyr/scripts/requirements.txt --ignore-installed

    if [ "$PLATFORM" = "host" ]; then
        if [ "$ARCH" = "aarch64" ]; then
            export TOOLCHAIN_VERSION=zephyr-sdk-0.13.1-linux-aarch64-setup.run
            export ZEPHYR_VERSION="v0.13.1"
        else
            export TOOLCHAIN_VERSION=zephyr-sdk-0.12.4-x86_64-linux-setup.run
        fi
    else
        if [ "$ARCH" = "aarch64" ]; then
            export TOOLCHAIN_VERSION=zephyr-toolchain-arm-0.13.1-linux-aarch64-setup.run
            export ZEPHYR_VERSION="v0.13.1"
        else
            export TOOLCHAIN_VERSION=zephyr-toolchain-arm-0.12.4-x86_64-linux-setup.run
        fi
    fi

    wget https://github.com/zephyrproject-rtos/sdk-ng/releases/download/$ZEPHYR_VERSION/$TOOLCHAIN_VERSION
    chmod +x $TOOLCHAIN_VERSION
    ./$TOOLCHAIN_VERSION -- -d $(pwd)/zephyr-sdk -y

    rm -rf $TOOLCHAIN_VERSION

    export ZEPHYR_TOOLCHAIN_VARIANT=zephyr
    export ZEPHYR_SDK_INSTALL_DIR=$FW_TARGETDIR/zephyr-sdk

    # Import repos
    vcs import --input $PREFIX/config/$RTOS/generic/board.repos

    # ignore broken packages
    touch mcu_ws/ros2/rcl_logging/rcl_logging_log4cxx/COLCON_IGNORE
    touch mcu_ws/ros2/rcl_logging/rcl_logging_spdlog/COLCON_IGNORE
    touch mcu_ws/ros2/rcl/COLCON_IGNORE
    touch mcu_ws/ros2/rosidl/rosidl_typesupport_introspection_c/COLCON_IGNORE
    touch mcu_ws/ros2/rosidl/rosidl_typesupport_introspection_cpp/COLCON_IGNORE
    touch mcu_ws/ros2/rcpputils/COLCON_IGNORE
    touch mcu_ws/uros/rcl/rcl_yaml_param_parser/COLCON_IGNORE
    touch mcu_ws/uros/rclc/rclc_examples/COLCON_IGNORE

    rosdep install -y --from-paths mcu_ws -i mcu_ws --rosdistro $ROS_DISTRO --skip-keys="$SKIP"

    # Upgrade sphinx
    pip install --force-reinstall Sphinx==4.2.0

popd >/dev/null
