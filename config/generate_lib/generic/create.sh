pushd $FW_TARGETDIR >/dev/null

    # ignore broken packages
    touch mcu_ws/ros2/rcl_logging/rcl_logging_spdlog/COLCON_IGNORE
    touch mcu_ws/ros2/rcl/COLCON_IGNORE
    touch mcu_ws/ros2/rosidl/rosidl_typesupport_introspection_cpp/COLCON_IGNORE
    touch mcu_ws/ros2/rcpputils/COLCON_IGNORE
    touch mcu_ws/uros/rcl/rcl_yaml_param_parser/COLCON_IGNORE
    touch mcu_ws/uros/rclc/rclc_examples/COLCON_IGNORE

popd >/dev/null
