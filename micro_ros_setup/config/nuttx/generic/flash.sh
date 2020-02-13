#! /bin/bash

set -e
set -o nounset
set -o pipefail


pushd $FW_TARGETDIR/NuttX > /dev/null

./scripts/flash.sh olimex-stm32-e407

popd > /dev/null
