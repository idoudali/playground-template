cmake_minimum_required(VERSION 3.20)
project("LLM-Playground")

include(ExternalProject)

include(cmake/chroot.cmake)

# ############### Create the different workspaces ##########################

# We need to create basic structure of the different workspaces earlier in the
# CMake execution flow as their location is the installation path of a number of
# different targets Variables that are being set to avoid cyclic dependencies
# across different CMake files
set(WORKSPACES_BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/workspace)

add_subdirectory("workspace")
