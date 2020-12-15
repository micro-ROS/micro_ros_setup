#! /bin/bash

pushd $FW_TARGETDIR/mcu_ws >/dev/null
    source app_info.sh
    PATH=$PWD/../dev_ws/xcompiler/bin:$PATH
    LD_LIBRARY_PATH=$PWD/../dev_ws/xcompiler/lib:$PWD/../dev_ws/xcompiler/arm-linux-gnueabihf/lib
    colcon build --packages-up-to=$APP_PACKAGE_NAME --merge-install --cmake-force-configure \
        --packages-ignore-regex=.*_cpp \
        --cmake-args \
            -DCMAKE_TOOLCHAIN_FILE=$PWD/toolchain.cmake \
            -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
            -DBUILD_SHARED_LIBS=OFF \
            -DBUILD_TESTING=OFF \
            "--no-warn-unused-cli"
    find ./install -executable -type f -name $APP_BINARY_NAME -exec cp {} $FW_TARGETDIR/bin/$APP_OUTPUT_NAME \;
popd >/dev/null