#! /bin/bash
#
# 

set -e
set -o nounset
set -o pipefail


NUTTX_DIR=$FW_TARGETDIR/NuttX
MCU_WS_DIR=$FW_TARGETDIR/mcu_ws

# parse the platform from this script's path name
PLATFORM=$(head -n2 $FW_TARGETDIR/PLATFORM | tail -n1)

# for the "generic" platform, the user must supply both board and config
if [ "$PLATFORM" = "generic" ]
then
    CONFIG=configs/$CONFIG_NAME
else
    CONFIG="configs/$PLATFORM/$CONFIG_NAME"
fi

if [ ! -d "$NUTTX_DIR/$CONFIG" ]
then
    echo "Configuration $CONFIG (expanded from $CONFIG_NAME) not found"
    exit 1
fi

# source dev_ws for kconfig
set +o nounset
. $FW_TARGETDIR/dev_ws/install/setup.bash
set -o nounset

pushd $NUTTX_DIR >/dev/null
make distclean
tools/configure.sh $CONFIG
popd >/dev/null

