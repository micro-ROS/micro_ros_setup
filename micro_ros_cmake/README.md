
# WORK IN PROGRESS

In particular, it does not yet work as described below!

# Build support for micro-ROS
This packages provides macros to build the micro-ROS RTOS (currently NuttX)
and a user-defined application package.

The steps for the build process are like this:

0. Download RTOS and apps repositories
1. Configure RTOS for the target board and (pre-defined) configuration.
2. Create a toolchain file that configures CMake to use the RTOS-provided include and linker options
3. Build the target node -- this results in a static archive
4. Compile RTOS. This compiles a number of static libraries, one of which is the "apps" library. We have a "micro-ROS" app which, if enabled, pulls in the static archive with our target node built in the previous step 
5. Link and flash firmware

The main challenge is that, due to the interplay between these, we need to control the compile order a bit more closely than usual.