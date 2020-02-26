#! /bin/bash

# Install Qemu on the host PC.
sudo apt-get install -y --no-install-recommends qemu-user-static binfmt-support 
update-binfmts --enable qemu-arm 
update-binfmts --display qemu-arm

ROOT_DIR=${PWD}

# Delete previous build.
sudo rm -rf $ROOT_DIR/Micro-ROS-Bridge

#Create the new workspace for the Micro-ROS Agent on the hardware bridge.
mkdir $ROOT_DIR/Micro-ROS-Bridge
cd $ROOT_DIR/Micro-ROS-Bridge
WORK_DIR=${PWD}

# Download the cross-compilation tool
git clone https://github.com/micro-ROS/ros2-performance
cd ros2-performance/cross-compiling

# Set the architecture target and the ROS2 distro which base on.
export TARGET=raspbian && export ROS2_DISTRO=dashing

# Start the cross-compile tools 
bash build.sh
bash automatic_cross_compile.sh

# Copy the result of the cross-compilation work
cp -rf $WORK_DIR/ros2-performance/micro-ros_cc_ws $WORK_DIR

#Download Micro-ROS Hardware Bridge Tool.
cd $WORK_DIR
wget https://raw.githubusercontent.com/micro-ROS/micro-ROS-bridge_RPI/new_bridge_tools/micro-ROS-HB.sh
chmod +wxr micro-ROS-HB.sh

#Delete the cross-compilation tool
rm -rf ros2-performance