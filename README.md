# playground-template
Example of an integrate repo that is meant to be a "playground" where different projects / tools are brough and built together

# Quick Start

To work on this repo ensure that you have installed `commitizen` and `pre-commit`
in your environment:

References:

* [pre-commit](https://pre-commit.com/)
* [commitizen](https://commitizen-tools.github.io/commitizen/)

For example, to install the tools in your user environment:

```bash
pip install --user commitizen pre-commit west
```

Read the [commitizen](https://commitizen-tools.github.io/commitizen/) documentation
regarding the type and quality of commits that we want to have in this repo.

After you have installed those packages you can install the pre-commit hooks

```bash
pre-commit install
```

## Commit workflow

Assuming that you have a number of modified files that you would like to commit
to this repo, you can use the following commands to commit your changes:

```bash
# Cherry pick only the changes that you want to commit
# from the modified files
# step 1
git add -up

# AVOID AT ALL COSTS ADDING ALL FILES TO THE REPO
# DO NOT ADD BY MISTAKE ANY BINARY OR LARGE FILES
# git add -a

# run the pre-commit checks
# step 2
pre-commit run

# Add any fixes that the pre-commit checks may have
# made or manual fixes you did by repeating step 1

# Commit the changes
# step 3
cz commit # To write a new commit

# Read you commit message and see if you are happy with it
tig

# or ammend it
git commit --amend
```

## Build workflow

To build the repo, you can use the following commands:

```bash

# Step 1: Update the workspace and pull in the rest of the code
# this step assumes that you have installed west as a user
# West will also be installed in the venv we create above
west update


# Step 2: Create a top-level workspace virtual environment for the repo
# This vevn includes only dependencies necessary for setting up
# the workspace and instantiating the dockerized build environmennt
make venv

# Activate the workspace venv
sourve venv/bin/activate

# Start a development container for cpu development
make dev-container

# Start a GPU development container
make dev-container-gpu

# Configure the project for the Release configuration
make configure-Release

# Build the project
make build-Release

# Currently we do not have default targets that always build
# So you will need to specify the target you want to build
cd build-Release
# List available targets
ninja help
# or try to build a target in Makefile that will print only the
# phony targets in Ninja (if that suits you.)
make targets-Release
# Then try your luck :)
```

## Interacting with the repo CLI tool

As part of the repo we have a CLI tool that helps automating a
number of tasks. Currently it wraps and automates our common tasks
when interacting with docker.

To use the CLI tool, you can use the following commands:

```bash
# Activate the workspace venv
sourve venv/bin/activate

# List the supported sub-commands
./repo-cmds.py --help

# List the docker sub-commands
./repo-cmds.py docker --help

# The CLI provides commands to build, pull, push the docker images
# start a prompt inside or run a command inside the docker container and then edit.

# To start a prompt use the prmpt sub-command followed by the name of the docker image
# to use
./repo-cmds.py docker prompt ubuntu_2204_dev

# To run command inside the docker container, do something like the following,
# where after the docker sub-command we use the name of the docker image
# to use followed by the command to run inside the container

./repo-cmds.py docker ubuntu_2204_base "echo I am inside Docker"
....
echo I am inside Docker
I am inside Docker
```
