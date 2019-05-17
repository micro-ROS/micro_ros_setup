# Background Information

## Building

### Build Targets

In order of invocation

1) dirlinks: for linking arch and board dirs
1) context: generates some source code
1) depend: generate dependency information in Make.dep for each directory
1) Make libraries: libsched.a, libdrivers.a, libconfigs.a, libc.a, libmm.a, libarch.a, libxx.a, libapps.a, libnet.a, libfs.a, 
   * For libapps.a: `make all` in each dir in `apps`


### Build Configuration

The easiest way to override build variables is in `configs/<target>/scripts/Make.defs`.

**Note:** Because of this, many people have dropped various special configurations in there, which are *not* always the same for the various boards.

## NuttX firmware modes

NuttX has several different working modes with respect to [memory configurations](http://www.nuttx.org/doku.php?id=wiki:nxinternal:memconfigs):
 
 1) Flat mode: NuttX and the apps are in one firmware file and share the same memory space
 2) Protected mode: Requires an MPU, and puts the kernel into a separate memory protection unit from the apps.
 3) Address Environments: Each task has its own memory environment. Requires a MMU and is only fully supported on Cortex-A.
 4) Kernel mode: A combination of 2 and 3. Also requires MMU.

 For the micro-ROS target architectures, only the first two options are available. Currently (May 2019), we use flat mode only.
 
In addition, apps can be included in a number of ways:

 1) Built-in. Included in and executed from the firmware
 2) Loadable file, e.g. ELF or NXFLAT.

### Flat Mode

Flat mode is the default and the easiest. Everything is one memory area, applications can access the kernel through a regular function call interface. Also, linkage is one step: Only symbols needed during linking are included.

#### Drawbacks:

 * There is no memory protection, applications can corrupt the kernel and/or other applications
 * When you add code, e.g., through a file system, later on, kernel symbols may be missing because nothing required them during initial linkage.


### Protected mode

Protected mode can work with a simple MPU to separate kernel and user memory. See [NuttX protected build](http://nuttx.org/doku.php?id=wiki:howtos:kernelbuild) (note that, despite the name of the page, this is *not* the kernel build option 4 mentione above).

This is again available in two configurations
 
  1) Single heap (kernel+userspace allocations in one)
  2) Dual heap (kernel separated from userspace allocations)

#### Advantages

 * In the dual heap configuration, the kernel memory is protected from userspace


#### Drawbacks

  * The dual heap configuration has a lot of memory overhead due to alignment constraints.


