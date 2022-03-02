CMAKE_VERSION_NUMBER=$(cmake --version | grep "[0-9]*\.[0-9]*\.[0-9]*" | cut -d ' ' -f 3)
CMAKE_VERSION_MAJOR_NUMBER=$(echo $CMAKE_VERSION_NUMBER | cut -d '.' -f 1)
CMAKE_VERSION_MINOR_NUMBER=$(echo $CMAKE_VERSION_NUMBER | cut -d '.' -f 2)
CMAKE_VERSION_PATCH_NUMBER=$(echo $CMAKE_VERSION_NUMBER | cut -d '.' -f 3)

if ! (( $CMAKE_VERSION_MAJOR_NUMBER > 3 || \
    $CMAKE_VERSION_MAJOR_NUMBER == 3 && $CMAKE_VERSION_MINOR_NUMBER > 19 || \
    $CMAKE_VERSION_MAJOR_NUMBER == 3 && $CMAKE_VERSION_MINOR_NUMBER == 19 && $CMAKE_VERSION_PATCH_NUMBER >= 0 )); then
    echo "Error: installed CMake version must be equal or greater than 3.19.0."
    echo "Your current version is $CMAKE_VERSION_NUMBER."
    echo "Please if not installed follow the instructions: https://apt.kitware.com/"
    exit 1
fi

export PATH=~/.local/bin:"$PATH"

pushd $FW_TARGETDIR >/dev/null

    pip3 install mbed-tools

    # Import repos
    vcs import --input $PREFIX/config/$RTOS/generic/board.repos

    pushd micro_ros_mbed >/dev/null
        echo https://github.com/ARMmbed/mbed-os/\#mbed-os-6.10.0 > mbed-os.lib
        mbed-tools deploy
    popd >/dev/null

    # TODO (pablogs): Avoid current approach and rely on the standalone module
    # rm -rf dev_ws mcu_ws
popd >/dev/null
