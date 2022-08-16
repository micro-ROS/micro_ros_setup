#! /bin/bash

set -e
set -o nounset
set -o pipefail

export FW_TARGETDIR=$(pwd)/firmware
export PREFIX=$(ros2 pkg prefix micro_ros_setup)

# Checking if firmware exists
if [ -d $FW_TARGETDIR ]; then
    RTOS=$(head -n1 $FW_TARGETDIR/PLATFORM)
    PLATFORM=$(head -n2 $FW_TARGETDIR/PLATFORM | tail -n1)
else
    echo "Firmware folder not found. Please use ros2 run micro_ros_setup create_firmware_ws.sh to create a new project."
    exit 1
fi

# Check if configure script exists
if [ -d "$PREFIX/config/$RTOS/generic" ]; then
    if [ ! -f $PREFIX/config/$RTOS/generic/configure.sh ]; then
        echo "No configuration step needed for generic platform $PLATFORM"
        exit 0
    fi
else
    if [ ! -f $PREFIX/config/$RTOS/$PLATFORM/configure.sh ]; then
        echo "No configuration step needed for $RTOS platform $PLATFORM"
        exit 0
    fi
fi

# Parsing micro-ROS arguments
if [ $# -lt 1 ]; then
  echo "micro-ROS application name must be provided: ros2 run micro_ros_setup configure_firmware.sh [app name] [options]"
  # Check if RTOS has app listing funcions and source in case
  if [ -f $PREFIX/config/$RTOS/list_apps.sh ]; then
      . $PREFIX/config/$RTOS/list_apps.sh
      print_available_apps
  fi
  exit 1
fi

if [ -f $PREFIX/config/$RTOS/list_apps.sh ]; then
    . $PREFIX/config/$RTOS/list_apps.sh
    check_available_app $1
fi

export CONFIG_NAME=$1
shift

while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
      -t|--transport)
      export UROS_TRANSPORT="$2"
      shift # past argument
      shift # past value
      ;;
      -d|--dev)
      export UROS_AGENT_DEVICE="$2"
      shift # past argument
      shift # past value
      ;;
      -i|--ip)
      export UROS_AGENT_IP="$2"
      shift # past argument
      shift # past value
      ;;
      -p|--port)
      export UROS_AGENT_PORT="$2"
      shift # past argument
      shift # past value
      ;;
      *)    # unknown option
      echo "Unknown argument  $1"
      exit 1
      ;;
  esac
done

# Configure specific firmware folder if needed
if [ -d "$PREFIX/config/$RTOS/generic" ]; then
    echo "Configuring firmware for $RTOS platform $PLATFORM"
    exec $PREFIX/config/$RTOS/generic/configure.sh $@
else
    echo "Configuring firmware for $RTOS platform $PLATFORM"
    exec $PREFIX/config/$RTOS/$PLATFORM/configure.sh $@
fi

