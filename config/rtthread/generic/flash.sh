pushd $FW_TARGETDIR > /dev/null

RTTHREAD_DIR=$FW_TARGETDIR/sdk-bsp-stm32h750-realthread-artpi/projects/art_pi_wifi
STLDR_DIR=$FW_TARGETDIR/sdk-bsp-stm32h750-realthread-artpi/debug/stldr/ART-Pi_W25Q64.stldr

# check STM32CubeProgrammer
if [ -d "/usr/local/STMicroelectronics/STM32Cube/STM32CubeProgrammer/bin" ]; then
    echo "add environment variable for STM32CubeProgrammer"
    export PATH=/usr/local/STMicroelectronics/STM32Cube/STM32CubeProgrammer/bin:$PATH
else
    echo "Please install STM32CubeProgrammer from https://www.st.com/en/development-tools/stm32cubeprog.html"
    exit 1
fi
# check executable file 
if [ -f "$RTTHREAD_DIR/rtthread.bin" ]; then 
    
    STM32_Programmer_CLI -c port=swd -w "$RTTHREAD_DIR/rtthread.bin" 0x90000000 -v -el  $STLDR_DIR
else
    echo "Error: $RTTHREAD_DIR/rtthread.bin not found. Please compile before flashing."
    exit 1
fi
popd > /dev/null
