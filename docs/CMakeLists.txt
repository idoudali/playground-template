# Target that builds the pyvenv/chroot where have the documentation
# dependencies
set(DOCS_BUILD_BUILD_TARGET ${DOCS_BUILD_WS_NAME}-pyvenv-build)
set(DOCS_BUILD_INSTAL_TARGET ${DOCS_BUILD_WS_NAME}-install-reqs)

# Get the installation directory of the python venv
get_property(
  DOCS_BUILD_WORKSPACE
  TARGET ${DOCS_BUILD_BUILD_TARGET}
  PROPERTY pyvenv-dir
)

add_custom_target(
  mkdocs
  COMMAND ${DOCS_BUILD_WORKSPACE}/bin/mkdocs build --no-strict -c -d
          ${CMAKE_CURRENT_BINARY_DIR}
  WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
  DEPENDS ${DOCS_BUILD_INSTAL_TARGET}
)

add_custom_target(
  docs-serve
  COMMAND ${DOCS_BUILD_WORKSPACE}/bin/python -m http.server 8000
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  DEPENDS mkdocs ${DOCS_BUILD_INSTAL_TARGET}
)
