
OLIMEX_EXTENSIONS_DIR=$FW_TARGETDIR/olimex_e407_extensions

function update_meta {
      python3 -c "import sys; import json; c = '$2'; s = json.loads(''.join([l for l in sys.stdin])); k = s['names']['$1']['cmake-args']; i = [c.startswith(v.split('=')[0]) for v in k]; k.pop(i.index(True)) if any(i) else None; k.append(c) if len(c.split('=')[1]) else None; print(json.dumps(s,indent=4))" < $FW_TARGETDIR/mcu_ws/colcon.meta > $FW_TARGETDIR/mcu_ws/colcon_new.meta
      mv $FW_TARGETDIR/mcu_ws/colcon_new.meta $FW_TARGETDIR/mcu_ws/colcon.meta
}

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

      update_meta "rmw_microxrcedds" "-DRMW_UXRCE_TRANSPORT="$TRANSPORT
      update_meta "rmw_microxrcedds" "-DRMW_UXRCE_DEFAULT_UDP_IP="$IP
      update_meta "rmw_microxrcedds" "-DRMW_UXRCE_DEFAULT_UDP_PORT="$PORT

      update_meta "microxrcedds_client" "-DEXTERNAL_TRANSPORT_HEADER_SERIAL="
      update_meta "microxrcedds_client" "-DEXTERNAL_TRANSPORT_SRC_SERIAL="

      echo "Configured $TRANSPORT mode with agent at $IP:$PORT"

elif [ "$TRANSPORT" == "serial" ]; then
      if [ $# -lt 2 ]; then
            SERIAL="3"
      else
            SERIAL=$2
      fi
      echo "Using serial device USART$SERIAL."

      update_meta "rmw_microxrcedds" "-DRMW_UXRCE_TRANSPORT=custom"
      update_meta "rmw_microxrcedds" "-DRMW_UXRCE_DEFAULT_SERIAL_DEVICE="$SERIAL
      update_meta "microxrcedds_client" "-DEXTERNAL_TRANSPORT_HEADER_SERIAL="$OLIMEX_EXTENSIONS_DIR"/Inc/olimex_e407_serial_transport.h"
      update_meta "microxrcedds_client" "-DEXTERNAL_TRANSPORT_SRC_SERIAL="$OLIMEX_EXTENSIONS_DIR"/Src/olimex_e407_serial_transport.c"

      update_meta "rmw_microxrcedds" "-DRMW_UXRCE_DEFAULT_UDP_IP="
      update_meta "rmw_microxrcedds" "-DRMW_UXRCE_DEFAULT_UDP_PORT="

      echo "Configured $TRANSPORT mode with agent at USART$SERIAL"
else
      help
fi
