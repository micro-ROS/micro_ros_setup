#! /bin/bash

set -e
set -o nounset
set -o pipefail


pushd $FW_TARGETDIR/spresense/sdk > /dev/null

if [ "$PLATFORM" = "spresense" ]; then
  if [ -f nuttx.spk ]; then
    echo "Flashing firmware for $RTOS platform $PLATFORM"
    ./tools/flash.sh -c $DEVICE_NAME nuttx.spk
  else
    echo "Nuttx/nuttx.spk not found: please compile before flashing."
  fi
else
  echo "Unrecognized board: $PLATFORM"
  exit 1
fi

popd > /dev/null
