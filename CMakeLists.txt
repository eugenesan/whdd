cmake_minimum_required(VERSION 2.8.4)
include(ExternalProject)
project(whdd)

set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}   -pthread -Wall -Wextra")

if(CMAKE_BUILD_TYPE MATCHES Debug)
  add_definitions(-DDEBUG)
  set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}   -g -ggdb -O0 -fno-inline")
endif(CMAKE_BUILD_TYPE MATCHES Debug)

# TODO Set vars containing to deps builds
set(NCURSES_DIR "${CMAKE_CURRENT_SOURCE_DIR}/external/ncurses/install/")
set(DIALOG_DIR "${CMAKE_CURRENT_SOURCE_DIR}/external/dialog/dialog-prefix/src/dialog/")

# TODO Set include paths
include_directories(BEFORE SYSTEM
  ${NCURSES_DIR}/include/ncursesw
  ${DIALOG_DIR}
)
include_directories(
  ${CMAKE_CURRENT_SOURCE_DIR}
  ${CMAKE_CURRENT_SOURCE_DIR}/libdevcheck
  ${CMAKE_CURRENT_SOURCE_DIR}/console_visualized_ui
)

set_source_files_properties(version.h PROPERTIES GENERATED true)
# add_custom_command(OUTPUT version.h COMMAND ./version.sh . version.h)  # TODO

add_executable(whdd
#  version.h
  libdevcheck/device.c
  libdevcheck/action.c
  libdevcheck/libdevcheck.c
  libdevcheck/log.c
  libdevcheck/zerofill.c
  libdevcheck/readtest.c
  libdevcheck/utils.c
  console_visualized_ui/vis.c
  console_visualized_ui/main.c
  console_visualized_ui/dialog_convenience.c
  console_visualized_ui/ncurses_convenience.c
)

add_subdirectory(external/dialog)
add_dependencies(whdd dialog)

add_library(ncurses_lib STATIC IMPORTED)
set_property(TARGET ncurses_lib PROPERTY IMPORTED_LOCATION "${NCURSES_DIR}/lib/libncursesw.a")
add_library(menu_lib STATIC IMPORTED)
set_property(TARGET menu_lib PROPERTY IMPORTED_LOCATION "${NCURSES_DIR}/lib/libmenuw.a")
add_library(dialog_lib STATIC IMPORTED)
set_property(TARGET dialog_lib PROPERTY IMPORTED_LOCATION "${DIALOG_DIR}/libdialog.a")

target_link_libraries(whdd dialog_lib)
target_link_libraries(whdd menu_lib)
target_link_libraries(whdd ncurses_lib)
target_link_libraries(whdd pthread)
target_link_libraries(whdd dl)
target_link_libraries(whdd rt)
target_link_libraries(whdd m)
