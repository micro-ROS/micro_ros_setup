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
	for file in $(find $FW_TARGETDIR/mcu_ws/install/lib/ -name '*.a'); do \
		folder=$(echo $file | sed -E "s/(.+)\/(.+).a/\2/"); \
		mkdir -p $folder; cd $folder; ar x $file; \
		for f in *; do \
			mv $f ../$folder-$f; \
		done; \
		cd ..; rm -rf $folder; \
	done ; \
	ar rc libmicroros.a $(ls *.o *.obj 2> /dev/null); mkdir -p $BUILD_DIR; cp libmicroros.a $BUILD_DIR; ranlib $BUILD_DIR/libmicroros.a; \
    cp -R $FW_TARGETDIR/mcu_ws/install/include $BUILD_DIR/; \
	cd ..; rm -rf libmicroros;

popd >/dev/null
