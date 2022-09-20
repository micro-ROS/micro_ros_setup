# README

## Overview

This file is the entry point for building micro-ROS apps for [RT-thread](https://github.com/RT-Thread/rt-thread). RT-Thread was born in 2006, it is an open source, neutral, and community-based real-time operating system (RTOS). Now, it It already supports many architectures and  boards. 

This project comes from   [Open Source Promotion Plan](https://summer-ospp.ac.cn/#/org/prodetail/22f330436) (OSPP) 2022.  The goal is to hope that micrROS can support RT-Thread real-time system.

Now，The publisher and subscriber can be used normally in the RT-Thread system through serial transport.   The publisher  is ok hrough UDP transport and The publisher  has a little [problem](https://github.com/micro-ROS/micro_ros_setup/issues/576). 

## Support

* board:
  * [STMH750-ART-Pi](https://github.com/RT-Thread-Studio/sdk-bsp-stm32h750-realthread-artpi)

* transport：
  * serial
  * UDP
* examples：
  * publisher 
  * subscriber

## Test Environment

* ROS 2 : galactic

* boards： [STMH750-ART-Pi](https://github.com/RT-Thread-Studio/sdk-bsp-stm32h750-realthread-artpi).

* RT-thread: v4.1.1
* example： ping_pong

## Usage

### Creating micro-ROS firmware

```bash
ros2 run micro_ros_setup create_firmware_ws.sh rtthread art-pi
```

### Configuring micro-ROS firmware

```bash
ros2 run micro_ros_setup configure_firmware.sh [app name] [options]
```

Available apps：

- `micro_ros_pub_int32.c`
- `micro_ros_sub_int32.c`
- `micro_ros_pub_sub_int32.c`
- `micro_ros_ping_pong.c`

available options:

- `-d` :  agent string descriptor in a serial-like transport ;
- `-i ` agent IP in a network-like transport   `-p` agent port in a network-like transport ;

for example:

```bash
# serial
ros2 run micro_ros_setup configure_firmware.sh  micro_ros_pub_int32.c -d vcom
# UDP
ros2 run micro_ros_setup configure_firmware.sh micro_ros_pub_int32.c -i 192.168.31.130 -p 9999
```

### Building micro-ROS

```
ros2 run micro_ros_setup build_firmware.sh
```

### Flashing micro-ROS

```
ros2 run micro_ros_setup flash_firmware.sh
```

## Feature

* fix udp bug transport in publisher;
* add service demo;

