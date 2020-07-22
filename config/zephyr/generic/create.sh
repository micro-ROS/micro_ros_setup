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

pushd $FW_TARGETDIR >/dev/null
   
    west init zephyrproject
    pushd zephyrproject >/dev/null
        west update
    popd >/dev/null

    pip3 install -r zephyrproject/zephyr/scripts/requirements.txt

    if [ "$PLATFORM" = "host" ]; then
        export TOOLCHAIN_VERSION=zephyr-sdk-0.11.2-setup.run
    else
        export TOOLCHAIN_VERSION=zephyr-toolchain-arm-0.11.2-setup.run
    fi
    
    wget https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.11.2/$TOOLCHAIN_VERSION
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

    rosdep install -y --from-paths mcu_ws -i mcu_ws --rosdistro foxy --skip-keys="$SKIP"
popd >/dev/null
