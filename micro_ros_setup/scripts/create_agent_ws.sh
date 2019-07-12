#! /bin/bash

if [ $# -lt 1 ]
then
    echo "Syntax: $0 <targetdir>"
    exit 255
fi

if [ ! -d  $1 ]
then
    echo "Syntax: Target ('$1') must be a directory but isn't".
    exit 255
fi

OUR_PREFIX=$(ros2 pkg prefix micro_ros_setup)
PACKAGES=${OUR_PREFIX}/config/agent_ros2_packages.txt

pushd $1
if [ -f ros2.repos ]
then
    echo "Repo-file ros2.repos already present, ignoring $1"
else
  # ROS_DISTRO SPECIFIC
  wget https://raw.githubusercontent.com/ros2/ros2/crystal/ros2.repos
  vcs import --input ros2.repos
  for dir in $(ls -d */*); do  
    if grep -q $dir $PACKAGES
    then  
      echo $dir OK
    else
      echo Removing $dir
      rm -rf $dir
    fi
  done
  vcs import --input ${OUR_PREFIX}/config/agent_uros_packages.repos
fi

popd

echo "Repos imported, now run rosdep to ensure all dependencies are present."