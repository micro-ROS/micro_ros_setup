#! /bin/bash

set -e
set -o nounset
set -o pipefail


NUTTX_DIR=$FW_TARGETDIR/NuttX

pushd $NUTTX_DIR >/dev/null
	make
popd >/dev/null
