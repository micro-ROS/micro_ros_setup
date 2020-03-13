
EXTENSIONS_DIR=$FW_TARGETDIR/freertos_apps/microros_crazyflie21_extensions

. $PREFIX/config/utils.sh

echo $CONFIG_NAME > $FW_TARGETDIR/APP

cp -f $EXTENSIONS_DIR/src/crazyflie_transport.c $FW_TARGETDIR/mcu_ws/eProsima/Micro-XRCE-DDS-Client/src/c/profile/transport/serial/serial_transport_external.c
cp -f $EXTENSIONS_DIR/src/crazyflie_transport.h $FW_TARGETDIR/mcu_ws/eProsima/Micro-XRCE-DDS-Client/include/uxr/client/profile/transport/serial/serial_transport_external.h
update_meta "microxrcedds_client" "UCLIENT_EXTERNAL_SERIAL=ON"