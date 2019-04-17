cmake_minimum_required(VERSION 3.5)
project(nuttx_kconfig_vendor)

# find dependencies
find_package(ament_cmake REQUIRED)

ament_package()

include(ExternalProject)

set(KCONFIG_SRC ${CMAKE_CURRENT_SOURCE_DIR}/tools/kconfig-frontends)
ExternalProject_Add(kconfig
  SOURCE_DIR ${KCONFIG_SRC}
  CONFIGURE_COMMAND ${KCONFIG_SRC}/configure --enable-mconf --prefix=${CMAKE_INSTALL_PREFIX}
  BUILD_COMMAND make
  INSTALL_COMMAND make install
)