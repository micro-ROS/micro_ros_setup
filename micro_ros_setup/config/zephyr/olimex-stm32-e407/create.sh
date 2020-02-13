# To be removed later, please use package.xml
sudo apt update
sudo apt install --no-install-recommends git cmake ninja-build gperf ccache dfu-util device-tree-compiler wget python3-pip python3-setuptools python3-tk python3-wheel xz-utils file make gcc gcc-multilib software-properties-common -y

wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | sudo apt-key add -
sudo apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main'
sudo apt update
sudo apt install cmake

pip3 install west

pushd $FW_TARGETDIR >/dev/null
   
    west init zephyrproject
    pushd zephyrproject >/dev/null
        west update
    popd >/dev/null

    pip3 install -r zephyrproject/zephyr/scripts/requirements.txt

    wget https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.11.1/zephyr-sdk-0.11.1-setup.run
    chmod +x zephyr-sdk-0.11.1-setup.run
    ./zephyr-sdk-0.11.1-setup.run -- -d $(pwd)/zephyr-sdk-0.11.1 -y

    # Temporal until driver in mainstream
    pushd zephyrproject/zephyr >/dev/null
        git remote add eprosima https://github.com/eProsima/zephyr
        git fetch --all
        git checkout remotes/eprosima/feature/vl53l1
    popd >/dev/null

    export ZEPHYR_TOOLCHAIN_VARIANT=zephyr
    export ZEPHYR_SDK_INSTALL_DIR=$FW_TARGETDIR/zephyr-sdk-0.11.1

    rm -rf zephyr-sdk-0.11.1-setup.run

    # Import repos
    vcs import --input $PREFIX/config/$RTOS/$PLATFORM/olimex_e407.repos >/dev/null

    # ignore broken packages
    touch mcu_ws/ros2/rcl_logging/rcl_logging_log4cxx/COLCON_IGNORE
    touch mcu_ws/ros2/rcl/COLCON_IGNORE

    # Remove this when https://github.com/ros2/rmw_implementation/pull/81 merged
    touch mcu_ws/ros2/rmw_implementation/COLCON_IGNORE

    rosdep install -y --from-paths mcu_ws -i mcu_ws --rosdistro dashing --skip-keys="$SKIP"
popd >/dev/null