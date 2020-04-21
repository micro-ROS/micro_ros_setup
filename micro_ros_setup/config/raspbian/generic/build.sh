#! /bin/bash

pushd $FW_TARGETDIR/mcu_ws >/dev/null
    PATH=$PWD/../dev_ws/xcompiler/bin:$PATH
    LD_LIBRARY_PATH=$PWD/../dev_ws/xcompiler/lib:$PWD/../dev_ws/xcompiler/arm-linux-gnueabihf/lib
    colcon build --merge-install --cmake-force-configure \
        --cmake-args \
            -DCMAKE_TOOLCHAIN_FILE=$PWD/toolchain.cmake \
            -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
            -DBUILD_SHARED_LIBS=OFF \
            -DBUILD_TESTING=OFF
popd >/dev/null