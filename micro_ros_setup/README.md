
This ROS 2 package is the entry point for building micro-ROS apps for different embedded platforms.

- [Supported platforms](#supported-platforms)
- [Dependencies](#dependencies)
- [Building](#building)
  - [Creating micro-ROS firmware](#creating-micro-ros-firmware)
  - [Configuring micro-ROS firmware](#configuring-micro-ros-firmware)
  - [Building micro-ROS firmware](#building-micro-ros-firmware)
  - [Flashing micro-ROS firmware](#flashing-micro-ros-firmware)
- [Building micro-ROS Agent](#building-micro-ros-agent)
- [Contributing](#contributing)

# Supported platforms

| RTOS | Platform |  |
|-|-|-|
| [FreeRTOS](https://www.freertos.org/) | [Crazyflie 2.1](https://www.bitcraze.io/crazyflie-2-1/) | `freertos crazyflie21` | 
| [Nuttx](https://nuttx.org/) | *Generic* ** | `nuttx` | 
| Linux / Windows | *Host* * |

*\* Support for compiling apps in native host for testing and debugging*

**\* Configuration for different platforms through configure_firmware.sh*

# Dependencies

This package targets **ROS 2 Dashing** installation. Some other prerequisites needed for building a firmware using this package are:

```
sudo apt install python-rosdep
```

# Building 

Create a ROS 2 workspace and build this package:

```
source /opt/ros/dashing/setup.bash
mkdir uros_ws
cd uros_ws
git clone --recursive -b dashing https://github.com/micro-ROS/micro-ros-build.git src/micro-ros-build
colcon build --packages-select micro_ros_setup
source install/local_setup.bash
```

Once the package is built, the firmware scripts are ready to run.


## Creating micro-ROS firmware

Using `create_firmware_ws.sh [RTOS] [Platform]` command a firmware folder will be created with the required code for building a micro-ROS app. For example, targeting FreeRTOS and Crazyflie 2.1:

```
ros2 run micro_ros_setup create_firmware_ws.sh freertos crazyflie21
```

## Configuring micro-ROS firmware

By running `configure_firmware.sh` command the installed firmware is configured and modified in a pre-build step:

```
ros2 run micro_ros_setup configure_firmware.sh
```

## Building micro-ROS firmware

By running `build_firmware.sh` the firmware is built:

```
ros2 run micro_ros_setup build_firmware.sh
```

## Flashing micro-ROS firmware

In order to flash the target platform run `flash_firmware.sh` command. This step may need some platform specific procedure in order to boot the platform in flashing node: 

```
ros2 run micro_ros_setup flash_firmware.sh
```

# Building micro-ROS Agent

Using this package is possible to install a ready to use **micro-ROS Agent**:

```
ros2 run micro_ros_setup create_agent_ws.sh
colcon build --meta src
source install/local_setup.sh
ros2 run micro_ros_agent micro_ros_agent [parameters]
```

# Contributing

As it is explained along this document, the firmware building system takes **four steps**: creating, configuring, building and flashing.

New combinations of platforms and RTOS are intended to be included in `config` folder. For example, the scripts for building a **micro-ROS** app for **Crazyflie 2.1** using **FreeRTOS** is located in `config/freertos/crazyflie21`.

This folder contains up to four scripts:
- `create.sh`: gets a variable named `$FW_TARGETDIR` and installs in this path all the dependencies and code required for the firmware.
- `configure.sh`: modifies and configure parameters of the installed dependencies. This step is **optional**.
- `build.sh`: builds the firmware and create a platform specific linked binary.
- `flash.sh`: flash the binary in the target platform.
  
Some other required files inside the folder can be accessed from these scripts usigg the following paths:

```bash
# Files inside platform folder
$PREFIX/config/$RTOS/$PLATFORM/

# Files inside config folder
$PREFIX/config
```



If you find issues, [please report them](https://github.com/micro-ROS/micro-ros-build/issues). 

