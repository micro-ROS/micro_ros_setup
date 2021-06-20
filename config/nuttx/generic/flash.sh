#! /bin/bash

set -e
set -o nounset
set -o pipefail


pushd $FW_TARGETDIR/NuttX > /dev/null

if [ "$PLATFORM" = "olimex-stm32-e407" ]; then
  if [ -f nuttx.bin ]; then
    echo "Flashing firmware for $RTOS platform $PLATFORM"

      if lsusb -d 15BA:002a; then
        PROGRAMMER=interface/ftdi/olimex-arm-usb-tiny-h.cfg
      elif lsusb -d 15BA:0003;then
        PROGRAMMER=interface/ftdi/olimex-arm-usb-ocd.cfg
      elif lsusb -d 15BA:002b;then
        PROGRAMMER=interface/ftdi/olimex-arm-usb-ocd-h.cfg
      elif lsusb -d 0483:3748;then
        PROGRAMMER=interface/stlink-v2.cfg
      else
        echo "Error. Unsuported OpenOCD USB programmer"
        exit 1
      fi

      openocd -f $PROGRAMMER -f target/stm32f4x.cfg -c init -c "reset halt" -c "flash write_image erase nuttx.bin 0x08000000" -c "reset" -c "exit"
  else
    echo "Nuttx/nuttx.bin not found: please compile before flashing."
  fi
else
  echo "Unrecognized board: $PLATFORM"
  exit 1
fi

popd > /dev/null
