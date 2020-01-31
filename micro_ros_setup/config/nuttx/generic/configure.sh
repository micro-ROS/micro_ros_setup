#! /bin/bash
#
# 

set -e
set -o nounset
set -o pipefail


NUTTX_DIR=$FW_TARGETDIR/NuttX
MCU_WS_DIR=$FW_TARGETDIR/mcu_ws

if [ $# -lt 1 ]; then
    echo "Syntax: configure.sh <config>"
    exit 1
fi

# parse the platform from this script's path name
PLATFORM=$(basename $(dirname $0))
CONFIG_NAME=$1

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

pushd $NUTTX_DIR >/dev/null
make distclean
tools/configure.sh $CONFIG
popd >/dev/null

find $MCU_WS_DIR -name rmw_microxrcedds.config -exec \
    sed -i "s/CONFIG_MICRO_XRCEDDS_TRANSPORT=udp/CONFIG_MICRO_XRCEDDS_TRANSPORT=serial/g" {} \;
