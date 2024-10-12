#!/usr/bin/env python

import socket
from pathlib import Path

import docker_wrapper
import typer
import yaml

REPO_DIR = Path(__file__).parent.absolute()
CONFIG_FILE_PATH = REPO_DIR / "environment-cfg.yml"
ENV_CONFIG = {}


def get_domain():
    return socket.getfqdn()


def read_config_file(file_path):
    with open(file_path, "r") as file:
        config_data = yaml.safe_load(file)
    return config_data


if __name__ == "__main__":

    all_config_data = read_config_file(CONFIG_FILE_PATH)

    app = typer.Typer()

    @app.callback()
    def main(
        env_name: str = typer.Option("", help="Environment name"),
    ):
        global ENV_CONFIG
        if env_name:
            ENV_CONFIG = all_config_data[env_name]
        else:
            domain = get_domain()
            if "ec2" in domain:
                ENV_CONFIG = all_config_data["AWS"]
            else:
                ENV_CONFIG = all_config_data["local"]
        docker_wrapper.set_env_config(ENV_CONFIG)

    app.add_typer(
        docker_wrapper.create_cli(
            image_dir=REPO_DIR / "ci-docker-images", env_config_arg=ENV_CONFIG
        ),
        name="docker",
    )

    app()
