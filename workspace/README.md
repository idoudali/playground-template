# Workspace

This folder create a number of python virtual environments for different
projects or tasks.

## Build Flow

See the [CMakeLists.txt](CMakeLists.txt) file for the build flow. Where
you will notice that we are making use of the `pyvenv_create` and
`pyvenv_install_requirements` functions to create the virtual environments.

Currently, the following virtual environments are created:

* `llama-cpp`: chroot/pyvenv folder where we install llama-cpp.

### Build Commands

To build the virtual environments, run the following commands

```bash
# Go to the top-level build directory
ninja help | grep $VENV_NAME
${VENV}-pyvenv-build # Create the skeleton of the python venv
${VENV_NAME}-install-reqs  # Install the python packages defined
```
