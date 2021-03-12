. $PREFIX/config/utils.sh

export PATH=~/.local/bin:"$PATH"

pushd $FW_TARGETDIR >/dev/null
    
    pushd micro_ros_mbed >/dev/null
        mbed-tools compile -m DISCO_L475VG_IOT01A -t GCC_ARM -f
    popd >/dev/null

popd >/dev/null
