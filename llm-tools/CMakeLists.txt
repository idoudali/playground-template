# Set the path to the external project
set(EXTERNAL_PROJECT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/llama.cpp)

# Target that builds the pyvenv/chroot where we want to install llama.cpp inside
set(WRSPC_BUILD_TARGET ${LLAMA_CPP_WS_NAME}-pyvenv-build)

# Get the installation directory of the python venv
get_property(
  LLAMA_CPP_WORKSPACE
  TARGET ${WRSPC_BUILD_TARGET}
  PROPERTY pyvenv-dir
)

# Add the external project
include(ExternalProject)
ExternalProject_Add(
  llama-cpp
  SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/llama.cpp
  BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/llama.cpp
  CMAKE_ARGS -G
             Ninja #
             -DCMAKE_BUILD_TYPE=Release #
             -DCMAKE_INSTALL_PREFIX=${LLAMA_CPP_WORKSPACE} #
             # FIXME enable the below line to enable CUDA support (?)
             # -DGGML_CUDA=ON
  DEPENDS #
          ${WRSPC_BUILD_TARGET} #
  # BUILD_COMMAND cmake --build . -v INSTALL_COMMAND ""
)
