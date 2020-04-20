#! /bin/bash

pushd $FW_TARGETDIR/mcu_ws >/dev/null
    PATH=$PWD/../dev_ws/xcompiler/bin:$PATH
    LD_LIBRARY_PATH=$PWD/../dev_ws/xcompiler/lib:$LD_LIBRARY_PATH
    colcon build --merge-install --cmake-args -DCMAKE_TOOLCHAIN_FILE=$PWD/toolchain.cmake
popd >/dev/null