EXTENSIONS_DIR=$FW_TARGETDIR/freertos_apps/microros_nucleo_f446re_extensions

. $PREFIX/config/utils.sh

function help {
      echo "Configure script need an argument."
      echo "   --transport -t        serial or serial-usb"
}

echo $CONFIG_NAME > $FW_TARGETDIR/APP
# TODO add USB-OTG support
if [ "$UROS_TRANSPORT" == "serial" ]; then
      echo "Using serial device USART."

      echo "Please check firmware/freertos_apps/microros_nucleo_f446re_extensions/Core/Src/freertos.c"
      echo "for configuring serial device before build."

      update_meta "microxrcedds_client" "UCLIENT_PROFILE_CUSTOM_TRANSPORT=ON"
      update_meta "microxrcedds_client" "UCLIENT_PROFILE_STREAM_FRAMING=ON"
      update_meta "microxrcedds_client" "UCLIENT_PROFILE_SERIAL=OFF"
      update_meta "microxrcedds_client" "UCLIENT_PROFILE_UDP=OFF"
      update_meta "microxrcedds_client" "UCLIENT_PROFILE_TCP=OFF"

      update_meta "rmw_microxrcedds" "RMW_UXRCE_TRANSPORT=custom"

      remove_meta "rmw_microxrcedds" "RMW_UXRCE_DEFAULT_UDP_IP"
      remove_meta "rmw_microxrcedds" "RMW_UXRCE_DEFAULT_UDP_PORT"

      echo "Configured $UROS_TRANSPORT mode with agent at USART"
else
      help
fi
