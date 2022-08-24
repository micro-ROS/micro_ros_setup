#! /bin/bash

pushd $FW_TARGETDIR >/dev/null
    rm -rf mcu_ws/*
    cp raspbian_apps/toolchain.cmake mcu_ws/
    curl -s https://raw.githubusercontent.com/ros2/ros2/humble/ros2.repos |\
        ros2 run micro_ros_setup yaml_filter.py raspbian_apps/$CONFIG_NAME/ros2_repos.filter > ros2.repos
    vcs import --input ros2.repos mcu_ws/ && rm ros2.repos

    if [ -d mcu_ws/ros2/rosidl ]; then
        touch mcu_ws/ros2/rosidl/rosidl_typesupport_introspection_c/COLCON_IGNORE
        touch mcu_ws/ros2/rosidl/rosidl_typesupport_introspection_cpp/COLCON_IGNORE
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
