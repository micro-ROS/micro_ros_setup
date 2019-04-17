cmake_minimum_required(VERSION 3.5)
project(micro_ros_cmake NONE)

# find dependencies
find_package(ament_cmake REQUIRED)
# uncomment the following section in order to fill in
# further dependencies manually.
# find_package(<dependency> REQUIRED)

if(BUILD_TESTING)
  list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
  message(STATUS "Module path " ${CMAKE_MODULE_PATH})
  include(BuildNuttX)

  BuildNuttX(olimex-stm32-e407 nsh)
endif()

ament_package()

install(
  DIRECTORY cmake
  DESTINATION share/${PROJECT_NAME}
)
