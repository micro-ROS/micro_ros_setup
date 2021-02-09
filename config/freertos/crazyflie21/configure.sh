
EXTENSIONS_DIR=$FW_TARGETDIR/freertos_apps/microros_crazyflie21_extensions

. $PREFIX/config/utils.sh

echo $CONFIG_NAME > $FW_TARGETDIR/APP

update_meta "microxrcedds_client" "UCLIENT_PROFILE_CUSTOM_TRANSPORT=ON"
update_meta "microxrcedds_client" "UCLIENT_PROFILE_STREAM_FRAMING=ON"
update_meta "microxrcedds_client" "UCLIENT_PROFILE_SERIAL=OFF"
update_meta "microxrcedds_client" "UCLIENT_PROFILE_UDP=OFF"
update_meta "microxrcedds_client" "UCLIENT_PROFILE_TCP=OFF"

update_meta "rmw_microxrcedds" "RMW_UXRCE_TRANSPORT=custom"