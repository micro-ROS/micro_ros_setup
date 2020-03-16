
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

| RTOS | Platform | Example |
|-|-|-|
| [Nuttx](https://nuttx.org/) | Olimex STM32-E407, STM32F4Discovery ** | `nuttx olimex-stm32-e407` | 
| [FreeRTOS](https://www.freertos.org/) | [Crazyflie 2.1](https://www.bitcraze.io/crazyflie-2-1/) | `freertos crazyflie21` | 
| [FreeRTOS](https://www.freertos.org/) | [Olimex STM32-E407](https://www.olimex.com/Products/ARM/ST/STM32-E407/open-source-hardware) | `freertos olimex-stm32-e407` | 
| [FreeRTOS](https://www.freertos.org/) | host | `freertos host` | 
| [Zephyr](https://www.zephyrproject.org/) | [Olimex STM32-E407](https://www.olimex.com/Products/ARM/ST/STM32-E407/open-source-hardware) | `zephyr olimex-stm32-e407` | 
| [Zephyr](https://www.zephyrproject.org/) | [ST B-L475E-IOT01A](https://docs.zephyrproject.org/latest/boards/arm/disco_l475_iot1/doc/index.html) | `zephyr discovery_l475_iot1` | 
| Linux / Windows | *Host* * |

Please note that NuttX with Olimex STM32-E407 board is the reference platform and not everything might be supported on other platforms.

*\* Support for compiling apps in a native host for testing and debugging*

**\* Configuration for different platforms through configure_firmware.sh*

# Dependencies

This package targets **ROS 2** installation. ROS 2 supported distributions are:

| ROS 2 Distro | State | Branch |
|-|-|-|
| Crystal | Supported | `crystal` |
| Dashing | Supported | `dashing` |
| Eloquent | *Work in progress* |  |

Some other prerequisites needed for building a firmware using this package are:

```
sudo apt install python-rosdep
```

# Building 

Create a ROS 2 workspace and build this package for a given ROS 2 distro (see table above):

```bash
source /opt/ros/$ROS_DISTRO/setup.bash

mkdir uros_ws && cd uros_ws

git clone -b $ROS_DISTRO https://github.com/micro-ROS/micro-ros-build.git src/micro-ros-build

rosdep update && rosdep install --from-path src --ignore-src -y

colcon build

source install/local_setup.bash
```

Once the package is built, the firmware scripts are ready to run.


## Creating micro-ROS firmware

Using `create_firmware_ws.sh [RTOS] [Platform]` command a firmware folder will be created with the required code for building a micro-ROS app. For example, for our reference platform, the invocation is:

```bash
# Creating a Nuttx + micro-ROS firmware workspace
ros2 run micro_ros_setup create_firmware_ws.sh nuttx olimex-stm32-e407

# Creating a FreeRTOS + micro-ROS firmware workspace
ros2 run micro_ros_setup create_firmware_ws.sh freertos olimex-stm32-e407
```

## Configuring micro-ROS firmware

By running `configure_firmware.sh` command the installed firmware is configured and modified in a pre-build step. Usually this command will show its usage if parameters are required:

```
ros2 run micro_ros_setup configure_firmware.sh [configuration] [options]
```

For NuttX, several different configurations are supported.

| NuttX Configuration | Features |
|-|-|
| uros |  Micro-ROS publisher & subscriber, Kobuki demo |
| drive_base | Kobuki demo |
| pingpong | Round-Trip-Time test over serial |
| pingpong-eth | Round-Trip-Time test over Ethernet |

Please note that these are only default configurations. Each RTOS has its configuration approach that you might use for further customization of these base configurations.

Common options available at this configuration step are:
  - `--transport` or `-t`: `udp`, `tcp`, `serial` or any hardware specific transport label
  - `--dev` or `-d`: agent string descriptor in a serial-like transport
  - `--ip` or `-i`: agent IP in a network-like transport
  - `--port` or `-p`: agent port in a network-like transport

## Building micro-ROS firmware

By running `build_firmware.sh` the firmware is built:

```
ros2 run micro_ros_setup build_firmware.sh
```

## Flashing micro-ROS firmware

In order to flash the target platform run `flash_firmware.sh` command. This step may need some platform-specific procedure in order to boot the platform in flashing node:

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
- `build.sh`: builds the firmware and create a platform-specific linked binary.
- `flash.sh`: flash the binary in the target platform.
  
Some other required files inside the folder can be accessed from these scripts using the following paths:

```bash
# Files inside platform folder
$PREFIX/config/$RTOS/$PLATFORM/

# Files inside config folder
$PREFIX/config
```



If you find issues, [please report them](https://github.com/micro-ROS/micro-ros-build/issues). 

