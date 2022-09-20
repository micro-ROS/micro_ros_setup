. $PREFIX/config/utils.sh

MICROROS_DIR=$FW_TARGETDIR/sdk-bsp-stm32h750-realthread-artpi/projects/art_pi_wifi/micro-ROS-rtthread-app/microros
BUILD_DIR=$MICROROS_DIR/build
RTTHREAD_DIR=$FW_TARGETDIR/sdk-bsp-stm32h750-realthread-artpi/projects/art_pi_wifi
COLCON_META=$FW_TARGETDIR/mcu_ws/colcon.meta

X_CC=$FW_TARGETDIR/gcc-arm-none-eabi-5_4-2016q3/bin/arm-none-eabi-gcc
X_CXX=$FW_TARGETDIR/gcc-arm-none-eabi-5_4-2016q3/bin/arm-none-eabi-g++
CFLAGS_INTERNAL="-mcpu=cortex-m7 -mthumb -mfpu=fpv5-d16 -mfloat-abi=hard -ffunction-sections -fdata-sections -Dgcc -O2 -gdwarf-2 -g -std=c99"
CXXFLAGS_INTERNAL="-mcpu=cortex-m7 -mthumb -mfpu=fpv5-d16 -mfloat-abi=hard -ffunction-sections -fdata-sections -Dgcc -O2 -gdwarf-2 -g"

#Set up the cross-compilation chain
ESCAPED_CFLAGS_INTERNAL=$(echo $CFLAGS_INTERNAL | sed 's/\//\\\//g' | sed 's/"//g')
ESCAPED_CXXFLAGS_INTERNAL=$(echo $CXXFLAGS_INTERNAL | sed 's/\//\\\//g' | sed 's/"//g')
ESCAPED_X_CC=$(echo $X_CC | sed 's/\//\\\//g' | sed 's/"//g')
ESCAPED_X_CXX=$(echo $X_CXX | sed 's/\//\\\//g' | sed 's/"//g')

cat $MICROROS_DIR/toolchain.cmake.in | \
    sed "s/@CMAKE_C_COMPILER@/$ESCAPED_X_CC/g" | \
    sed "s/@CMAKE_CXX_COMPILER@/$ESCAPED_X_CXX/g" | \
    sed "s/@CFLAGS@/$ESCAPED_CFLAGS_INTERNAL/g" | \
    sed "s/@CXXFLAGS@/$ESCAPED_CXXFLAGS_INTERNAL/g" \
    > $MICROROS_DIR/toolchain.cmake

#for rtthread 
sed -i "27c EXEC_PATH   =r'$FW_TARGETDIR\/gcc-arm-none-eabi-5_4-2016q3\/bin\/'" $RTTHREAD_DIR/rtconfig.py


pushd $FW_TARGETDIR/mcu_ws >/dev/null
    rm -rf build install log

	colcon build							\
		--merge-install						\
		--packages-ignore-regex=.*_cpp  	\
		--metas ${COLCON_META} \
		--cmake-args 						\
		"--no-warn-unused-cli" 				\
		-DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=OFF 	\
		-DTHIRDPARTY=ON 					\
		-DBUILD_SHARED_LIBS=OFF 			\
		-DBUILD_TESTING=OFF					\
		-DCMAKE_BUILD_TYPE=Debug 			\
		-DCMAKE_TOOLCHAIN_FILE=$MICROROS_DIR/toolchain.cmake	 	\
		-DCMAKE_VERBOSE_MAKEFILE=ON  		\

    
    mkdir -p $FW_TARGETDIR/libmicroros; cd $FW_TARGETDIR/libmicroros;

    for file in $(find $FW_TARGETDIR/mcu_ws/install/lib/ -name '*.a'); do \
		folder=$(echo $file | sed -E "s/(.+)\/(.+).a/\2/"); \
		mkdir -p $folder; cd $folder; ar x $file; \
		for f in *; do \
			mv $f ../$folder-$f; \
		done; \
		cd ..; rm -rf $folder; \
	done ; \
	ar rc libmicroros.a $(ls *.o *.obj 2> /dev/null); mkdir -p $BUILD_DIR; cp libmicroros.a $BUILD_DIR; \
    cp -R $FW_TARGETDIR/mcu_ws/install/include $BUILD_DIR/; \
	cd ..; rm -rf libmicroros;   
popd >/dev/null

# build for rtthread
# modify build/rmw/types.h
pushd $BUILD_DIR >/dev/null
if ([ -d include ]); then
	
	sed -i 's/# define RMW_DECLARE_DEPRECATED(name, msg) name __attribute__((deprecated(msg)))/# define RMW_DECLARE_DEPRECATED(name, msg) name/g' include/rmw/types.h

fi
popd >/dev/null
# build for rtthread
pushd $RTTHREAD_DIR >/dev/null

	scons --target=vsc
	scons

	echo "build successful."
	echo "Using project: $RTTHREAD_DIR"
	
popd >/dev/null


