# Set the path to the external project
set(EXTERNAL_PROJECT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/google-test)

# Target that builds the pyvenv/chroot where we want to install google-test
# inside
set(WRSPC_BUILD_TARGET ${EXAMPLE_CPP_WS_NAME}-pyvenv-build)

# Get the installation directory of the python venv
get_property(
  EXAMPLE_CPP_WS_NAME
  TARGET ${WRSPC_BUILD_TARGET}
  PROPERTY pyvenv-dir
)

# Add the external project
include(ExternalProject)
ExternalProject_Add(
  google-test
  SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/google-test
  BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/google-test
  CMAKE_ARGS -G Ninja #
             -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} #
             -DCMAKE_INSTALL_PREFIX=${EXAMPLE_CPP_WS_NAME} #
  DEPENDS #
          ${WRSPC_BUILD_TARGET} #
)
