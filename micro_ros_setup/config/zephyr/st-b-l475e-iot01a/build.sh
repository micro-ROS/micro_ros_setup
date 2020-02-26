pushd $FW_TARGETDIR >/dev/null
    source $FW_TARGETDIR/zephyrproject/zephyr/zephyr-env.sh
    export ZEPHYR_TOOLCHAIN_VARIANT=zephyr
    export ZEPHYR_SDK_INSTALL_DIR=$(pwd)/zephyr-sdk-0.11.1

    export PATH=~/.local/bin:"$PATH"

    rm -rf build
    
    if [ "$UROS_FAST_BUILD" = "off" ] || [ ! -d "mcu_ws/build" ]; then
        rm -rf mcu_ws/build mcu_ws/install mcu_ws/log
    fi

    west build -p auto olimex_e407_extensions -- -G'Unix Makefiles' -DCMAKE_VERBOSE_MAKEFILE=ON
    # west build -p auto -b olimex_stm32_e407 olimex_e407_extensions -- -G'Unix Makefiles'
popd >/dev/null
