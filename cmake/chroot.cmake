# Create a Python virtual environment in a chroot
#
# Args:
#  - NAME (required): Name of the virtual environment
#  - PYVENV_DIR (str): Directory where the virtual environment will be created
#  - USE_SYSTEM_SITE_PACKAGES (bool): Use system site packages, if unset defaults to true
#
# Outputs:
#  pyvenv-${ARG_NAME}-build : A custom target that builds the virtual environment
#  pyvenv-${ARG_NAME}-dir: The path to the virtual environment
#
function(pyvenv_create)
  # Function to parse arguments
  set(OPTIONS "") # Options
  set(ONE_VALUE_ARGS NAME PYVENV_DIR USE_SYSTEM_SITE_PACKAGES) # One value
                                                               # arguments
  set(MULTI_VALUE_ARGS "") # Multi value arguments

  cmake_parse_arguments(
    ARG "${OPTIONS}" "${ONE_VALUE_ARGS}" "${MULTI_VALUE_ARGS}" ${ARGN}
  )

  # Access the parsed arguments
  if(ARG_UNPARSED_ARGUMENTS)
    message(WARNING "Unparsed arguments: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  if("${ARG_NAME}" STREQUAL "")
    message(FATAL_ERROR "Required argument NAME is missing")
  endif()

  if(DEFINED ARG_USE_SYSTEM_SITE_PACKAGES)
    set(USE_SYSTEM_SITE_PACKAGES ${ARG_USE_SYSTEM_SITE_PACKAGES})
  else()
    set(USE_SYSTEM_SITE_PACKAGES TRUE)
  endif()

  if(${USE_SYSTEM_SITE_PACKAGES})
    set(SYSTEM_SITE_PACKAGES "--system-site-packages")
  else()
    set(SYSTEM_SITE_PACKAGES "")
  endif(${USE_SYSTEM_SITE_PACKAGES})

  message(STATUS "Creating Python virtual environment ${ARG_NAME}")

  if("${ARG_PYVENV_DIR}" STREQUAL "")
    set(PYVENV_DIR ${CMAKE_CURRENT_BINARY_DIR}/${ARG_NAME})
  else()
    set(PYVENV_DIR ${ARG_PYVENV_DIR})
  endif()

  set(PYVENV_ARTIFACT ${PYVENV_DIR}/bin/activate)

  add_custom_command(
    OUTPUT ${PYVENV_ARTIFACT}
    COMMAND python3 -m venv ${PYVENV_DIR} ${SYSTEM_SITE_PACKAGES}
    COMMAND ${PYVENV_DIR}/bin/pip install --upgrade pip==24.0
  )

  add_custom_target(${ARG_NAME}-pyvenv-build DEPENDS ${PYVENV_ARTIFACT})

  set(${ARG_NAME}-pyvenv-dir
      ${PYVENV_DIR}
      PARENT_SCOPE
  )

  set_property(
    TARGET ${ARG_NAME}-pyvenv-build PROPERTY pyvenv-dir ${PYVENV_DIR}
  )

endfunction(pyvenv_create)

# ~~~
# Install in the python virtual environment the different requirements files
#
# Args:
#   - NAME (required): Name of the virtual environment to use we assume that
# the virtual environment has been created with pyvenv_create
#   - REQUIREMENTS_FILES (required): List of requirements files to install in the
#     virtual environment
#
# Outputs:
#  - ${NAME}-install-reqs : A custom target that install the
#    requirement files in the virtual environment
#
# ~~~
function(pyvenv_install_requirements)
  # Function to parse arguments
  set(OPTIONS "") # Options
  set(ONE_VALUE_ARGS NAME) # One value
  # arguments
  set(MULTI_VALUE_ARGS REQUIREMENTS_FILES) # Multi value arguments

  cmake_parse_arguments(
    ARG "${OPTIONS}" "${ONE_VALUE_ARGS}" "${MULTI_VALUE_ARGS}" ${ARGN}
  )

  # Access the parsed arguments
  if(ARG_UNPARSED_ARGUMENTS)
    message(WARNING "Unparsed arguments: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  if(NOT ARG_NAME)
    message(FATAL_ERROR "Required argument NAME is missing or empty")
  endif()

  if(NOT ARG_REQUIREMENTS_FILES)
    message(
      FATAL_ERROR "Required argument REQUIREMENTS_FILES is missing or empty"
    )
  endif()

  # Get the installation directory of the virtual environment
  get_property(
    PYVENV_DIR
    TARGET ${ARG_NAME}-pyvenv-build
    PROPERTY pyvenv-dir
  )

  # Build the command that installs the different requirement files.
  set(CMD "${PYVENV_DIR}/bin/pip install ${PYTHON_ADDITIONAL_INDEX}")

  foreach(REQUIREMENTS_FILE ${ARG_REQUIREMENTS_FILES})
    set(CMD "${CMD} -r ${REQUIREMENTS_FILE}")
  endforeach()

  # Create a token that will be used to check if the installation has been done
  set(INSTALL_TOKEN ${CMAKE_CURRENT_BINARY_DIR}/${ARG_NAME}-install.done)

  add_custom_command(
    OUTPUT ${INSTALL_TOKEN}
    COMMAND bash -c "${CMD}"
    COMMAND date > ${INSTALL_TOKEN}
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    USES_TERMINAL
    DEPENDS #
            ${ARG_NAME}-pyvenv-build #
            ${ARG_REQUIREMENTS_FILES} #
  )

  add_custom_target(${ARG_NAME}-install-reqs DEPENDS ${INSTALL_TOKEN})

endfunction(pyvenv_install_requirements)
