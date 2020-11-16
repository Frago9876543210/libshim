cmake_minimum_required(VERSION 3.11)
project(shim LANGUAGES ASM)

set(LIBSHIM_BUILD_TYPE "SHARED" CACHE STRING "Build type of this library")
set(SYMBOLS_SHIM_PATH "" CACHE FILEPATH "Path to file with the symbols map")

set(CMAKE_ASM_CREATE_SHARED_LIBRARY "ld <CMAKE_SHARED_LIBRARY_CREATE_ASM_FLAGS> <CMAKE_SHARED_LIBRARY_SONAME_ASM_FLAG><TARGET_SONAME> <LINK_FLAGS> -o <TARGET> <OBJECTS>")

add_library(shim ${LIBSHIM_BUILD_TYPE} shim.S)
if (SYMBOLS_SHIM_PATH STREQUAL "")
    message(FATAL_ERROR "Please specify SYMBOLS_SHIM_PATH variable")
else ()
    target_compile_definitions(shim PRIVATE SYMBOLS_SHIM_PATH="${SYMBOLS_SHIM_PATH}")
endif ()
