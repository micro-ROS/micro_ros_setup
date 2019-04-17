include(ExternalProject)

macro(BuildNuttX board config)    
    ExternalProject_Add(NuttX
      PREFIX NuttX-${board}-${config}
      GIT_SHALLOW 1
      GIT_REPOSITORY https://github.com/micro-ROS/micro_ros_rtos_nuttx.git      
      CONFIGURE_COMMAND cd NuttX && test -f .config || tools/configure.sh ${board}/${config}
      BUILD_IN_SOURCE 1
      BUILD_COMMAND make -C NuttX
      INSTALL_COMMAND make -C NuttX export
      STEP_TARGETS install_libcxx      
    )    
    ExternalProject_Add_Step(NuttX install_libcxx
      DEPENDEES download
      DEPENDERS build
      WORKING_DIRECTORY <BINARY_DIR>/libcxx
      COMMAND pwd
      COMMAND ./install.sh ../NuttX
    )
endmacro()