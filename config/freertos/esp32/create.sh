pushd $FW_TARGETDIR >/dev/null
    # Install toolchain
    mkdir toolchain

    pushd toolchain >/dev/null
        git clone -b v4.1 --recursive https://github.com/espressif/esp-idf.git
	      pushd esp-idf/components
	        #add the esp32-camera repository to the components directory
	        git clone https://github.com/espressif/esp32-camera.git
	      popd

        mkdir espressif
        export IDF_TOOLS_PATH=$(pwd)/espressif
        export IDF_PATH=$(pwd)/esp-idf
        alias python=python3

        echo "Installing ESP-IDF tools"
        python3 esp-idf/tools/idf_tools.py install
        
        echo "Installing ESP-IDF virtualenv"
        python3 esp-idf/tools/idf_tools.py install-python-env

        eval $(python3 $FW_TARGETDIR/toolchain/esp-idf/tools/idf_tools.py export --prefer-system)

        . $IDF_PATH/export.sh

        pip3 install catkin_pkg lark-parser empy

    popd >/dev/null

    # Import repos
    vcs import --input $PREFIX/config/$RTOS/$PLATFORM/board.repos >/dev/null

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
