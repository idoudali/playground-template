# Workspace setup

set(PYVENV_NAME example)

pyvenv_create(NAME ${PYVENV_NAME})

pyvenv_install_requirements(
  NAME
  ${PYVENV_NAME} #
  REQUIREMENTS_FILES #
  ${CMAKE_CURRENT_SOURCE_DIR}/requirements.txt
  ${CMAKE_CURRENT_SOURCE_DIR}/requirements.jupyter.txt
)
