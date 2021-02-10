
EXTENSIONS_DIR=$FW_TARGETDIR/zephyr_apps

. $PREFIX/config/utils.sh

function help {
      echo "Configure script need an argument."
      echo "   --transport -t       udp, serial or serial-usb"
}

echo $CONFIG_NAME > $FW_TARGETDIR/APP

update_meta "microxrcedds_client" "UCLIENT_PROFILE_CUSTOM_TRANSPORT=ON"
update_meta "microxrcedds_client" "UCLIENT_PROFILE_STREAM_FRAMING=ON"
update_meta "microxrcedds_client" "UCLIENT_PROFILE_SERIAL=OFF"
update_meta "microxrcedds_client" "UCLIENT_PROFILE_UDP=OFF"
update_meta "microxrcedds_client" "UCLIENT_PROFILE_TCP=OFF"

update_meta "rmw_microxrcedds" "RMW_UXRCE_TRANSPORT=custom"

echo $UROS_TRANSPORT > $FW_TARGETDIR/TRANSPORT

if [ "$UROS_TRANSPORT" == "udp" ]; then
      echo "Configured UDP mode."
      echo "Please check firmware/zephyr_apps/microros_extensions/microros_transports.h"
      echo "for configuring IP and port before build."
elif [ "$UROS_TRANSPORT" == "serial" ]; then
      echo "Using serial device."
      echo "Please check firmware/zephyr_apps/microros_extensions/microros_transports.h"
      echo "for configuring serial device before build."
elif [ "$UROS_TRANSPORT" == "serial-usb" ]; then
      echo "Using USB serial device."
      echo "Configured $UROS_TRANSPORT mode with agent at USB serial"
else
      help
fi
