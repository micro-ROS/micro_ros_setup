
function add_to_meta {
      python3 -c "import sys; import json; c = '$ARG_TO_ADD'; s = json.loads(''.join([l for l in sys.stdin])); k = s['names']['rmw_microxrcedds']['cmake-args']; i = [c.startswith(v.split('=')[0]) for v in k]; k.pop(i.index(True)) if any(i) else None; k.append(c); print(json.dumps(s,indent=4))" < $FW_TARGETDIR/mcu_ws/colcon.meta > $FW_TARGETDIR/mcu_ws/colcon_new.meta
      mv $FW_TARGETDIR/mcu_ws/colcon_new.meta $FW_TARGETDIR/mcu_ws/colcon.meta
}

if [ $# -lt 1 ]; then
    echo "Configure script need an argument. For example: ros2 run micro_ros_setup configure_firmware.sh [udp | tcp | serial] [IP address | Serial port] [IP port]"
    exit 1
fi

TRANSPORT=$1

if [ "$TRANSPORT" == "udp" ] || [ "$TRANSPORT" == "tcp" ]; then
      if [ $# -lt 3 ]; then
            echo "UDP or TCP configuration needs IP and port. For example: ros2 run micro_ros_setup configure_firmware.sh [udp | tcp] [IP address] [IP port]"
            exit 1
      fi
      
      ARG_TO_ADD="-DRMW_UXRCE_TRANSPORT="$TRANSPORT
      add_to_meta

      IP=$2
      ARG_TO_ADD="-DRMW_UXRCE_DEFAULT_UDP_IP="$IP
      add_to_meta

      PORT=$3
      ARG_TO_ADD="-DRMW_UXRCE_DEFAULT_UDP_PORT="$PORT
      add_to_meta

      echo "Configured $TRANSPORT mode with agent at $IP:$PORT"

fi

if [ "$TRANSPORT" == "serial" ]; then
      echo "Serial configuration not working yet. Work in Progress"
      exit 1
      if [ $# -lt 2 ]; then
            echo "Serial configuration needs serial port. For example: ros2 run micro_ros_setup configure_firmware.sh serial [Serial port]"
            exit 1
      fi

      ARG_TO_ADD="-DRMW_UXRCE_TRANSPORT="$TRANSPORT
      add_to_meta

      SERIAL=$2
      ARG_TO_ADD="-DRMW_UXRCE_DEFAULT_SERIAL_DEVICE="$SERIAL
      add_to_meta

      echo "Configured $TRANSPORT mode with agent at $SERIAL"
fi
