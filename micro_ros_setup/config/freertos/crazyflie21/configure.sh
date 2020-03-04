
EXTENSIONS_DIR=$FW_TARGETDIR/freertos_apps/microros_crazyflie21_extensions

. $PREFIX/config/utils.sh

echo $CONFIG_NAME > $FW_TARGETDIR/APP

update_meta "microxrcedds_client" "EXTERNAL_TRANSPORT_HEADER="$EXTENSIONS_DIR"/src/crazyflie_transport.h"
update_meta "microxrcedds_client" "EXTERNAL_TRANSPORT_SRC="$EXTENSIONS_DIR"/src/crazyflie_transport.c"
