cmake_minimum_required(VERSION 3.5)

project(cairoF08)

set(VERSION 0.0.1)

enable_language(C Fortran)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Select the type of build: Debug Release" FORCE)
endif(NOT CMAKE_BUILD_TYPE)

include(cmake/flags.cmake)
include(cmake/fortran.cmake)
include(cmake/c.cmake)

set(CAIROF08_LIB cairof08)

find_package(PkgConfig)
pkg_check_modules(Cairo REQUIRED cairo)
include_directories(${Cairo_INCLUDE_DIRS})

set(CAIROF08_INCLUDES ${CMAKE_BINARY_DIR}/cairoF08)
include_directories(${CAIROF08_INCLUDES})


add_subdirectory(src)
add_subdirectory(tests)


