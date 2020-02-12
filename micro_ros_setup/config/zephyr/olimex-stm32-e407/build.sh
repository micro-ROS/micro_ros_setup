pushd $FW_TARGETDIR >/dev/null
    export ZEPHYR_TOOLCHAIN_VARIANT=zephyr
    export ZEPHYR_SDK_INSTALL_DIR=$(pwd)/zephyr-sdk-0.11.1
    source $FW_TARGETDIR/zephyrproject/zephyr/zephyr-env.sh

    rm -rf build
    
    if [ "$UROS_FAST_BUILD" = "off" ] || [ ! -d "build" ]; then
        rm -rf mcu_ws/build mcu_ws/install mcu_ws/log
    fi

    west build -p auto olimex_e407_extensions -- -G'Unix Makefiles' -DCMAKE_VERBOSE_MAKEFILE=ON
    # west build -p auto -b olimex_stm32_e407 olimex_e407_extensions -- -G'Unix Makefiles'
popd >/dev/null
