
EXTENSIONS_DIR=$FW_TARGETDIR/zephyr_apps

. $PREFIX/config/utils.sh

function help {
      echo "Configure script need an argument. For example: ros2 run micro_ros_setup configure_firmware.sh [udp | tcp | serial | serialusb] [IP address | Serial port] [IP port]"
}

if [ $# -lt 1 ]; then
      help
      exit 1
fi

TRANSPORT=$1

if [ "$TRANSPORT" == "udp" ] || [ "$TRANSPORT" == "tcp" ]; then
      echo "Zephyr network support not available yet"
      help
      exit 1

elif [ "$TRANSPORT" == "serial" ]; then
      echo "Zephyr UART serial support not available yet"
      help
      exit 1

elif [ "$TRANSPORT" == "serialusb" ]; then
      echo "Using USB serial device."

      update_meta "rmw_microxrcedds" "RMW_UXRCE_TRANSPORT=custom"
      update_meta "microxrcedds_client" "EXTERNAL_TRANSPORT_HEADER="$EXTENSIONS_DIR"/microros_extensions/zephyr_usb_serial_transport.h"
      update_meta "microxrcedds_client" "EXTERNAL_TRANSPORT_SRC="$EXTENSIONS_DIR"/microros_extensions/zephyr_usb_serial_transport.c"

      remove_meta "rmw_microxrcedds" "RMW_UXRCE_DEFAULT_UDP_IP"
      remove_meta "rmw_microxrcedds" "RMW_UXRCE_DEFAULT_UDP_PORT"

      echo "Configured $TRANSPORT mode with agent at USB serial"
else
      help
fi
