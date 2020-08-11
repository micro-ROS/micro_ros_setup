pushd $FW_TARGETDIR >/dev/null
    # Install toolchain
    mkdir toolchain

    pushd toolchain >/dev/null
        git clone -b v4.0.1 --recursive https://github.com/espressif/esp-idf.git
	pushd esp-idf/components
	#add the esp32-camera reposirtoy to the components dircetory
	git clone https://github.com/espressif/esp32-camera.git
	popd
        mkdir espressif
        export IDF_TOOLS_PATH=$(pwd)/espressif

        echo "Installing ESP-IDF tools"
        python3 esp-idf/tools/idf_tools.py install

        python3 -m venv --system-site-packages python_env
        export VIRTUAL_ENV=$(pwd)/python_env
        export PATH="$VIRTUAL_ENV/bin:$PATH"

        pip install -r esp-idf/requirements.txt
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
