. $PREFIX/config/utils.sh

function help {
      echo "Configure script need an argument."
      echo "app -d|--dev  device"
	  echo "app -i|--ip IP -p|--port port"
}

# if [ "$UROS_AGENT_DEVICE" ]; then
# 	echo $UROS_AGENT_DEVICE

# elif [ "$UROS_AGENT_IP" ] && [ "$UROS_AGENT_PORT" ]; then 
# 	echo $UROS_AGENT_IP
# 	echo $UROS_AGENT_PORT
# else
# 	help

# fi
# exit 1

update_meta "microxrcedds_client" "UCLIENT_PROFILE_CUSTOM_TRANSPORT=ON"
update_meta "microxrcedds_client" "UCLIENT_PROFILE_STREAM_FRAMING=ON"
update_meta "microxrcedds_client" "UCLIENT_PROFILE_SERIAL=OFF"
update_meta "microxrcedds_client" "UCLIENT_PROFILE_UDP=OFF"
update_meta "microxrcedds_client" "UCLIENT_PROFILE_TCP=OFF"

update_meta "rmw_microxrcedds" "RMW_UXRCE_TRANSPORT=custom"

# add macro definition for  cconfig.h
RTT_PROJECT=$FW_TARGETDIR/sdk-bsp-stm32h750-realthread-artpi/projects/art_pi_wifi
RTCONIF=rtconfig.h

pushd $RTT_PROJECT >/dev/null



	if [ "$UROS_AGENT_DEVICE" ]; then
		# modify rtconfig.h
		UROS_AGENT_DEVICE="${UROS_AGENT_DEVICE}" 
		cp micro-ROS-rtthread-app/rtconfig.h 							$RTCONIF
		echo "Using serial device."
		echo "add macro definition for  rtconfig.h."
		sed -i '$i #define USING_MICROROS ' 							$RTCONIF
		sed -i '$i #define MICROROS_SERIAL ' 							$RTCONIF
		sed -i '$i #define MICROROS_DEVIVE '\"${UROS_AGENT_DEVICE}\"'' 	$RTCONIF

		echo "add macro: USING_MICROROS; MICROROS_SERIAL;"
		echo "add macro: MICROROS_DEVIVE \"${UROS_AGENT_DEVICE}\" "
		
	elif [ "$UROS_AGENT_IP" ] && [ "$UROS_AGENT_PORT" ]; then
		cp micro-ROS-rtthread-app/rtconfig.h 							$RTCONIF
		echo "Using udp device."
		echo "add macro definition for  cconfig.h."
		sed -i '$i #define USING_MICROROS ' 							$RTCONIF
		sed -i '$i #define MICROROS_UDP ' 								$RTCONIF
		sed -i '$i #define MICROROS_IP '\"$UROS_AGENT_IP\"' ' 			$RTCONIF
		sed -i '$i #define MICROROS_PORT '$UROS_AGENT_PORT' ' 			$RTCONIF

		echo "add macro: USING_MICROROS; MICROROS_UDP; "
		echo "add macro: MICROROS_IP \"$UROS_AGENT_IP\""
		echo "add macro:  MICROROS_PORT $UROS_AGENT_PORT"
	else
		help
		exit 1
	fi
	
	if [ "$CONFIG_NAME" == "micro_ros_pub_int32.c" ]; then
		sed -i '$i #define MICROS_EXAMPLE_PUB_INT32 ' 	$RTCONIF
		echo "add macro: MICROS_EXAMPLE_PUB_INT32 "
	elif [ "$CONFIG_NAME" == "micro_ros_sub_int32.c" ]; then
		sed -i '$i #define MICROS_EXAMPLE_SUB_INT32 ' 	$RTCONIF
		echo "add macro: define MICROS_EXAMPLE_SUB_INT32 "
	elif [ "$CONFIG_NAME" == "micro_ros_pub_sub_int32.c" ]; then
		sed -i '$i #define MICROS_EXAMPLE_PUB_SUB_INT32 ' 	$RTCONIF
		echo "add macro:define MICROS_EXAMPLE_PUB_SUB_INT32 "
	elif [ "$CONFIG_NAME" == "micro_ros_ping_pong.c" ]; then
		sed -i '$i #define MICROS_EXAMPLE_PING_PONG ' 	$RTCONIF
		echo "add macro:define MICROS_EXAMPLE_PING_PONG "
	else
		help
		exit 1
	fi

	sed -i '21c source "micro-ROS-rtthread-app/Kconfig" ' 	Kconfig
	echo 'add source :  source "micro-ROS-rtthread-app/Kconfig" --> Kconfig'
popd >/dev/null
