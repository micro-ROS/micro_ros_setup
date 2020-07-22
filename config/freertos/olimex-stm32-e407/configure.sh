
EXTENSIONS_DIR=$FW_TARGETDIR/freertos_apps/microros_olimex_e407_extensions

. $PREFIX/config/utils.sh

function help {
      echo "Configure script need an argument."
      echo "   --transport -t       udp, tcp, serial or serial-usb"
      echo "   --dev -d             agent string descriptor in a serial-like transport"
      echo "   --ip -i              agent IP in a network-like transport"
      echo "   --port -p            agent port in a network-like transport"
}

echo $CONFIG_NAME > $FW_TARGETDIR/APP

if [ "$UROS_TRANSPORT" == "udp" ] || [ "$UROS_TRANSPORT" == "tcp" ]; then

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

elif [ "$UROS_TRANSPORT" == "serial" ]; then
      echo "Using serial device USART$UROS_AGENT_DEVICE."

      cp -f $EXTENSIONS_DIR/Src/olimex_e407_serial_transport.c $FW_TARGETDIR/mcu_ws/eProsima/Micro-XRCE-DDS-Client/src/c/profile/transport/serial/serial_transport_external.c
      cp -f $EXTENSIONS_DIR/Inc/olimex_e407_serial_transport.h $FW_TARGETDIR/mcu_ws/eProsima/Micro-XRCE-DDS-Client/include/uxr/client/profile/transport/serial/serial_transport_external.h
      update_meta "microxrcedds_client" "UCLIENT_EXTERNAL_SERIAL=ON"
      update_meta "microxrcedds_client" "UCLIENT_PROFILE_SERIAL=ON"
      update_meta "microxrcedds_client" "UCLIENT_PROFILE_UDP=OFF"
      update_meta "microxrcedds_client" "UCLIENT_PROFILE_TCP=OFF"

      update_meta "rmw_microxrcedds" "RMW_UXRCE_TRANSPORT=custom_serial"
      update_meta "rmw_microxrcedds" "RMW_UXRCE_DEFAULT_SERIAL_DEVICE="$UROS_AGENT_DEVICE

      remove_meta "rmw_microxrcedds" "RMW_UXRCE_DEFAULT_UDP_IP"
      remove_meta "rmw_microxrcedds" "RMW_UXRCE_DEFAULT_UDP_PORT"

      echo "Configured $UROS_TRANSPORT mode with agent at USART$UROS_AGENT_DEVICE"

elif [ "$UROS_TRANSPORT" == "serial-usb" ]; then
      echo "Using serial USB device. EXPERIMENTAL."

      cp -f $EXTENSIONS_DIR/Src/olimex_e407_usb_transport.c $FW_TARGETDIR/mcu_ws/eProsima/Micro-XRCE-DDS-Client/src/c/profile/transport/serial/serial_transport_external.c
      cp -f $EXTENSIONS_DIR/Inc/olimex_e407_usb_transport.h $FW_TARGETDIR/mcu_ws/eProsima/Micro-XRCE-DDS-Client/include/uxr/client/profile/transport/serial/serial_transport_external.h
      update_meta "microxrcedds_client" "UCLIENT_EXTERNAL_SERIAL=ON"

      update_meta "rmw_microxrcedds" "RMW_UXRCE_TRANSPORT=custom_serial"

      remove_meta "rmw_microxrcedds" "RMW_UXRCE_DEFAULT_UDP_IP"
      remove_meta "rmw_microxrcedds" "RMW_UXRCE_DEFAULT_UDP_PORT"

      echo "Configured $UROS_TRANSPORT mode with agent"
else
      help
fi
