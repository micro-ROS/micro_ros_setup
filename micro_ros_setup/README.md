# micro-ros-setup

This package assists with setting up the workspaces for Micro-ROS to compile from source, which is currently the recommended way to install Micro-ROS.

This version of the package targets  **ROS 2 Crystal**

Micro-ROS is a client-server system: The embedded micro-controller runs the client, and the "agent" runs on Linux (or potentially also Windows, though this package doesn't support that, yet).

All subsequent instructions assume that you're running them in a colcon workspace. If you haven't used colcon, yet, you can probably just copy the instructions below as-is. I recommend [getting familiar with colcon](https://index.ros.org//doc/ros2/Tutorials/Colcon-Tutorial/), though, it has many useful options.

I use `$` as the command prompt -- don't type it in ;-)

## Building this package

```shell
$ colcon build --packages-select micro_ros_setup
$ source install/local_setup.bash
```

### Building and starting a Micro-ROS agent

```shell
$ ros2 run micro_ros_setup create_agent_ws.sh  # add agent packages
$ colcon build
$ source install/local_setup.sh
```

Note that, by default, the `create_agent_ws.sh` used below will add the packages to the `src` directory. This is easiest, but you can also create a separate workspace by giving it an argument, if you wish.


### Building the client (aka firmware)

```shell
$ ros2 run micro_ros_setup create_firmeware_ws.sh
$ cd firmware/NuttX
$ tools/configure.sh configs/olimex-stm32-e407/drive_base # FOR EXAMPLE!
$ cd ../..
$ ros2 run micro_ros_setup build_firmware.sh
```

These commands create the firmware workspace and then configure an example NuttX build that uses Micro-ROS.