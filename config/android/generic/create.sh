pushd $FW_TARGETDIR >/dev/null

    # ignore broken packages
    touch mcu_ws/ros2/rcl_logging/rcl_logging_log4cxx/COLCON_IGNORE
    touch mcu_ws/ros2/rcl_logging/rcl_logging_spdlog/COLCON_IGNORE
    touch mcu_ws/ros2/rcl_logging/rcl_logging_implementation/COLCON_IGNORE
    touch mcu_ws/ros2/rcl/COLCON_IGNORE
    touch mcu_ws/ros2_tracing/test_tracetools/COLCON_IGNORE
    touch mcu_ws/ros2/rosidl/rosidl_typesupport_introspection_cpp/COLCON_IGNORE
    touch mcu_ws/uros/rcl/rcl_yaml_param_parser/COLCON_IGNORE
    touch mcu_ws/uros/rclc/rclc_examples/COLCON_IGNORE
    touch mcu_ws/ros2/ros2_tracing/lttngpy/COLCON_IGNORE
    # TEMPORARY: rosidl_buffer_py does not exist at the pinned ros2/rosidl commit
    # touch mcu_ws/ros2/rosidl/rosidl_buffer_py/COLCON_IGNORE
    # TEMPORARY: nothing requires these at the pinned ros2/rosidl commit, and they are
    # C++ with exceptions, so they cannot build here
    touch mcu_ws/ros2/rosidl/rosidl_buffer/COLCON_IGNORE
    touch mcu_ws/ros2/rosidl/rosidl_buffer_backend/COLCON_IGNORE
    touch mcu_ws/ros2/rosidl/rosidl_buffer_backend_registry/COLCON_IGNORE

popd >/dev/null
