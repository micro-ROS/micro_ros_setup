# populate the workspace
ros2 run micro_ros_setup create_ws.sh src $PREFIX/config/client_ros2_packages.txt $PREFIX/config/$RTOS/$PLATFORM/client_host_packages.repos

# add appropriate colcon.meta
cp $PREFIX/config/$RTOS/$PLATFORM/client-host-colcon.meta src/colcon.meta

rosdep install -y --from-paths src -i src --skip-keys="$SKIP"

touch mcu_ws/uros/rclc/rclc_examples/COLCON_IGNORE