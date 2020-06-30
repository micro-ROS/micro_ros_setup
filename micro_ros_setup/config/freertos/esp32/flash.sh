export IDF_PATH=$FW_TARGETDIR/toolchain/esp-idf
export IDF_TOOLS_PATH=$FW_TARGETDIR/toolchain/espressif
export PATH=$PATH:$IDF_TOOLS_PATH/tools/xtensa-esp32-elf/esp-2020r1-8.2.0/xtensa-esp32-elf/bin

pushd $FW_TARGETDIR/build > /dev/null

  make flash $@

popd > /dev/null

