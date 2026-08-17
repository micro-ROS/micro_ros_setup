pushd $FW_TARGETDIR >/dev/null
    # Install an architecture-compatible Arm cross-compiler.
    host_arch=$(uname -m)
    case "$host_arch" in
      aarch64|arm64)
        mkdir -p toolchain/bin
        for tool in gcc g++ ar ranlib objcopy size; do
          compiler=$(command -v "arm-none-eabi-${tool}" || true)
          if [ -z "$compiler" ]; then
            echo "Missing arm-none-eabi-${tool}. Install gcc-arm-none-eabi, binutils-arm-none-eabi, libnewlib-arm-none-eabi and libstdc++-arm-none-eabi-newlib." >&2
            exit 1
          fi
          ln -s "$compiler" "toolchain/bin/arm-none-eabi-${tool}"
        done
        echo "Using native $host_arch Arm GNU toolchain: $(readlink -f toolchain/bin/arm-none-eabi-gcc)"
        ;;
      x86_64|amd64)
        mkdir toolchain
        echo "Downloading pinned x86_64 ARM compiler, this may take a while"
        archive=gcc-arm-none-eabi-8-2019-q3-update-linux.tar.bz2
        curl -fsSLO "https://developer.arm.com/-/media/Files/downloads/gnu-rm/8-2019q3/RC1.1/${archive}"
        tar --strip-components=1 -xjf "$archive" -C toolchain
        rm "$archive"
        ;;
      *)
        echo "Unsupported host architecture: $host_arch" >&2
        exit 1
        ;;
    esac

    # Import repos
    vcs import --input $PREFIX/config/$RTOS/$PLATFORM/board.repos

    # ignore broken packages
    touch mcu_ws/ros2/rcl_logging/rcl_logging_spdlog/COLCON_IGNORE
    touch mcu_ws/ros2/rcl/COLCON_IGNORE
    touch mcu_ws/ros2/rosidl/rosidl_typesupport_introspection_cpp/COLCON_IGNORE
    touch mcu_ws/ros2/rcpputils/COLCON_IGNORE
    touch mcu_ws/ros2/ros2_tracing/test_tracetools/COLCON_IGNORE
    touch mcu_ws/uros/rcl/rcl_yaml_param_parser/COLCON_IGNORE
    touch mcu_ws/uros/rclc/rclc_examples/COLCON_IGNORE
    touch mcu_ws/ros2/ros2_tracing/lttngpy/COLCON_IGNORE

popd >/dev/null
