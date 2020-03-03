
EXTENSIONS_DIR=$FW_TARGETDIR/freertos_apps/microros_olimex_e407_extensions

. $(dirname $0)/../../utils.sh

function help {
      echo "Configure script need an argument. For example: ros2 run micro_ros_setup configure_firmware.sh [udp | tcp | serial] [IP address | Serial port] [IP port]"
}

if [ $# -lt 1 ]; then
      help
      exit 1
fi

TRANSPORT=$1

if [ "$TRANSPORT" == "udp" ] || [ "$TRANSPORT" == "tcp" ]; then
      if [ $# -lt 3 ]; then
            echo "UDP or TCP configuration needs IP and port. For example: ros2 run micro_ros_setup configure_firmware.sh [udp | tcp] [IP address] [IP port]"
            exit 1
      fi

      IP=$2
      PORT=$3

      update_meta "rmw_microxrcedds" "RMW_UXRCE_TRANSPORT="$TRANSPORT
      update_meta "rmw_microxrcedds" "RMW_UXRCE_DEFAULT_UDP_IP="$IP
      update_meta "rmw_microxrcedds" "RMW_UXRCE_DEFAULT_UDP_PORT="$PORT

      remove_meta "rmw_microxrcedds" "RMW_UXRCE_DEFAULT_SERIAL_DEVICE"
      remove_meta "microxrcedds_client" "EXTERNAL_TRANSPORT_HEADER_SERIAL"
      remove_meta "microxrcedds_client" "EXTERNAL_TRANSPORT_SRC_SERIAL"

      echo "Configured $TRANSPORT mode with agent at $IP:$PORT"

elif [ "$TRANSPORT" == "serial" ]; then
      if [ $# -lt 2 ]; then
            SERIAL="3"
      else
            SERIAL=$2
      fi
      echo "Using serial device USART$SERIAL."

      update_meta "rmw_microxrcedds" "RMW_UXRCE_TRANSPORT=custom"
      update_meta "rmw_microxrcedds" "RMW_UXRCE_DEFAULT_SERIAL_DEVICE="$SERIAL
      update_meta "microxrcedds_client" "EXTERNAL_TRANSPORT_HEADER_SERIAL="$EXTENSIONS_DIR"/Inc/olimex_e407_serial_transport.h"
      update_meta "microxrcedds_client" "EXTERNAL_TRANSPORT_SRC_SERIAL="$EXTENSIONS_DIR"/Src/olimex_e407_serial_transport.c"

      remove_meta "rmw_microxrcedds" "RMW_UXRCE_DEFAULT_UDP_IP"
      remove_meta "rmw_microxrcedds" "RMW_UXRCE_DEFAULT_UDP_PORT"

      echo "Configured $TRANSPORT mode with agent at USART$SERIAL"
else
      help
fi
