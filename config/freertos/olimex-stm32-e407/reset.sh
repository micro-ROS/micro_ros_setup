OLIMEX_EXTENSIONS_DIR=$FW_TARGETDIR/freertos_apps/microros_olimex_e407_extensions

pushd $OLIMEX_EXTENSIONS_DIR > /dev/null

if lsusb -d 15BA:002a; then
  PROGRAMMER=interface/ftdi/olimex-arm-usb-tiny-h.cfg
elif lsusb -d 15BA:0003;then
  PROGRAMMER=interface/ftdi/olimex-arm-usb-ocd.cfg
elif lsusb -d 15BA:002b;then
  PROGRAMMER=interface/ftdi/olimex-arm-usb-ocd-h.cfg
else
  echo "Error. Unsuported OpenOCD USB programmer"
  exit 1
fi

openocd -f $PROGRAMMER -f target/stm32f4x.cfg -c init -c "reset halt" -c "reset" -c "exit"

popd > /dev/null

