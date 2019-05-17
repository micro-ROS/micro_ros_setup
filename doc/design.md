# The short story

My current verdict based on information reproduced below is that we have to use the flat build mode for now.

A consequence of this is that we also have to have the full micro-ROS app available during NuttX linkage.


# Firmware Architecture

NuttX has several different working modes with respect to [memory configurations](http://www.nuttx.org/doku.php?id=wiki:nxinternal:memconfigs):
 
 1) Flat mode: NuttX and the apps are in one firmware file and share the same memory space
 2) Protected mode: Requires an MPU, and puts the kernel into a separate memory protection unit from the apps.
 3) Address Environments: Each task has its own memory environment. Requires a MMU and is only fully supported on Cortex-A.
 4) Kernel mode: A combination of 2 and 3. Also requires MMU.

 For the micro-ROS target architectures, only the first two options are available. Currently (May 2019), we use flat mode only.
 
In addition, apps can be included in a number of ways:

 1) Built-in. Included in and executed from the firmware
 2) Loadable file, e.g. ELF or NXFLAT.

## Flat Mode

Flat mode is the default and the easiest. Everything is one memory area, applications can access the kernel through a regular function call interface. Also, linkage is one step: Only symbols needed during linking are included.

Drawbacks:

 * There is no memory protection, applications can corrupt the kernel and/or other applications
 * When you add code, e.g., through a file system, later on, kernel symbols may be missing because nothing required them during initial linkage.


## Protected mode

Protected mode can work with a simple MPU to separate kernel and user memory. See [NuttX protected build](http://nuttx.org/doku.php?id=wiki:howtos:kernelbuild) (note that, despite the name of the page, this is *not* the kernel build option 4 mentione above).

This is again available in two configurations
 
  1) Single heap (kernel+userspace allocations in one)
  2) Dual heap (kernel separated from userspace allocations)

**Advantages**

 * In the dual heap configuration, the kernel memory is protected from userspace


 **Drawbacks**

  * The dual heap configuration has a lot of memory overhead due to alignment constraints.




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

