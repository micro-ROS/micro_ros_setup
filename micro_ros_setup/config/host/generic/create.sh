sudo apt install -y liblog4cxx-dev clang 

SKIP="microxrcedds_client microcdr rosidl_typesupport_connext_cpp rosidl_typesupport_connext_c rosidl_typesupport_opensplice_cpp rosidl_typesupport_opensplice_c rmw_connext_cpp rmw_opensplice_cpp"

rosdep update

# populate the workspace
ros2 run micro_ros_setup create_ws.sh src $PREFIX/config/client_ros2_packages.txt $PREFIX/config/$RTOS/$PLATFORM/client_host_packages.repos

# add appropriate colcon.meta
cp $PREFIX/config/$RTOS/$PLATFORM/client-host-colcon.meta src/colcon.meta

rosdep install -y --from-paths src -i src --skip-keys="$SKIP"
