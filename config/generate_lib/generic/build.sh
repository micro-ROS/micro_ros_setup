. $PREFIX/config/utils.sh

TOOLCHAIN=$(pwd)/$1
BUILD_DIR=$FW_TARGETDIR/build

pushd $FW_TARGETDIR/mcu_ws >/dev/null

   	colcon build \
		--merge-install \
		--packages-ignore-regex=.*_cpp \
		--metas $FW_TARGETDIR/mcu_ws/colcon.meta \
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
	ar rc libmicroros.a $(ls *.o *.obj); mkdir -p $BUILD_DIR; cp libmicroros.a $BUILD_DIR; ranlib $BUILD_DIR/libmicroros.a; \
    cp -R $FW_TARGETDIR/mcu_ws/install/include $BUILD_DIR/; \
	cd ..; rm -rf libmicroros;

popd >/dev/null
