pushd $FW_TARGETDIR >/dev/null
    # Install toolchain
    mkdir toolchain

    pushd toolchain >/dev/null
        git clone -b v4.1 --recursive https://github.com/espressif/esp-idf.git

        mkdir espressif
        export IDF_TOOLS_PATH=$(pwd)/espressif
        export IDF_PATH=$(pwd)/esp-idf
        alias python=python3

        echo "Installing ESP-IDF tools"
        python3 esp-idf/tools/idf_tools.py install

        echo "Installing ESP-IDF virtualenv"
        dpkg -s python3-pip > /dev/null
        if [[ $? -ne 0 ]]; then
            echo "Error: python3-pip package must be installed before continuing..."
            exit 1
        fi
        pip3 install virtualenv
        python3 esp-idf/tools/idf_tools.py install-python-env

        eval $(python3 $FW_TARGETDIR/toolchain/esp-idf/tools/idf_tools.py export --prefer-system)

        . $IDF_PATH/export.sh

        pip3 install catkin_pkg lark-parser colcon-common-extensions

    popd >/dev/null

    # Import repos
    vcs import --input $PREFIX/config/$RTOS/$PLATFORM/board.repos >/dev/null

    # ignore broken packages
    touch mcu_ws/ros2/rcl_logging/rcl_logging_spdlog/COLCON_IGNORE
    touch mcu_ws/ros2/rcl/COLCON_IGNORE
    touch mcu_ws/ros2/rosidl/rosidl_typesupport_introspection_cpp/COLCON_IGNORE
    touch mcu_ws/ros2/rcpputils/COLCON_IGNORE
    touch mcu_ws/uros/rcl/rcl_yaml_param_parser/COLCON_IGNORE
    touch mcu_ws/uros/rclc/rclc_examples/COLCON_IGNORE

popd >/dev/null
