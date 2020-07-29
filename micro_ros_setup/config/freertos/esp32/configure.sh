
EXTENSIONS_DIR=$FW_TARGETDIR/freertos_apps/microros_esp32_extensions

. $PREFIX/config/utils.sh

function help {
      echo "Configure script need an argument."
      echo "   --transport -t       udp, tcp or serial"
      echo "   --dev -d             agent string descriptor in a serial-like transport"
      echo "   --ip -i              agent IP in a network-like transport"
      echo "   --port -p            agent port in a network-like transport"
}

echo $CONFIG_NAME > $FW_TARGETDIR/APP

if [ "$UROS_TRANSPORT" == "udp" ] || [ "$UROS_TRANSPORT" == "tcp" ]; then
    update_meta "rmw_microxrcedds" "RMW_UXRCE_TRANSPORT="$UROS_TRANSPORT
    update_meta "rmw_microxrcedds" "RMW_UXRCE_DEFAULT_UDP_IP="$UROS_AGENT_IP
    update_meta "rmw_microxrcedds" "RMW_UXRCE_DEFAULT_UDP_PORT="$UROS_AGENT_PORT

    remove_meta "rmw_microxrcedds" "RMW_UXRCE_DEFAULT_SERIAL_DEVICE"
    remove_meta "microxrcedds_client" "EXTERNAL_TRANSPORT_HEADER_SERIAL"
    remove_meta "microxrcedds_client" "EXTERNAL_TRANSPORT_SRC_SERIAL"

    echo "Configured $UROS_TRANSPORT mode with agent at $UROS_AGENT_IP:$UROS_AGENT_PORT"

elif [ "$UROS_TRANSPORT" == "serial" ]; then
    if [ "$UROS_AGENT_DEVICE" -gt 2 ]; then
        echo ESP32 only supports USART0, USART1 or USART2
        exit 1
    fi

    echo "Using serial device USART$UROS_AGENT_DEVICE."

    cp -f $EXTENSIONS_DIR/serial_transport_external/esp32_serial_transport.c $FW_TARGETDIR/mcu_ws/eProsima/Micro-XRCE-DDS-Client/src/c/profile/transport/serial/serial_transport_external.c
    cp -f $EXTENSIONS_DIR/serial_transport_external/esp32_serial_transport.h $FW_TARGETDIR/mcu_ws/eProsima/Micro-XRCE-DDS-Client/include/uxr/client/profile/transport/serial/serial_transport_external.h
    update_meta "microxrcedds_client" "UCLIENT_EXTERNAL_SERIAL=ON"

    update_meta "rmw_microxrcedds" "RMW_UXRCE_TRANSPORT=custom"
    update_meta "rmw_microxrcedds" "RMW_UXRCE_DEFAULT_SERIAL_DEVICE="$UROS_AGENT_DEVICE

    remove_meta "rmw_microxrcedds" "RMW_UXRCE_DEFAULT_UDP_IP"
    remove_meta "rmw_microxrcedds" "RMW_UXRCE_DEFAULT_UDP_PORT"

    echo "Configured $UROS_TRANSPORT mode with agent at USART$UROS_AGENT_DEVICE"

elif [ "$UROS_TRANSPORT" == "udp" ]; then

    update_meta "rmw_microxrcedds" "RMW_UXRCE_TRANSPORT="$UROS_TRANSPORT
    update_meta "rmw_microxrcedds" "RMW_UXRCE_DEFAULT_UDP_IP="$UROS_AGENT_IP
    update_meta "rmw_microxrcedds" "RMW_UXRCE_DEFAULT_UDP_PORT="$UROS_AGENT_PORT
    update_meta "microxrcedds_client" "UCLIENT_PROFILE_SERIAL=OFF"
    update_meta "microxrcedds_client" "UCLIENT_PROFILE_UDP=ON"
    update_meta "microxrcedds_client" "UCLIENT_PROFILE_TCP=OFF"
    
    remove_meta "rmw_microxrcedds" "RMW_UXRCE_DEFAULT_SERIAL_DEVICE"
    remove_meta "microxrcedds_client" "UCLIENT_EXTERNAL_SERIAL"
    remove_meta "microxrcedds_client" "EXTERNAL_TRANSPORT_HEADER_SERIAL"
    remove_meta "microxrcedds_client" "EXTERNAL_TRANSPORT_SRC_SERIAL"

    echo "Configured $UROS_TRANSPORT mode with agent at $UROS_AGENT_IP:$UROS_AGENT_PORT"

    #TODO (pablogs9): remove this patch and fix this issue
    pushd $EXTENSIONS_DIR/../../toolchain/esp-idf > /dev/null
        git apply $EXTENSIONS_DIR/lwip.patch
    popd > /dev/null
else
    help
    exit 1
fi


UROS_APP=$(head -n1 $FW_TARGETDIR/APP | tail -n1)
UROS_APP_FOLDER="$FW_TARGETDIR/freertos_apps/apps/$UROS_APP"
export IDF_PATH=$FW_TARGETDIR/toolchain/esp-idf
export IDF_TOOLS_PATH=$FW_TARGETDIR/toolchain/espressif
export PATH=$PATH:$IDF_TOOLS_PATH/tools/xtensa-esp32-elf/esp-2019r2-8.2.0/xtensa-esp32-elf/bin

if [ -d $EXTENSIONS_DIR/build ]; then
    rm -r $EXTENSIONS_DIR/build
fi
mkdir -p $EXTENSIONS_DIR/build

pushd $EXTENSIONS_DIR/build >/dev/null

    cmake -G'Unix Makefiles' \
        -DCMAKE_VERBOSE_MAKEFILE=ON \
        -DUROS_APP_FOLDER=$UROS_APP_FOLDER \
        -DIDF_PATH=$IDF_PATH \
        -DUROS_APP=$UROS_APP \
        $EXTENSIONS_DIR

popd >/dev/null

if [ "$UROS_TRANSPORT" == "udp" ]; then
    echo "Configured $UROS_TRANSPORT mode with agent at $UROS_AGENT_IP:$UROS_AGENT_PORT"
    echo "You can configure your WiFi AP password running 'ros2 run micro_ros_setup build_firmware.sh menuconfig'"
fi
