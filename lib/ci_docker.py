#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""Docker lib for gitlab-ci"""

# included
import os

# third party
import sh  # pylint: disable=import-error

# internal imports
from ci_log import log
import ci_version

BASE_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))

# pylint: disable=not-callable
sh_out = sh(_out='/dev/stdout', _err='/dev/stderr', _cwd=BASE_DIR)


class DockerPullFailed(Exception):
    """Raised if docker pull fails"""


class DockerPushFailed(Exception):
    """Raised if docker pull fails"""


def add_and_push_tag(image_name, tag, docker_env, pull_push_env):
    """Adds a tag to an image"""
    log.info('Adding tag {} to {}', tag, image_name)
    sh_out.docker.tag(image_name, tag, _env=docker_env)
    try:
        sh_out.docker.push(tag, _env=pull_push_env)
    # pylint: disable=no-member
    except sh.ErrorReturnCode_1 as docker_pull_failed:
        raise DockerPushFailed from docker_pull_failed
    log.info('Done with this tag')


def add_version_label(app_version, image_name, docker_env):
    """Adds a version label to an image"""
    log.info('Adding version label {}', app_version)
    sh_out.docker.build(
        '--label',
        'org.opencontainers.app.version={}'.format(app_version),
        '--tag',
        image_name,
        '-',
        _env=docker_env,
        _in='FROM {}'.format(image_name),
    )
    log.info('Done with labeling')


def add_and_push_build_version_label_and_tag(
    image_path, ci_pipeline_id, docker_env, pull_push_env
):
    """Get the version, add it as a label and push it as a tag with build-id"""
    build_path = '{}:build-{}'.format(image_path, ci_pipeline_id)
    app_version = ci_version.get_app_version(build_path, docker_env)

    add_version_label(app_version, build_path, docker_env)

    clean_version = ci_version.cleanup_for_docker_tag(app_version)
    tag = '{}:{}-{}'.format(image_path, clean_version, ci_pipeline_id)
    # push tag "<version>-<ci-pipeline-id>"
    add_and_push_tag(build_path, tag, docker_env, pull_push_env)


def pull_add_push_publish_version_tag(
    image_path, ci_pipeline_id, docker_env, pull_push_env, push_path
):
    """Get the version, push latest and version tags"""
    build_path = '{}:build-{}'.format(image_path, ci_pipeline_id)

    try:
        sh_out.docker.pull(build_path, _env=pull_push_env)
    # pylint: disable=no-member
    except sh.ErrorReturnCode_1 as docker_pull_failed:
        raise DockerPullFailed from docker_pull_failed

    app_version = ci_version.get_app_version(build_path, docker_env)

    tag = '{}:latest'.format(push_path)
    # push tag "latest"
    add_and_push_tag(build_path, tag, docker_env, pull_push_env)

    clean_version = ci_version.cleanup_for_docker_tag(app_version)
    tag = '{}:{}'.format(push_path, clean_version)
    # push tag "<version>"
    add_and_push_tag(build_path, tag, docker_env, pull_push_env)


# [EOF]
