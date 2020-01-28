NUTTX_DIR=$FW_TARGETDIR/NuttX
MCU_WS_DIR=$FW_TARGETDIR/mcu_ws

if [ $# -lt 1 ]; then
    echo "Nuttx configure script need an argument. For example: ros2 run micro_ros_setup configure_firmware.sh configs/olimex-stm32-e407/uros"
    exit 1
fi


if [ ! -d ~/tools/kconfig-frontends  ]; then
    git clone https://bitbucket.org/nuttx/tools.git ~/tools

    pushd ~/tools/kconfig-frontends >/dev/null
    ./configure --enable-mconf --disable-nconf --disable-gconf --disable-qconf 
    LD_RUN_PATH=/usr/local/lib && make && sudo make install && sudo ldconfig
    popd >/dev/null
fi

pushd $NUTTX_DIR >/dev/null
make distclean
tools/configure.sh $1
popd >/dev/null

find $MCU_WS_DIR -name rmw_microxrcedds.config -exec sed -i "s/CONFIG_MICRO_XRCEDDS_TRANSPORT=udp/CONFIG_MICRO_XRCEDDS_TRANSPORT=serial/g" {} \;