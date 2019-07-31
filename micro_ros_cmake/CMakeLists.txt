cmake_minimum_required(VERSION 3.5)
project(micro_ros_cmake NONE)

# find dependencies
find_package(ament_cmake REQUIRED)
# uncomment the following section in order to fill in
# further dependencies manually.
# find_package(<dependency> REQUIRED)

ament_package()

install(
  DIRECTORY cmake
  DESTINATION share/${PROJECT_NAME}
)
