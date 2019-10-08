# DASHING SUPPORT IS WORK IN PROGRESS 

# micro-ROS build support

## Installation and Building

This package contains submodules. Please clone it using

```git clone --recursive ...```

Building this package requires that you have [ROS 2 Crystal](https://index.ros.org/doc/ros2/Installation/Crystal/) installed first.

## micro_ros_setup

Support scripts for creating Micro-ROS agent and client workspaces,
and cleanly doing cross-compilation.

See [micro_ros_setup README](micro_ros_setup/README.md) for usage instructions.

## micro_ros_cmake

This is a Work-in-Progress package that aims to add
CMake macros and vendor packages for building micro-ROS.
This should make it even easier to create applications.

See [micro_ros_cmake README](micro_ros_cmake/README.md) for more info.


## Purpose of the project

The software is not ready for production use. It has neither been developed nor tested for a specific use case. However, the license conditions of the applicable Open Source licenses allow you to adapt the software to your needs. Before using it in a safety relevant setting, make sure that the software fulfills your requirements and adjust it according to any applicable safety standards (e.g. ISO 26262).

## License

micro-ros-build is open-sourced under the Apache-2.0 license. See the [LICENSE](LICENSE) file for details.

micro-ros-build does not include other open source components, but uses some at compile time. See the file [3rd-party-licenses.txt](3rd-party-licenses.txt) for a detailed description.


## Known issues/limitations

 * There are currently sometimes compile issues when building the firmware for the first time. When building it a second time, this disappear. It it not known why this happens, we're investigating it.
