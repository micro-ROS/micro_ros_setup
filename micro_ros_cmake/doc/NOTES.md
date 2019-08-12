Notes on some decisions here

 - Reuse the standard ROS2 repository list from the 
   ROS2/ROS2 repository. 
    - Pro: Always up-to-date with upstream
    - Con: Checks out a more than strictly necessary (if 
      this ever becomes a problem, we could probably automatically prune the yaml, 
      but so far it seems to be okay)
 - Reuse the build infrastructure (ament, etc) from the binary packages
 - When installing dependencies, ignore connext and opensplice -- micro-ROS only supports FastRTPS anyway