cmake_minimum_required(VERSION 3.5)
project(nuttx_kconfig_vendor)

# find dependencies
find_package(ament_cmake REQUIRED)

ament_package()

include(ExternalProject)

set(TOOLS_SRC ${CMAKE_CURRENT_SOURCE_DIR}/tools)
set(KCONFIG_SRC ${TOOLS_SRC}/kconfig-frontends)
ExternalProject_Add(kconfig
  GIT_REPOSITORY https://bitbucket.org/nuttx/tools.git
  GIT_SHALLOW 1
  SOURCE_DIR ${TOOLS_SRC}
  BINARY_DIR ${KCONFIG_SRC}
  CONFIGURE_COMMAND ./configure --enable-mconf --prefix=${CMAKE_INSTALL_PREFIX}
  BUILD_COMMAND make
  INSTALL_COMMAND make install
)