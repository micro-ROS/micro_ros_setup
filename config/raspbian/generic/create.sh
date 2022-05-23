#! /bin/bash

pushd $FW_TARGETDIR/$DEV_WS_DIR >/dev/null
    if [ $PLATFORM == "stretch_v8" ]; then
        TOOLCHAIN_URL="https://sourceforge.net/projects/raspberry-pi-cross-compilers/files/Raspberry%20Pi%20GCC%20Cross-Compiler%20Toolchains/Stretch/GCC%206.3.0/Raspberry%20Pi%203A%2B%2C%203B%2B%2C%204/cross-gcc-6.3.0-pi_3%2B.tar.gz/download"
    elif [ $PLATFORM == "buster_v7" ]; then
        TOOLCHAIN_URL="https://sourceforge.net/projects/raspberry-pi-cross-compilers/files/Raspberry%20Pi%20GCC%20Cross-Compiler%20Toolchains/Buster/GCC%208.3.0/Raspberry%20Pi%202%2C%203/cross-gcc-8.3.0-pi_2-3.tar.gz/download"
    elif [ $PLATFORM == "buster_v8" ]; then
        TOOLCHAIN_URL="https://sourceforge.net/projects/raspberry-pi-cross-compilers/files/Raspberry%20Pi%20GCC%20Cross-Compiler%20Toolchains/Buster/GCC%208.3.0/Raspberry%20Pi%203A%2B%2C%203B%2B%2C%204/cross-gcc-8.3.0-pi_3%2B.tar.gz/download"
    else
        echo "Platform not supported."
        exit 1
    fi
    curl -o xcompiler.tar.gz -L $TOOLCHAIN_URL
    mkdir xcompiler
    tar xf xcompiler.tar.gz -C xcompiler --strip-components 1
    rm xcompiler.tar.gz
popd >/dev/null

pushd $FW_TARGETDIR >/dev/null
    git clone -b humble https://github.com/micro-ROS/raspbian_apps.git
popd >/dev/null