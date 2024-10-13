# Workspace setup

pyvenv_install_requirements(
  NAME
  ${EXAMPLE_CPP_WS_NAME} #
  REQUIREMENTS_FILES #
  ${CMAKE_CURRENT_SOURCE_DIR}/requirements.txt
  ${CMAKE_CURRENT_SOURCE_DIR}/requirements.jupyter.txt
)

pyvenv_install_requirements(
  NAME ${DOCS_BUILD_WS_NAME} #
  REQUIREMENTS_FILES #
  ${CMAKE_CURRENT_SOURCE_DIR}/requirements.docs.txt
)
