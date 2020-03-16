
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

      remove_meta "rmw_microxrcedds" "RMW_UXRCE_DEFAULT_SERIAL_DEVICE"
      remove_meta "microxrcedds_client" "EXTERNAL_TRANSPORT_HEADER_SERIAL"
      remove_meta "microxrcedds_client" "EXTERNAL_TRANSPORT_SRC_SERIAL"

      echo "Configured $UROS_TRANSPORT mode with agent at $UROS_AGENT_IP:$UROS_AGENT_PORT"
else
      help
fi
