
This ROS 2 package is the entry point for building micro-ROS apps for different embedded platforms.

- [Supported platforms](#supported-platforms)
- [Dependencies](#dependencies)
- [Building](#building)
  - [Creating micro-ROS firmware](#creating-micro-ros-firmware)
  - [Configuring micro-ROS firmware](#configuring-micro-ros-firmware)
  - [Building micro-ROS firmware](#building-micro-ros-firmware)
  - [Flashing micro-ROS firmware](#flashing-micro-ros-firmware)
- [Building micro-ROS-Agent](#building-micro-ros-agent)
- [Contributing](#contributing)

# Supported platforms

| RTOS | Platform | Example |
|-|-|-|
| [Nuttx](https://nuttx.org/) | Olimex STM32-E407, STM32F4Discovery ** | `nuttx olimex-stm32-e407` | 
| [FreeRTOS](https://www.freertos.org/) | [Crazyflie 2.1](https://www.bitcraze.io/crazyflie-2-1/) | `freertos crazyflie21` | 
| [FreeRTOS](https://www.freertos.org/) | [Olimex STM32-E407](https://www.olimex.com/Products/ARM/ST/STM32-E407/open-source-hardware) | `freertos olimex-stm32-e407` | 
| [Zephyr](https://www.zephyrproject.org/) | [Olimex STM32-E407](https://www.olimex.com/Products/ARM/ST/STM32-E407/open-source-hardware) | `zephyr olimex-stm32-e407` | 
| [Zephyr](https://www.zephyrproject.org/) | [ST B-L475E-IOT01A](https://docs.zephyrproject.org/latest/boards/arm/disco_l475_iot1/doc/index.html) | `zephyr discovery_l475_iot1` | 
| [Zephyr](https://www.zephyrproject.org/) | host | `zephyr host` | 
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
# Creating a NuttX + micro-ROS firmware workspace
ros2 run micro_ros_setup create_firmware_ws.sh nuttx olimex-stm32-e407

# Creating a FreeRTOS + micro-ROS firmware workspace
ros2 run micro_ros_setup create_firmware_ws.sh freertos olimex-stm32-e407

# Creating a Zephyr + micro-ROS firmware workspace
ros2 run micro_ros_setup create_firmware_ws.sh zephyr olimex-stm32-e407
```

## Configuring micro-ROS firmware

By running `configure_firmware.sh` command the installed firmware is configured and modified in a pre-build step. Usually this command will show its usage if parameters are required:

```
ros2 run micro_ros_setup configure_firmware.sh [configuration] [options]
```

The following table shows the available configurations for each RTOS/platform.
For more information please visit the links.

<table>
    <thead>
        <tr>
            <th>RTOS</th>
            <th>Plafrom</th>
            <th>Configuration</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan=4>nuttx</td>
            <td rowspan=4>olimex-stm32-e407</td>
            <td><a href="https://github.com/micro-ROS/micro-ROS_kobuki_demo">drive_base</a></td>
        </tr>
        <tr>
            <td><a href="https://github.com/micro-ROS/micro-ROS-rtt">pingpong</a></td>
        </tr>
        <tr>
            <td><a href="https://github.com/micro-ROS/micro-ROS-rtt">pingpong-eth</a></td>
        </tr>
        <tr>
            <td>uros</td>
        </tr>
        <tr>
            <td rowspan=6>freertos</td>
            <td rowspan=2>crazyflie21</td>
            <td><a href="https://github.com/micro-ROS/freertos_apps/blob/dashing/apps/crazyflie_position_publisher/app.c">crazyflie_position_publisher</a></td>
        </tr>
        <tr>
            <td><a href="https://github.com/micro-ROS/freertos_apps/blob/dashing/apps/crazyflie_uros_sample/app.c">crazyflie_uros_sample</a></td>
        </tr>
        <tr>
            <td rowspan=4>olimex-stm32-e407</td>
            <td><a href="https://github.com/micro-ROS/freertos_apps/blob/dashing/apps/add_two_ints/app.c">add_two_ints</a></td>
        </tr>
        <tr>
            <td><a href="https://github.com/micro-ROS/freertos_apps/blob/dashing/apps/ping_pong/app.c">ping_pong</a></td>
        </tr>
        <tr>
            <td><a href="https://github.com/micro-ROS/freertos_apps/blob/dashing/apps/olimex_uros_sample/app.c">olimex_uros_sample</a></td>
        </tr>
        <tr>
            <td><a href="https://github.com/micro-ROS/freertos_apps/blob/dashing/apps/int32_publisher/app.c">int32_publisher</a></td>
        </tr>
        <tr>
            <td rowspan=7>zephyr</td>
            <td rowspan=4>discovery_l475_iot1</td>
            <td><a href="https://github.com/micro-ROS/zephyr_apps/blob/dashing/apps/ping_pong/src/main.c">ping_pong</a></td>
        </tr>
        <tr>
            <td><a href="https://github.com/micro-ROS/zephyr_apps/blob/dashing/apps/int32_publisher/src/main.c">int32_publisher</a></td>
        </tr>
        <tr>
            <td><a href="https://github.com/micro-ROS/zephyr_apps/blob/dashing/apps/sensors_publisher/src/main.c">sensors_publisher</a></td>
        </tr>
        <tr>
            <td><a href="https://github.com/micro-ROS/zephyr_apps/blob/dashing/apps/tof_ws2812/src/main.c">tof_ws2812</a></td>
        </tr>
        <tr>
            <td rowspan=3>olimex-stm32-e407</td>
            <td><a href="https://github.com/micro-ROS/zephyr_apps/blob/dashing/apps/ping_pong/src/main.c">ping_pong</a></td>
        </tr>
        <tr>
            <td><a href="https://github.com/micro-ROS/zephyr_apps/blob/dashing/apps/int32_publisher/src/main.c">int32_publisher</a></td>
        </tr>
        <tr>
            <td><a href="https://github.com/micro-ROS/zephyr_apps/blob/dashing/apps/vl53l1x_tof_sensor/src/main.c">vl53l1x_tof_sensor</a></td>
        </tr>
    </tbody>
</table>

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

In order to flash the target platform run `flash_firmware.sh` command.
This step may need some platform-specific procedure to boot the platform in flashing node:

```
ros2 run micro_ros_setup flash_firmware.sh
```

# Building micro-ROS-Agent

By using this package, it is possible to install a ready to use **micro-ROS-Agent**:

```
ros2 run micro_ros_setup create_agent_ws.sh
colcon build --meta src
source install/local_setup.sh
ros2 run micro_ros_agent micro_ros_agent [parameters]
```

# Building micro-ROS Hardware Bridge software

The package below will return a set of tools which are required to set-up the micro-ROS Hardware Bridge.

```
ros2 run micro_ros_setup create_bridge_tools.sh
```

This package could take more than an hour to finish the build process, but in later executions, this time will be reduced to around 5~10 minutes.
Once the process is finished, it will return a folder on which contains the next:
- micro-ROS Agent for ARM.
- micro-ROS-HB: This is a script that simplifies the configuration of the hardware bridge and the usage of micro-ROS Agent on the device.

You can find detail information about how to set-up the micro-ROS Hardware Bridge on the next document: [micro-ROS Hardware Bridge Set-up](https://github.com/micro-ROS/micro-ROS-bridge_RPI/blob/new_bridge_tools/Readme.md)


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
