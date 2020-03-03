
EXTENSIONS_DIR=$FW_TARGETDIR/zephyr_apps

. $PREFIX/config/utils.sh

function help {
      echo "Configure script need an argument."
      echo "   --transport -t       udp, tcp, serial or serialusb"
      echo "   --dev -d             agent string descriptor in a serial-like transport"
      echo "   --ip -i              agent IP in a network-like transport"
      echo "   --port -p            agent port in a network-like transport"

}

echo $CONFIG_NAME >> $FW_TARGETDIR/APP

if [ "$UROS_TRANSPORT" == "udp" ] || [ "$UROS_TRANSPORT" == "tcp" ]; then
      echo "Zephyr network support not available yet"
      help
      exit 1

elif [ "$UROS_TRANSPORT" == "serial" ]; then
      echo "Zephyr UART serial support not available yet"
      help
      exit 1

elif [ "$UROS_TRANSPORT" == "serialusb" ]; then
      echo "Using USB serial device."

      update_meta "rmw_microxrcedds" "RMW_UXRCE_TRANSPORT=custom"
      update_meta "microxrcedds_client" "EXTERNAL_TRANSPORT_HEADER="$EXTENSIONS_DIR"/microros_extensions/zephyr_usb_serial_transport.h"
      update_meta "microxrcedds_client" "EXTERNAL_TRANSPORT_SRC="$EXTENSIONS_DIR"/microros_extensions/zephyr_usb_serial_transport.c"

      remove_meta "rmw_microxrcedds" "RMW_UXRCE_DEFAULT_UDP_IP"
      remove_meta "rmw_microxrcedds" "RMW_UXRCE_DEFAULT_UDP_PORT"

      echo "Configured $UROS_TRANSPORT mode with agent at USB serial"
else
      help
fi
