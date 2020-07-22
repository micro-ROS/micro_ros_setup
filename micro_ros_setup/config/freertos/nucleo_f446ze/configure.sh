
EXTENSIONS_DIR=$FW_TARGETDIR/freertos_apps/microros_nucleo_f446ze_extensions

. $PREFIX/config/utils.sh

function help {
      echo "Configure script need an argument."
      echo "   --transport -t        serial or serial-usb"
      echo "   --dev -d             agent string descriptor in a serial-like transport"
}

echo $CONFIG_NAME > $FW_TARGETDIR/APP
# TODO add USB-OTG support
if [ "$UROS_TRANSPORT" == "serial" ]; then
      echo "Using serial device USART$UROS_AGENT_DEVICE."

      cp -f $EXTENSIONS_DIR/uros_transport/stm32f446ze_serial_transport.c $FW_TARGETDIR/mcu_ws/eProsima/Micro-XRCE-DDS-Client/src/c/profile/transport/serial/serial_transport_external.c
      cp -f $EXTENSIONS_DIR/uros_transport/stm32f446ze_serial_transport.h $FW_TARGETDIR/mcu_ws/eProsima/Micro-XRCE-DDS-Client/include/uxr/client/profile/transport/serial/serial_transport_external.h
      update_meta "microxrcedds_client" "UCLIENT_EXTERNAL_SERIAL=ON"

      update_meta "rmw_microxrcedds" "RMW_UXRCE_TRANSPORT=custom"
      update_meta "rmw_microxrcedds" "RMW_UXRCE_DEFAULT_SERIAL_DEVICE="$UROS_AGENT_DEVICE

      remove_meta "rmw_microxrcedds" "RMW_UXRCE_DEFAULT_UDP_IP"
      remove_meta "rmw_microxrcedds" "RMW_UXRCE_DEFAULT_UDP_PORT"

      echo "Configured $UROS_TRANSPORT mode with agent at USART$UROS_AGENT_DEVICE"

else
      help
fi
