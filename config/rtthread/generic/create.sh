pushd $FW_TARGETDIR >/dev/null

    if [ -e sdk-bsp-stm32h750-realthread ]; then 
        echo "sdk-bsp-stm32h750-realthread already created Please delete $FW_TARGETDIR/sdk-bsp-stm32h750-realthread folder if you want a fresh installation."
        exit 1
        
    else
    echo "dowmload code "
        git clone https://github.com/RT-Thread-Studio/sdk-bsp-stm32h750-realthread-artpi.git

    echo "dowmload  gcc-arm-none-eabi-5_4"
        wget -c https://armkeil.blob.core.windows.net/developer//sitecore/shell/-/media/Files/downloads/gnu-rm/5_4-2016q3/gcc-arm-none-eabi-5_4-2016q3-20160926-linux,-d-,tar.bz2
        tar -xvf gcc-arm-none-eabi-5_4-2016q3-20160926-linux,-d-,tar.bz2
        rm gcc-arm-none-eabi-5_4-2016q3-20160926-linux,-d-,tar.bz2
    fi

    if [ -e $FW_TARGETDIR/sdk-bsp-stm32h750-realthread-artpi/projects/art_pi_wifi ]; then
    
        pushd $FW_TARGETDIR/sdk-bsp-stm32h750-realthread-artpi/projects/art_pi_wifi >/dev/null
            git clone https://github.com/navy-to-haijun/micro-ROS-rtthread-app.git
        popd >/dev/null
        # soft link
        pushd $FW_TARGETDIR/sdk-bsp-stm32h750-realthread-artpi/projects/art_pi_wifi>/dev/null
           ln -s ../../libraries/ libraries
           ln -s ../../rt-thread/ rt-thread 
        popd >/dev/null
    fi
   
    # ignore broken packages
    touch mcu_ws/ros2/rcl_logging/rcl_logging_log4cxx/COLCON_IGNORE
    touch mcu_ws/ros2/rcl_logging/rcl_logging_spdlog/COLCON_IGNORE
    touch mcu_ws/ros2/rcl/COLCON_IGNORE
    touch mcu_ws/ros2/rosidl/rosidl_typesupport_introspection_cpp/COLCON_IGNORE
    touch mcu_ws/ros2/rcpputils/COLCON_IGNORE
    touch mcu_ws/uros/rcl/rcl_yaml_param_parser/COLCON_IGNORE
    touch mcu_ws/uros/rclc/rclc_examples/COLCON_IGNORE

popd >/dev/null