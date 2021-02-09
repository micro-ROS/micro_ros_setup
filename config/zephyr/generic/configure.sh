
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

update_meta "microxrcedds_client" "UCLIENT_PROFILE_CUSTOM_TRANSPORT=ON"
update_meta "microxrcedds_client" "UCLIENT_PROFILE_STREAM_FRAMING=ON"
update_meta "microxrcedds_client" "UCLIENT_PROFILE_SERIAL=OFF"
update_meta "microxrcedds_client" "UCLIENT_PROFILE_UDP=OFF"
update_meta "microxrcedds_client" "UCLIENT_PROFILE_TCP=OFF"

update_meta "rmw_microxrcedds" "RMW_UXRCE_TRANSPORT=custom"

echo $UROS_TRANSPORT > $FW_TARGETDIR/TRANSPORT
