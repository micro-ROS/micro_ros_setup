. $PREFIX/config/utils.sh

if [ $# -ge 1 ]; then
	TOOLCHAIN=$1
else
	echo "Syntax: ros2 run micro_ros_setup build_firmware.sh <CMake toolchain file> [Colcon meta file]"
	exit 1
fi

if [ $# -ge 2 ]; then
	COLCON_META=$2
	echo "Using provided meta: $COLCON_META"

else
	COLCON_META=$FW_TARGETDIR/mcu_ws/colcon.meta
	echo "Using default meta: $COLCON_META"
fi


BUILD_DIR=$FW_TARGETDIR/build

pushd $FW_TARGETDIR/mcu_ws >/dev/null

	rm -rf build install log

	colcon build \
		--merge-install \
		--packages-ignore-regex=.*_cpp \
		--metas $COLCON_META \
		--cmake-args \
		"--no-warn-unused-cli" \
		-DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=OFF \
		-DTHIRDPARTY=ON \
		-DBUILD_SHARED_LIBS=OFF \
		-DBUILD_TESTING=OFF \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN \
		-DCMAKE_VERBOSE_MAKEFILE=ON; \

	mkdir -p $FW_TARGETDIR/libmicroros; cd $FW_TARGETDIR/libmicroros; \
	echo "CREATE libmicroros.a" > $FW_TARGETDIR/libmicroros/ar_script.m; \
	for file in $(find "$FW_TARGETDIR/install/lib/" -name '*.a'); do \
		echo "ADDLIB ${file}" >> $FW_TARGETDIR/libmicroros/ar_script.m; \
	done ; \
	echo "SAVE" >> $FW_TARGETDIR/libmicroros/ar_script.m; \
	echo "END" >> $FW_TARGETDIR/libmicroros/ar_script.m; \
	ar -M < $FW_TARGETDIR/libmicroros/ar_script.m; \
	mkdir -p $BUILD_DIR; cp libmicroros.a $BUILD_DIR; \
	cp -R $FW_TARGETDIR/mcu_ws/install/include $BUILD_DIR/; \
	cd ..; rm -rf libmicroros;

popd >/dev/null
