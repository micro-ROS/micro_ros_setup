
This ROS 2 package is the entry point for building micro-ROS apps for different embedded platforms.

- [Supported platforms](#supported-platforms)
  - [Standalone build system tools](#standalone-build-system-tools)
- [Dependencies](#dependencies)
- [Quick start](#quick-start)
- [Building](#building)
  - [Creating micro-ROS firmware](#creating-micro-ros-firmware)
  - [Configuring micro-ROS firmware](#configuring-micro-ros-firmware)
  - [Building micro-ROS firmware](#building-micro-ros-firmware)
  - [Flashing micro-ROS firmware](#flashing-micro-ros-firmware)
- [Building micro-ROS-Agent](#building-micro-ros-agent)
- [Contributing](#contributing)
- [Purpose of the Project](#purpose-of-the-project)
- [License](#license)
- [Known Issues / Limitations](#known-issues--limitations)
- [Papers](#papers)

# Supported platforms

This package is the **official build system for micro-ROS**. It provides tools and utils to crosscompile micro-ROS with just the common ROS 2 tools for these platforms:

| RTOS                                                                                                                | Platform                                                                                                                                                                                 | Version                      | Example                      |
| ------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------- | ---------------------------- |
| [Azure RTOS](https://azure.microsoft.com/es-es/services/rtos/) / [FreeRTOS](https://www.freertos.org/) / Bare metal | [Renesas RA6M5](https://www.renesas.com/us/en/products/microcontrollers-microprocessors/ra-cortex-m-mcus/ra6m5-200mhz-arm-cortex-m33-trustzone-highest-integration-ethernet-and-can-fde) | Renesas e<sup>2</sup> studio | `renesas_ra ra6m5`           |
| [Nuttx](https://nuttx.org/)                                                                                         | [Olimex STM32-E407](https://www.olimex.com/Products/ARM/ST/STM32-E407/open-source-hardware)                                                                                              | v7.29                        | `nuttx olimex-stm32-e407`    |
| [FreeRTOS](https://www.freertos.org/)                                                                               | [Crazyflie 2.1](https://www.bitcraze.io/crazyflie-2-1/)                                                                                                                                  | v10.2.1 - CF 2020.06         | `freertos crazyflie21`       |
| [FreeRTOS](https://www.freertos.org/)                                                                               | [Olimex STM32-E407](https://www.olimex.com/Products/ARM/ST/STM32-E407/open-source-hardware)                                                                                              | STM32CubeMX latest           | `freertos olimex-stm32-e407` |
| [FreeRTOS](https://www.freertos.org/)                                                                               | [ST Nucleo F446RE](https://www.st.com/en/evaluation-tools/nucleo-f446re.html)  <sup>1</sup>                                                                                              | STM32CubeMX latest           | `freertos nucleo_f446re`     |
| [FreeRTOS](https://www.freertos.org/)                                                                               | [ST Nucleo F446ZE](https://www.st.com/en/evaluation-tools/nucleo-f446ze.html)  <sup>1</sup>                                                                                              | STM32CubeMX latest           | `freertos nucleo_f446ze`     |
| [FreeRTOS](https://www.freertos.org/)                                                                               | [ST Nucleo F746ZG](https://www.st.com/en/evaluation-tools/nucleo-f746zg.html)  <sup>1</sup>                                                                                              | STM32CubeMX latest           | `freertos nucleo_f746zg`     |
| [FreeRTOS](https://www.freertos.org/)                                                                               | [ST Nucleo F767ZI](https://www.st.com/en/evaluation-tools/nucleo-f746zg.html)  <sup>1</sup>                                                                                              | STM32CubeMX latest           | `freertos nucleo_f767zi`     |
| [FreeRTOS](https://www.freertos.org/)                                                                               | [Espressif ESP32](https://www.espressif.com/en/products/socs/esp32/overview)                                                                                                             | v8.2.0                       | `freertos esp32`             |
| [Zephyr](https://www.zephyrproject.org/)                                                                            | [Olimex STM32-E407](https://www.olimex.com/Products/ARM/ST/STM32-E407/open-source-hardware)                                                                                              | v2.6.0                       | `zephyr olimex-stm32-e407`   |
| [Zephyr](https://www.zephyrproject.org/)                                                                            | [ST B-L475E-IOT01A](https://docs.zephyrproject.org/latest/boards/arm/disco_l475_iot1/doc/index.html)                                                                                     | v2.6.0                       | `zephyr discovery_l475_iot1` |
| [Zephyr](https://www.zephyrproject.org/)                                                                            | [ST Nucleo H743ZI](https://www.st.com/en/evaluation-tools/nucleo-h743zi.html) <sup>1</sup>                                                                                               | v2.6.0                       | `zephyr nucleo_h743zi`       |
| [Zephyr](https://www.zephyrproject.org/)                                                                            | [Zephyr emulator](https://docs.zephyrproject.org/2.3.0/boards/posix/native_posix/doc/index.html)                                                                                         | v2.6.0                       | `zephyr host`                |
| -                                                                                                                   | Static library (.a) and headers (.h) <sup>3</sup>                                                                                                                                        | -                            | `generate_lib`               |
| Linux                                                                                                               | *Host <sup>2</sup>*                                                                                                                                                                      | Ubuntu 18.04/20.04           | `host`                       |

*<sup>1</sup> Community supported, may have lack of official support*

*<sup>2</sup> Support for compiling apps in a native Linux host for testing and debugging*

*<sup>3</sup> a valid CMake toolchain with custom crosscompilation definition is required*

## Standalone build system tools

micro-ROS also offers some other ways to crosscompile it for different platforms. These other options are secondary tools and may not have full support for all features. Currently micro-ROS is also available as:

- a standalone **[micro-ROS component for Renesas e<sup>2</sup> studio and RA6M5](https://github.com/micro-ROS/micro_ros_renesas2estudio_component)**: this package enables the integration of micro-ROS in Renesas e<sup>2</sup> studio and RA6M5 MCU family.
- a standalone **[micro-ROS component for ESP-IDF](https://github.com/micro-ROS/micro_ros_espidf_component)**: this package enables the integration of micro-ROS in any Espressif ESP32 IDF project.
- a standalone **[micro-ROS module for Zephyr RTOS](https://github.com/micro-ROS/micro_ros_zephyr_module)**: this package enables the integration of micro-ROS in any Zephyr RTOS workspace.
- a standalone **[micro-ROS module for Mbed RTOS](https://github.com/micro-ROS/micro_ros_mbed)**: this package enables the integration of micro-ROS in any Mbed RTOS workspace.
- a standalone **[micro-ROS module for NuttX RTOS](https://github.com/micro-ROS/micro_ros_nuttx_app)**: this package enables the integration of micro-ROS in any NuttX RTOS workspace.
- a standalone **[micro-ROS module for Microsoft Azure RTOS](https://github.com/micro-ROS/micro_ros_azure_rtos_app)**: this package enables the integration of micro-ROS in a Microsoft Azure RTOS workspace.
- a standalone **[micro-ROS module for RT-Thread RTOS](https://github.com/micro-ROS/micro_ros_rtthread_component)**: this package enables the integration of micro-ROS in a RT-Thread workspace.
- a set of **[micro-ROS utils for STM32CubeMX and STM32CubeIDE](https://github.com/micro-ROS/micro_ros_stm32cubemx_utils)**: this package enables the integration of micro-ROS in STM32CubeMX and STM32CubeIDE.
- a library builder for **[PlatformIO](https://github.com/micro-ROS/micro_ros_platformio)**: this package enables the integration of micro-ROS in PlatformIO.
- a precompiled set of **[Arduino IDE libraries](https://github.com/micro-ROS/micro_ros_arduino)**: this package enables the integration of micro-ROS in the Arduino IDE for some hardware platforms.
- a precompiled set of **[Raspberry Pi Pico SDK libraries](https://github.com/micro-ROS/micro_ros_raspberrypi_pico_sdk)**: this package enables the integration of micro-ROS in the Raspberry Pi Pico SDK.

# Dependencies

This package targets the **ROS 2** installation. ROS 2 supported distributions are:

| ROS 2 Distro | State     | Branch     |
| ------------ | --------- | ---------- |
| Crystal      | EOL       | `crystal`  |
| Dashing      | EOL       | `dashing`  |
| Foxy         | Supported | `foxy`     |
| Galactic     | EOL       | `galactic` |
| Humble       | Supported | `humble`   |
| Rolling      | Supported | `main`     |

Some other prerequisites needed for building a firmware using this package are:

```
sudo apt install python3-rosdep
```
# Quick start

Download [here](https://www.eprosima.com/index.php/downloads-all) the micro-ROS docker image that contains a pre-installed client and agent as well as some compiled examples.

# Building

Create a ROS 2 workspace and build this package for a given ROS 2 distro (see table above):

```bash
source /opt/ros/$ROS_DISTRO/setup.bash

mkdir uros_ws && cd uros_ws

git clone -b $ROS_DISTRO https://github.com/micro-ROS/micro_ros_setup.git src/micro_ros_setup

rosdep update && rosdep install --from-paths src --ignore-src -y

colcon build

source install/local_setup.bash
```

Once the package is built, the firmware scripts are ready to run.

You can find tutorials for moving your first steps with micro-ROS on an RTOS in the [micro-ROS webpage](https://micro-ros.github.io/docs/tutorials/core/first_application_rtos/).


## Creating micro-ROS firmware

Using the `create_firmware_ws.sh [RTOS] [Platform]` command, a firmware folder will be created with the required code for building a micro-ROS app. For example, for our reference platform, the invocation is:

```bash
# Creating a NuttX + micro-ROS firmware workspace
ros2 run micro_ros_setup create_firmware_ws.sh nuttx olimex-stm32-e407

# Creating a FreeRTOS + micro-ROS firmware workspace
ros2 run micro_ros_setup create_firmware_ws.sh freertos olimex-stm32-e407

# Creating a Zephyr + micro-ROS firmware workspace
ros2 run micro_ros_setup create_firmware_ws.sh zephyr olimex-stm32-e407
```

## Configuring micro-ROS firmware

By running `configure_firmware.sh` command the installed firmware is configured and modified in a pre-build step. This command will show its usage if parameters are not provided:

```
ros2 run micro_ros_setup configure_firmware.sh [configuration] [options]
```

By running this command without any argument the available demo applications and configurations will be shown.

Common options available at this configuration step are:
  - `--transport` or `-t`: `udp`, `serial` or any hardware specific transport label
  - `--dev` or `-d`: agent string descriptor in a serial-like transport (optional)
  - `--ip` or `-i`: agent IP in a network-like transport (optional)
  - `--port` or `-p`: agent port in a network-like transport (optional)


Please note that each RTOS has its configuration approach that you might use for further customization of these base configurations. Visit the [micro-ROS webpage](https://micro-ros.github.io/docs/tutorials/core/first_application_rtos/) for detailed information about RTOS configuration.

In summary, the supported configurations for transports are:

|                               |       NuttX        |     FreeRTOS      |       Zephyr       |
| ----------------------------- | :----------------: | :---------------: | :----------------: |
| Olimex STM32-E407             | USB, UART, Network |   UART, Network   |     USB, UART      |
| ST B-L475E-IOT01A             |         -          |         -         | USB, UART, Network |
| Crazyflie 2.1                 |         -          | Custom Radio Link |         -          |
| Espressif ESP32               |         -          |  UART, WiFI UDP   |         -          |
| ST Nucleo F446RE <sup>1</sup> |         -          |       UART        |         -          |
| ST Nucleo F446ZE <sup>1</sup> |         -          |       UART        |         -          |
| ST Nucleo H743ZI <sup>1</sup> |         -          |         -         |        UART        |
| ST Nucleo F746ZG <sup>1</sup> |         -          |       UART        |        UART        |
| ST Nucleo F767ZI <sup>1</sup> |         -          |       UART        |         -          |

*<sup>1</sup> Community supported, may have lack of official support*

## Building micro-ROS firmware

By running `build_firmware.sh` the firmware is built:

```
ros2 run micro_ros_setup build_firmware.sh
```

## Flashing micro-ROS firmware

In order to flash the target platform run `flash_firmware.sh` command.
This step may need some platform-specific procedure to boot the platform in flashing mode:

```
ros2 run micro_ros_setup flash_firmware.sh
```

# Building micro-ROS-Agent

Using this package is possible to install a ready to use **micro-ROS-Agent**:

```
ros2 run micro_ros_setup create_agent_ws.sh
ros2 run micro_ros_setup build_agent.sh
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
- `flash.sh`: flashes the binary in the target platform.

Some other required files inside the folder can be accessed from these scripts using the following paths:

```bash
# Files inside platform folder
$PREFIX/config/$RTOS/$PLATFORM/

# Files inside config folder
$PREFIX/config
```

# Purpose of the Project

This software is not ready for production use. It has neither been developed nor
tested for a specific use case. However, the license conditions of the
applicable Open Source licenses allow you to adapt the software to your needs.
Before using it in a safety relevant setting, make sure that the software
fulfills your requirements and adjust it according to any applicable safety
standards, e.g., ISO 26262.

# License

This repository is open-sourced under the Apache-2.0 license. See the [LICENSE](LICENSE) file for details.

For a list of other open-source components included in ROS 2 system_modes,
see the file [3rd-party-licenses.txt](3rd-party-licenses.txt).

# Known Issues / Limitations

There are no known limitations.

If you find issues, [please report them](https://github.com/micro-ROS/micro_ros_setup/issues).

# Papers

If you want to cite micro-ROS, please cite the following book chapter ([PDF available at Springer Link](https://doi.org/10.1007/978-3-031-09062-2_2)):

Kaiwalya Belsare, Antonio Cuadros Rodriguez, Pablo Garrido Sánchez, Juanjo Hierro, Tomasz Kołcon, Ralph Lange, Ingo Lütkebohle, Alexandre Malki, Jaime Martin Losa, Francisco Melendez, Maria Merlan Rodriguez, Arne Nordmann, Jan Staschulat, and Julian von Mendel: Micro-ROS. In: _Anis Koubaa (ed.) Robot Operating System (ROS): The Complete Reference (Volume 7),_ Springer, pp. 3–55, 2023. (Online since 2 February 2023.)

```bibtex
@INBOOK{Belsare_et_al_2023_Micro-ROS,
  author = {Kaiwalya Belsare and Antonio Cuadros Rodriguez and Pablo Garrido S\'{a}nchez and Juanjo Hierro
            and Tomasz Ko\l{}con and Ralph Lange and Ingo L\"{u}tkebohle and Alexandre Malki
            and Jaime Martin Losa and Francisco Melendez and Maria Merlan Rodriguez and Arne Nordmann
            and Jan Staschulat and and Julian von Mendel},
  title = {Micro-ROS},
  editor = {Anis Koubaa},
  booktitle = {Robot Operating System (ROS): The Complete Reference (Volume 7)},
  year = {2023},
  publisher = {Springer},
  pages = {3--55},
  doi = {10.1007/978-3-031-09062-2_2}
}
```
