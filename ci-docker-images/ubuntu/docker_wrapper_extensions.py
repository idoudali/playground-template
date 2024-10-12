"""ubuntu_base docker image"""

import grp
import hashlib
import logging
import os
import subprocess
import tempfile
from pathlib import Path
from typing import List, Optional

import docker_wrapper

logger = logging.getLogger(__name__)


class Ubuntu2204(docker_wrapper.DockerImage):
    """Ubuntu 22.04 base docker image

    Args:
        docker_wrapper (_type_): Parent class
    """

    NAME = "ubuntu_2204_base"
    TAG_PREFIX = "base"

    def __init__(self, **kwargs) -> None:
        super().__init__(**kwargs)
        self.corrected_name = self.NAME.replace(f"_{self.TAG_PREFIX}", "")
        self.repo_name = f"{self.corrected_name}"
        self.docker_folder = os.path.realpath(
            os.path.join(os.path.realpath(__file__), "../Docker")
        )
        self._enable_docker = False
        self._enable_kvm = False
        self.init_image = "ubuntu:22.04"
        self.stage = "base"

    @property
    def image_tag(self) -> str:
        """Return the tag of the image

        If the image has an explicit numeric version return that, else
        return the first 10 characters of the image hash.

        Returns:
            str: Return string to be used at the image tag.
        """
        suffix = super().image_tag
        return f"{self.TAG_PREFIX}_{suffix}"

    @property
    def tagged_name(self) -> str:
        """Return the tuple <IMAGE_NAME>:<IMAGE_TAG>

        Returns:
            str: String result
        """
        return f"{self.repo_name}:{self.image_tag}"

    @property
    def image_url(self) -> str:
        """Return the full image URL, that is the
            <REPO_URL>/<IMAGE_NAME>:<IMAGE_TAG>

        Returns:
            str: String result
        """
        if not self.repo_url:
            return self.tagged_name

        return f"{self.repo_url}{self.tagged_name}"

    def build_image(
        self,
        aws_region: str = "",
        force: bool = False,
        try_pull: bool = True,
        platform: Optional[List[str]] = ["linux/amd64"],
    ) -> None:
        """Build the image

        Build any other images we depend on

        Args:
            aws_region (str, optional): AWS region to login to.
            force_build (bool, optional): Iff True then build the image regardless.
                Defaults to False.
            try_pull (bool, optional): Iff True then try to pull the image from the
                docker registry.
            target (str, optional): Docker image build stage to build
        """
        image_url = self.image_url
        ci_runner = False
        if self.image_exists(image_url) and not force:
            logger.info(f"Image: {image_url} already exists, not rebuilding")
            return
        elif try_pull and not force:
            logger.info(f"Try pulling image {image_url}")
            try:
                self.pull()
                return
            except Exception as e:
                logger.info(f"Failed to pull image {image_url} with error: {e}")

        cmd = [
            "DOCKER_BUILDKIT=1",
            "docker",
            "buildx",
            "build",
            "--target",
            self.stage,
            "--build-arg",
            f"INIT_IMAGE={self.init_image}",
        ]
        cmd += [
            "-t",
            image_url,
            "--load",
        ]
        if platform:
            cmd += ["--platform", ",".join(platform)]
        # Build context is the docker folder
        cmd += ["."]
        # Avoid logging by default to avoid leaking sensitive information
        cmd_str = " ".join(cmd)
        print(f"Running command: {' '.join(cmd)}")
        subprocess.check_call(cmd_str, shell=True, cwd=self.docker_folder)

    @property
    def image_hash(self) -> str:
        """Compute the hash of the derived image

        To capture correctly any possible changes to the parent image as well,
        the image hash is the combined hash of the "base" image that is passed
        as a build arguments, any other build argument value, and the hash of
        the Docker folder of the derived image. The build arguments are passed
        as a dictionary to the Docker build command, and the keys are sorted
        alphabetically to ensure that the hash is the same regardless of the
        order of the build arguments. The hash of the Docker folder is computed
        by recursively hashing all files in the folder, and the hash of the
        folder is the hash of the concatenated hashes of all files in the
        folder.

        Returns:
            str: Returned hash value
        """
        this_image_hash = self.folder_hash(self.docker_folder)
        logging.debug(f"This image hash {this_image_hash}")
        hash_object = hashlib.sha1(
            this_image_hash.encode("utf8") + self.init_image.encode("utf8")
        ).hexdigest()
        return hash_object


class Ubuntu2204DevBase(Ubuntu2204):
    """Ubuntu 22.04 Dev base docker image

    Args:
        docker_wrapper (_type_): Parent class
    """

    NAME = "ubuntu_2204_dev_base"
    TAG_PREFIX = "dev_base"

    def __init__(self, **kwargs) -> None:
        super().__init__(**kwargs)
        self.corrected_name = self.NAME.replace(f"_{self.TAG_PREFIX}", "")
        self.repo_name = f"{self.corrected_name}"
        self.docker_folder = os.path.realpath(
            os.path.join(os.path.realpath(__file__), "../Docker")
        )
        self.stage = self.TAG_PREFIX


class Ubuntu2204Dev(Ubuntu2204):
    """Ubuntu 22.04 dev docker image"""

    NAME = "ubuntu_2204_dev"
    TAG_PREFIX = "dev"

    def __init__(self, **kwargs) -> None:
        super().__init__(**kwargs)
        self.corrected_name = self.NAME.replace(f"_{self.TAG_PREFIX}", "")
        self.repo_name = f"{self.corrected_name}"
        self.docker_folder = os.path.realpath(
            os.path.join(os.path.realpath(__file__), "../Docker")
        )
        self.stage = self.TAG_PREFIX


class Ubuntu2204Cuda(Ubuntu2204):
    """Ubuntu 22.04 Cuda base docker image

    Args:
        docker_wrapper (_type_): Parent class
    """

    NAME = "ubuntu_2204_cuda_dev"
    TAG_PREFIX = "dev"

    def __init__(self, **kwargs) -> None:
        super().__init__(**kwargs)
        self.corrected_name = self.NAME.replace(f"_{self.TAG_PREFIX}", "")
        self.repo_name = f"{self.corrected_name}"
        self.docker_folder = os.path.realpath(
            os.path.join(os.path.realpath(__file__), "../Docker")
        )
        self._enable_docker = False
        self._enable_kvm = False
        self.init_image = "nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04"
        self.stage = "dev"

    def get_docker_run_args(self) -> List[str]:
        """Get the docker arguments to use when running the image

        Returns:
            List[str]: List of docker arguments
        """
        return ["--gpus", "all"]
