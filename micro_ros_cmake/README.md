
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

The main challenge is that, due to the interplay between these, we need to control the compile order a bit more closely than usual. I.e., we can't just compile one package entirely, we have to first configure everything and then compile in order.

The second challenge is that we cannot just rely on rosdep to get all dependencies. We have to compile everything from sources, and thus need all the sources locally. Ideally, though, determining and downloading all dependencies should still be automatic.

## Approaches

In general, micro-ROS needs to build rmw, rcl, their dependencies, the middleware (Micro-XRCE-DDS), and the type support for the micro-controller target.

### Drive build from NuttX

This is essentially the original approach

 * During the RTOS build, a toolchain file is created (like in `apps/uros` originally)
 * Using this toolchain file, the app Makefile invokes colcon build for a specified workspace, resulting in a bunch of static libraries
 * The app Makefile assembles all static libraries into NuttX's libapps.a
 * NuttX compile finishes as usual

#### Advantages

 * We have the toolchain file already before invoking colcon, so colcon works normally
 * We have NuttX directly checked out and can make modifications to it
 
#### Disadvantages

 * We have to tell NuttX where to find the workspace and which package contains our node (for dependency resolution)
 * We must never invoke colcon in the workspace manually, or else the toolchain file will be missing and it will be chaos
 * Either we use NuttX directly, then the build is unusual for the user and configuration has to be done manually
 * Or we drive the NuttX build using our cmake macro, then we essentially only have a single package in the repo, and have a colcon -> NuttX -> colcon build.
   
### External Project with repository list

 * We use an external project build, but modify the download step to use a repository list containing all dependencies of the current project
 * The repository list could be a) contained within the micro_ros_build package, or b) be a URL provided by the user of our macro or c) be auto-generated.

#### Advantages

 * By collecting building as an external project, we have full control over the build process
 * The initial call is in a package part of the user's regular workspace, so the user can still use colcon to *start* the process

#### Disadvantages

  * The source repositories are not normally checked out into the user's workspace. So, modifications to the repositories mentioned above will only be picked up once they are pushed back into the main repositories.

