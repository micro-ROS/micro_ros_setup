#! /bin/bash

pushd $FW_TARGETDIR >/dev/null
    rm -rf mcu_ws/ros2 mcu_ws/ros2.repos
    curl -s https://raw.githubusercontent.com/ros2/ros2/dashing/ros2.repos |\
        ros2 run micro_ros_setup yaml_filter.py raspbian_apps/$CONFIG_NAME/ros2_repos.filter > ros2.repos
    vcs import --input ros2.repos mcu_ws/ && rm ros2.repos
    vcs import --input raspbian_apps/$CONFIG_NAME/app.repos mcu_ws/
    cp raspbian_apps/$CONFIG_NAME/colcon.meta mcu_ws/
popd >/dev/null