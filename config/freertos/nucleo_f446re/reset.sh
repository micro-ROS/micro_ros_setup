EXTENSIONS_DIR=$FW_TARGETDIR/freertos_apps/microros_nucleo_f446re_extensions

pushd $EXTENSIONS_DIR > /dev/null

echo "Resetting firmware for $RTOS platform $PLATFORM"
if lsusb -d 0483:374b; then
  ST_INTERFACE=interface/stlink-v2-1.cfg
elif lsusb -d 0483:3748; then
  ST_INTERFACE=interface/stlink-v2.cfg
else
# TODO: add stlink v3, should it be stlink.cfg ?
  echo "Error. Unsuported OpenOCD USB programmer"
  exit 1
fi
openocd -f $ST_INTERFACE -f target/stm32f4x.cfg -c init -c "reset halt" -c "reset" -c "exit"

popd > /dev/null
