# CMakeLists.txt.  Generated from CMakeLists.txt.in by configure.ac.

cmake_minimum_required(VERSION 3.14)

project(libserialport
  VERSION "0.1.1.23"
  DESCRIPTION "avrdudes bugfix fork of sigrok libserialport"
  HOMEPAGE_URL "https://github.com/avrdudes/libserialport"
  LANGUAGES C
)

include(GNUInstallDirs)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED True)

configure_file(cmake-config.h.in config.h)
configure_file(libserialport.pc.in libserialport.pc)

if     (CMAKE_SYSTEM_NAME STREQUAL "Darwin")
  set(LSP_SOURCES "macosx.c")
elseif (CMAKE_SYSTEM_NAME STREQUAL "FreeBSD")
  set(LSP_SOURCES "freebsd.c")
elseif (CMAKE_SYSTEM_NAME STREQUAL "Linux")
  set(LSP_SOURCES "linux.c")
elseif (CMAKE_SYSTEM_NAME STREQUAL "Windows")
  set(LSP_SOURCES "windows.c")
else()
  message(FATAL_ERROR
    config.h
    "${CMAKE_PROJECT_NAME} does not support this system: ${CMAKE_SYSTEM_NAME}")
endif()

add_library(libserialport SHARED
  ${LSP_SOURCES}
)

target_include_directories(libserialport
  PUBLIC
  "${PROJECT_SOURCE_DIR}"
  "${PROJECT_BINARY_DIR}"
  "${CMAKE_CURRENT_SOURCE_DIR}"
  "${CMAKE_CURRENT_BINARY_DIR}"
)

set_target_properties(libserialport PROPERTIES
  PREFIX ""
  PUBLIC_HEADER "libserialport.h"
  VERSION sp_lib_version_major.sp_lib_version_minor.sp_lib_version_micro
  SOVERSION 1
)

install(TARGETS libserialport
  LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
  ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}"
  PUBLIC_HEADER DESTINATION include COMPONENT dev
)

install(FILES "libserialport.pc"
  DESTINATION "${CMAKE_INSTALL_LIBDIR}/pkgconfig"
)
