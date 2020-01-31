cmake_minimum_required(VERSION 3.5)
project(micro_ros_setup)

# Default to C99
if(NOT CMAKE_C_STANDARD)
  set(CMAKE_C_STANDARD 99)
endif()

# Default to C++14
if(NOT CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD 14)
endif()

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()

# find dependencies
find_package(ament_cmake REQUIRED)
# uncomment the following section in order to fill in
# further dependencies manually.
# find_package(<dependency> REQUIRED)

if(BUILD_TESTING)
  find_package(ament_lint_auto REQUIRED)
  # the following line skips the linter which checks for copyrights
  # uncomment the line when a copyright and license is not present in all source files
  #set(ament_cmake_copyright_FOUND TRUE)
  # the following line skips cpplint (only works in a git repo)
  # uncomment the line when this package is not in a git repo
  #set(ament_cmake_cpplint_FOUND TRUE)
  ament_lint_auto_find_test_dependencies()
endif()

ament_package()

install(
  DIRECTORY config DESTINATION . USE_SOURCE_PERMISSIONS
)

set(NUTTX_SUPPORTED_PLATFORMS olimex-stm32-e407 stm32f4discovery)
foreach(NUTTX_PLATFORM ${NUTTX_SUPPORTED_PLATFORMS})
  install(
    DIRECTORY
      config/nuttx/generic/
    DESTINATION
      config/nuttx/${NUTTX_PLATFORM}
    USE_SOURCE_PERMISSIONS
   )
endforeach()

install(
  PROGRAMS 
    scripts/create_ws.sh 
    scripts/create_agent_ws.sh 
    scripts/create_firmware_ws.sh
    scripts/configure_firmware.sh
    scripts/flash_firmware.sh
    scripts/build_firmware.sh
    scripts/yaml_filter.py
  DESTINATION lib/${PROJECT_NAME}
)
