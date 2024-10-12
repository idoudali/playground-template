SHELL := /bin/bash

# Create virtual environment and install requirements
venv/bin/activate: requirements.wrspc.txt ## create virtual environment and install requirements
	python3 -m venv venv
	source venv/bin/activate && pip install -r requirements.wrspc.txt

.PHONY: venv
venv: venv/bin/activate ## create virtual environment and install requirements


# HELP
.PHONY: help
help:
	@ grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
