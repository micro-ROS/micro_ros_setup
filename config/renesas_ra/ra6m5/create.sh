pushd $FW_TARGETDIR >/dev/null
    # # Install toolchain
    # mkdir toolchain

    # # Install toolchain
    # echo "Downloading ARM compiler, this may take a while"
    # curl -fsSLOk https://developer.arm.com/-/media/Files/downloads/gnu-rm/9-2020q2/gcc-arm-none-eabi-9-2020-q2-update-x86_64-linux.tar.bz2
    # tar --strip-components=1 -xvjf gcc-arm-none-eabi-9-2020-q2-update-x86_64-linux.tar.bz2 -C toolchain  > /dev/null
    # rm gcc-arm-none-eabi-9-2020-q2-update-x86_64-linux.tar.bz2

    # Import repos
    vcs import --input $PREFIX/config/$RTOS/$PLATFORM/board.repos

popd >/dev/null