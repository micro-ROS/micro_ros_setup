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
export ZEPHYR_VERSION="0.16.3"
export ARCH=$(uname -m)

pushd $FW_TARGETDIR >/dev/null

    west init zephyrproject
    pushd zephyrproject >/dev/null
        cd zephyr
          git checkout v3.6.0
        cd ..
        west update
	west blobs fetch hal_espressif
	west zephyr-export
    popd >/dev/null

    pip3 install -r zephyrproject/zephyr/scripts/requirements.txt --ignore-installed

    sdkfound=false
    if [ -e ~/.zephyrrc ]; then
	source ~/.zephyrrc
	if [ -d $ZEPHYR_SDK_INSTALL_DIR ]; then
	    ln -s $ZEPHYR_SDK_INSTALL_DIR zephyr-sdk
	    sdkfound=true
	fi
    fi
    echo PLATFORM: $PLATFORM
    if [ "$sdkfound" = false ]; then
	export TOOLCHAIN_VERSION=zephyr-sdk-${ZEPHYR_VERSION}_linux-${ARCH}.tar.xz

	wget https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v$ZEPHYR_VERSION/$TOOLCHAIN_VERSION
	chmod +x $TOOLCHAIN_VERSION
	tar -xvf ./$TOOLCHAIN_VERSION
	mv zephyr-sdk-${ZEPHYR_VERSION} zephyr-sdk

	rm -rf $TOOLCHAIN_VERSION

    fi
    pushd zephyr-sdk
    ./setup.sh -t all -c -h
    popd
    echo FW_TARGET_DIR: ${FW_TARGET_DIR}
    export ZEPHYR_TOOLCHAIN_VARIANT=zephyr
    export ZEPHYR_SDK_INSTALL_DIR=$FW_TARGETDIR/zephyr-sdk

    # Import repos
    vcs import --input $PREFIX/config/$RTOS/generic/board.repos

    # ignore broken packages
    touch mcu_ws/ros2/rcl_logging/rcl_logging_spdlog/COLCON_IGNORE
    touch mcu_ws/ros2/rcl/COLCON_IGNORE
    touch mcu_ws/ros2/rosidl/rosidl_typesupport_introspection_cpp/COLCON_IGNORE
    touch mcu_ws/ros2/rcpputils/COLCON_IGNORE
    touch mcu_ws/ros2/ros2_tracing/test_tracetools/COLCON_IGNORE
    touch mcu_ws/uros/rcl/rcl_yaml_param_parser/COLCON_IGNORE
    touch mcu_ws/uros/rclc/rclc_examples/COLCON_IGNORE

    # Upgrade sphinx
    #pip install --force-reinstall Sphinx==4.2.0

popd >/dev/null
