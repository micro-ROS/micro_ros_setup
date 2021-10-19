. $PREFIX/config/utils.sh

if [ $# -ge 1 ]; then
    TOOLCHAIN=$1
else
    echo "Syntax: ros2 run micro_ros_setup build_firmware.sh <CMake toolchain file> [Colcon meta file]"
    exit 1
fi

if [ $# -ge 2 ]; then
    COLCON_META=$2
	  echo "Using provided meta: $COLCON_META"

else
    COLCON_META=$FW_TARGETDIR/mcu_ws/colcon.meta
	  echo "Using default meta: $COLCON_META"
fi


BUILD_DIR=$FW_TARGETDIR/build

pushd $FW_TARGETDIR/mcu_ws >/dev/null

# Set these variables according to your own environment.
if [ -z ${ANDROID_ABI+x} ]; then
    ANDROID_ABI=arm64-v8a
fi
if [ -z ${ANDROID_NATIVE_API_LEVEL+x} ]; then
    ANDROID_NATIVE_API_LEVEL=android-30
fi
if [ -z ${ANDROID_NDK+x} ]; then
    ANDROID_NDK=~/android-ndk-r23
fi

# rm -rf build install log

colcon build --packages-up-to micro_ros_demos_rclc \
    --merge-install \
    --packages-ignore-regex=.*_cpp \
    --metas $COLCON_META \
    --cmake-args \
    "--no-warn-unused-cli" \
    -DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=OFF \
    -DBUILD_SHARED_LIBS=ON \
    -DCMAKE_TOOLCHAIN_FILE=${ANDROID_NDK}/build/cmake/android.toolchain.cmake \
    -DCMAKE_FIND_ROOT_PATH_MODE_PACKAGE=BOTH \
    -DANDROID_FUNCTION_LEVEL_LINKING=OFF \
    -DANDROID_NATIVE_API_LEVEL=${ANDROID_NATIVE_API_LEVEL} \
    -DANDROID_STL=c++_shared \
    -DANDROID_ABI=${ANDROID_ABI} \
    -DANDROID_NDK=${ANDROID_NDK} \
    -DANDROID=ON \
    -DTHIRDPARTY=ON \
    -DBUILD_TESTING=OFF \
    -DBUILD_MEMORY_TOOLS=OFF \
    -DBUILD_MEMORY_TESTS=OFF \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON

popd >/dev/null

