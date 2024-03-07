#! /bin/bash

set -e
set -o nounset
set -o pipefail

if [ $# -lt 3 ]
then
    echo "Syntax: $0 <targetdir> <pkglist> <repolist>"
    exit 255
fi

if [ ! -d  $1 ]
then
    echo "Error: Target ('$1') must be a directory but isn't".
    exit 255
fi


PACKAGES=$2
REPOS=$3

if [ ! -f ${PACKAGES} ]
then
    echo "Error: Package list file $PACKAGES (expanded from $2) does not exist"
    exit 255
fi

if [ ! -f ${REPOS} ]
then
    echo "Error: Repo file $REPOS (expanded from $3) does not exist"
    exit 255
fi


pushd $1 >/dev/null
if [ -f ros2.repos ]
then
    echo "Repo-file ros2.repos already present, overwriting!"
fi

# ROS_DISTRO SPECIFIC
curl -s https://raw.githubusercontent.com/ros2/ros2/humble/ros2.repos |\
    ros2 run micro_ros_setup yaml_filter.py ${PACKAGES} > ros2.repos
vcs import --input ros2.repos --skip-existing
vcs import --input $REPOS --skip-existing

popd >/dev/null

