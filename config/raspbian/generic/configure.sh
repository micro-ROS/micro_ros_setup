#! /bin/bash

pushd $FW_TARGETDIR >/dev/null
    rm -rf mcu_ws/*
    cp raspbian_apps/toolchain.cmake mcu_ws/
    # ROS_DISTRO SPECIFIC
    curl -s https://raw.githubusercontent.com/ros2/ros2/lyrical/ros2.repos |\
        ros2 run micro_ros_setup yaml_filter.py raspbian_apps/$CONFIG_NAME/ros2_repos.filter > ros2.repos
    vcs import --input ros2.repos mcu_ws/ && rm ros2.repos

    # TEMPORARY: pin ros2/rosidl to the last commit before ros2/rosidl#942, which made
    # rosidl_runtime_c (C) depend on rosidl_buffer (C++, throws std::runtime_error)
    if [ -d mcu_ws/ros2/rosidl ]; then
        git -C mcu_ws/ros2/rosidl reset --hard 5f4ace0288ecf942307ed62b9239ab5986884676
    fi

    if [ -d mcu_ws/ros2/rosidl ]; then
        touch mcu_ws/ros2/rosidl/rosidl_typesupport_introspection_c/COLCON_IGNORE
        touch mcu_ws/ros2/rosidl/rosidl_typesupport_introspection_cpp/COLCON_IGNORE
        # TEMPORARY: rosidl_buffer_py does not exist at the pinned ros2/rosidl commit
        # touch mcu_ws/ros2/rosidl/rosidl_buffer_py/COLCON_IGNORE
        # TEMPORARY: nothing requires these at the pinned ros2/rosidl commit, and they are
        # C++ with exceptions, so they cannot build here
        touch mcu_ws/ros2/rosidl/rosidl_buffer/COLCON_IGNORE
        touch mcu_ws/ros2/rosidl/rosidl_buffer_backend/COLCON_IGNORE
        touch mcu_ws/ros2/rosidl/rosidl_buffer_backend_registry/COLCON_IGNORE
    fi

    if [ -d mcu_ws/ros2/rcl_logging ]; then
        touch mcu_ws/ros2/rcl_logging/rcl_logging_spdlog/COLCON_IGNORE
    fi

    vcs import --input raspbian_apps/$CONFIG_NAME/app.repos mcu_ws/
    if [ -d raspbian_apps/$CONFIG_NAME/app ]; then
        cp -r raspbian_apps/$CONFIG_NAME/app mcu_ws/
    fi
    cp raspbian_apps/$CONFIG_NAME/colcon.meta mcu_ws/
    cp raspbian_apps/$CONFIG_NAME/app_info.sh mcu_ws/
    if [ -d bin ]; then
        rm -rf bin/*
    else
        mkdir -p bin
    fi
    if [ -d raspbian_apps/$CONFIG_NAME/bin ]; then
        cp -r raspbian_apps/$CONFIG_NAME/bin mcu_ws/
    fi
popd >/dev/null
