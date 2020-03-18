pushd $FW_TARGETDIR > /dev/null

  export ZEPHYR_TOOLCHAIN_VARIANT=zephyr
  export ZEPHYR_SDK_INSTALL_DIR=$FW_TARGETDIR/zephyr-sdk

  source $FW_TARGETDIR/zephyrproject/zephyr/zephyr-env.sh

  export PATH=~/.local/bin:"$PATH"

  west flash

popd > /dev/null

