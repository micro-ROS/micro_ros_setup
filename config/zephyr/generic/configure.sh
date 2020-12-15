
EXTENSIONS_DIR=$FW_TARGETDIR/zephyr_apps

. $PREFIX/config/utils.sh

function help {
      echo "Configure script need an argument."
      echo "   --transport -t       udp, serial or serial-usb"
      echo "   --dev -d             agent string descriptor in a serial-like transport"
      echo "   --ip -i              agent IP in a network-like transport"
      echo "   --port -p            agent port in a network-like transport"

}

echo $CONFIG_NAME > $FW_TARGETDIR/APP

if [ "$UROS_TRANSPORT" == "udp" ]; then
      update_meta "rmw_microxrcedds" "RMW_UXRCE_TRANSPORT=$UROS_TRANSPORT"
      update_meta "rmw_microxrcedds" "RMW_UXRCE_DEFAULT_UDP_IP=$UROS_AGENT_IP"
      update_meta "rmw_microxrcedds" "RMW_UXRCE_DEFAULT_UDP_PORT=$UROS_AGENT_PORT"

      cp -f $EXTENSIONS_DIR/microros_extensions/zephyr_networking_transport.c $FW_TARGETDIR/mcu_ws/eProsima/Micro-XRCE-DDS-Client/src/c/profile/transport/ip/udp/udp_transport_external.c
      cp -f $EXTENSIONS_DIR/microros_extensions/zephyr_networking_transport.h $FW_TARGETDIR/mcu_ws/eProsima/Micro-XRCE-DDS-Client/include/uxr/client/profile/transport/ip/udp/udp_transport_external.h

      update_meta "microxrcedds_client" "UCLIENT_PROFILE_UDP=ON"
      update_meta "microxrcedds_client" "UCLIENT_EXTERNAL_UDP=ON"

      update_meta "microxrcedds_client" "UCLIENT_PROFILE_DISCOVERY=OFF"
      update_meta "microxrcedds_client" "UCLIENT_PROFILE_TCP=OFF"
      update_meta "microxrcedds_client" "UCLIENT_EXTERNAL_SERIAL=OFF"

      echo "Configured $UROS_TRANSPORT mode with agent at $UROS_AGENT_IP:$UROS_AGENT_PORT"

      echo $UROS_TRANSPORT > $FW_TARGETDIR/TRANSPORT

elif [ "$UROS_TRANSPORT" == "serial" ]; then
      echo "Using serial device."

      cp -f $EXTENSIONS_DIR/microros_extensions/zephyr_serial_transport.c $FW_TARGETDIR/mcu_ws/eProsima/Micro-XRCE-DDS-Client/src/c/profile/transport/serial/serial_transport_external.c
      cp -f $EXTENSIONS_DIR/microros_extensions/zephyr_serial_transport.h $FW_TARGETDIR/mcu_ws/eProsima/Micro-XRCE-DDS-Client/include/uxr/client/profile/transport/serial/serial_transport_external.h
      
      update_meta "microxrcedds_client" "UCLIENT_PROFILE_SERIAL=ON"
      update_meta "microxrcedds_client" "UCLIENT_EXTERNAL_SERIAL=ON"
      update_meta "microxrcedds_client" "UCLIENT_EXTERNAL_UDP=OFF"

      update_meta "microxrcedds_client" "UCLIENT_PROFILE_DISCOVERY=OFF"
      update_meta "microxrcedds_client" "UCLIENT_PROFILE_UDP=OFF"
      update_meta "microxrcedds_client" "UCLIENT_PROFILE_TCP=OFF"

      update_meta "rmw_microxrcedds" "RMW_UXRCE_TRANSPORT=custom_serial"

      if [ ! -z "$UROS_AGENT_DEVICE" ];then
            update_meta "rmw_microxrcedds" "RMW_UXRCE_DEFAULT_SERIAL_DEVICE=$UROS_AGENT_DEVICE"      
      fi

      remove_meta "rmw_microxrcedds" "RMW_UXRCE_DEFAULT_UDP_IP"
      remove_meta "rmw_microxrcedds" "RMW_UXRCE_DEFAULT_UDP_PORT"

      echo $UROS_TRANSPORT > $FW_TARGETDIR/TRANSPORT

elif [ "$UROS_TRANSPORT" == "serial-usb" ]; then
      echo "Using USB serial device."

      cp -f $EXTENSIONS_DIR/microros_extensions/zephyr_usb_serial_transport.c $FW_TARGETDIR/mcu_ws/eProsima/Micro-XRCE-DDS-Client/src/c/profile/transport/serial/serial_transport_external.c
      cp -f $EXTENSIONS_DIR/microros_extensions/zephyr_usb_serial_transport.h $FW_TARGETDIR/mcu_ws/eProsima/Micro-XRCE-DDS-Client/include/uxr/client/profile/transport/serial/serial_transport_external.h
      
      update_meta "microxrcedds_client" "UCLIENT_PROFILE_SERIAL=ON"
      update_meta "microxrcedds_client" "UCLIENT_EXTERNAL_SERIAL=ON"

      update_meta "microxrcedds_client" "UCLIENT_PROFILE_DISCOVERY=OFF"
      update_meta "microxrcedds_client" "UCLIENT_PROFILE_UDP=OFF"
      update_meta "microxrcedds_client" "UCLIENT_PROFILE_TCP=OFF"
      update_meta "microxrcedds_client" "UCLIENT_EXTERNAL_UDP=OFF"

      update_meta "rmw_microxrcedds" "RMW_UXRCE_TRANSPORT=custom_serial"

      remove_meta "rmw_microxrcedds" "RMW_UXRCE_DEFAULT_UDP_IP"
      remove_meta "rmw_microxrcedds" "RMW_UXRCE_DEFAULT_UDP_PORT"
      remove_meta "rmw_microxrcedds" "RMW_UXRCE_DEFAULT_SERIAL_DEVICE"


      echo "Configured $UROS_TRANSPORT mode with agent at USB serial"

      echo $UROS_TRANSPORT > $FW_TARGETDIR/TRANSPORT

else
      help
fi
