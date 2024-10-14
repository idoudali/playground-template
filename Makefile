SHELL := /bin/bash

REPO_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

# Create virtual environment and install requirements
venv/bin/activate: requirements.wrspc.txt ## create virtual environment and install requirements
	python3 -m venv venv
	source venv/bin/activate && pip install -r requirements.wrspc.txt

.PHONY: venv
venv: venv/bin/activate ## create virtual environment and install requirements

dev-container: venv ## Create a development container
	mkdir -p $(REPO_DIR)/.local
	. venv/bin/activate && ./repo-cmds.py docker prompt \
		--network=host \
		--volume $(REPO_DIR)/.local:$$HOME/.local \
		ubuntu_22.04_dev


dev-container-gpu: venv ## Create a development container with GPU support
	mkdir -p $(REPO_DIR)/.local
	. venv/bin/activate && ./repo-cmds.py docker prompt \
		--network host \
		--volume $(REPO_DIR)/.local:$$HOME/.local \
		ubuntu_22.04_cuda_dev

# HELP
.PHONY: help
help:
	@ grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
