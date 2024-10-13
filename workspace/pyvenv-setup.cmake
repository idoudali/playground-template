# Workspace setup
#
# This files contains the creation step of the chroot/pyvevn workspaces.
# This file is to be included by the top-level CMakeLists.txt file of the folder
# before we start building the different components of the project.
# CMake parses the files in the order they are included, so we need to create
# the target that creates the pyvenv first, before we introduce any other
# components that depend on it and will install files inside the chroot/pyvenv.
#

# llama.cpp workspace
pyvenv_create(
  NAME ${EXAMPLE_CPP_WS_NAME} PYVENV_DIR
  ${WORKSPACES_BINARY_DIR}/${EXAMPLE_CPP_WS_NAME}
)

# Documentation build workspace
pyvenv_create(
  NAME ${DOCS_BUILD_WS_NAME} #
  PYVENV_DIR ${WORKSPACES_BINARY_DIR}/${DOCS_BUILD_WS_NAME} #
  USE_SYSTEM_SITE_PACKAGES FALSE
)
