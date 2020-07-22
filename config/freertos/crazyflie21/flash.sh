pushd $FW_TARGETDIR/freertos_apps/microros_crazyflie21_extensions > /dev/null

if [ -f cf2.bin ]; then
  echo "Flashing firmware for $RTOS platform $PLATFORM"
  dfu-util -d 0483:df11 -a 0 -s 0x08000000 -D cf2.bin
else
  echo "cf2.bin not found: please compile before flashing."
fi

popd > /dev/null

