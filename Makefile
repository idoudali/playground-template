SHELL := /bin/bash

REPO_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

# Create virtual environment and install requirements
venv/bin/activate: requirements.wrspc.txt ## create virtual environment and install requirements
	python3 -m venv venv
	source venv/bin/activate && pip install -r requirements.wrspc.txt

.PHONY: venv
venv: venv/bin/activate ## create virtual environment and install requirements

.PHONY: dev-container
dev-container: venv ## Create a development container
	mkdir -p $(REPO_DIR)/.local
	. venv/bin/activate && ./repo-cmds.py docker prompt \
		--network=host \
		--volume $(REPO_DIR)/.local:$$HOME/.local \
		ubuntu_2204_dev

.PHONY: dev-container-gpu
dev-container-gpu: venv ## Create a development container with GPU support
	mkdir -p $(REPO_DIR)/.local
	. venv/bin/activate && ./repo-cmds.py docker prompt \
		--network host \
		--volume $(REPO_DIR)/.local:$$HOME/.local \
		ubuntu_2204_cuda_dev

# List of tuples of target name and cmake configuration options
# the tuple is separated by colon while the cmake arguments are separated by commas
# no spaces are allowed as spaces are used to separate the list of arguments
BUILD_TYPES_ARGS = \
Release \
Debug


# Function populating the build rules per release type
# Arguments
# 1: tuple of target name and cmake configuration options as defined above
define BUILD_template

# Generate compile_commands.json file, pass -DCMAKE_EXPORT_COMPILE_COMMANDS=ON

$(eval build_type := $(1))

build-$(build_type)/build.ninja: CMakePresets.json ## Generate the build.ninja file for the $(build_type) build
	cmake -S . --preset $(build_type) --trace-expand --trace-redirect=CONFIGURE_LOG

.PHONY: configure-$(build_type)
configure-$(build_type): build-$(build_type)/build.ninja ## Configure the $(build_type) build

.PHONY: build-$(build_type) ## Build the $(build_type) build
build-$(build_type): configure-$(build_type) ## Build the $(build_type) build
	cd build-$(build_type) && ninja -v -j `nproc` -l `nproc` all
	cd build-$(build_type) && cp .ninja_log .ninja_log.build

.PHONY: targets-$(build_type)
targets-$(build_type): configure-$(build_type) ## List the targets for the $(build_type) build
	@ cd build-$(build_type) && ninja help | grep phony | sort

endef

$(foreach build,$(BUILD_TYPES_ARGS),$(eval $(call BUILD_template,$(build))))


# HELP
.PHONY: help
help:
	@ grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@ echo "Dynamically created targets:"
	@ for build in $(BUILD_TYPES_ARGS); do \
		echo "configure-$$build: ## Configure the $$build build" | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'; \
		echo "build-$$build: ## Build the $$build build" | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'; \
	  done

.DEFAULT_GOAL := help
