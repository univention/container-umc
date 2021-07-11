#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# pylint: disable=invalid-name

"""Build script for gitlab-ci"""

# included
import glob
import os
import shutil
import sys
import time

# third party
import sh  # pylint: disable=import-error

sh2 = sh(_out='/dev/stdout', _err='/dev/stderr')  # pylint: disable=not-callable

DEFAULT_UPX_IMAGE_REGISTRY = 'artifacts.knut.univention.de/upx/'

DEFAULT_CI_PIPELINE_ID = '4711'

DEFAULT_DOCKER_COMPOSE_BUILD_FILES = (
    '--file docker-compose.yaml'
    ' --file docker-compose.override.yaml'
    ' --file docker-compose.prod.yaml'
)


class AppVersionNotFound(Exception):
    """Raised if /version file could not be read"""


def add_version_label(image_name):
    """Adds a version label to an image"""
    print('Retrieving /version from {}'.format(image_name))
    result = sh2.docker.run(
        '--rm',
        '--entrypoint=/bin/cat',
        image_name,
        '/version',
        _out=None,
    ).stdout
    app_version = result.rstrip().decode('ascii')
    if not app_version:
        raise AppVersionNotFound
    print('Adding version label {}'.format(app_version))
    sh2.docker.build(
        '--label',
        'org.opencontainers.app.version={}'.format(app_version),
        '--tag',
        image_name,
        '-',
        _in='FROM {}'.format(image_name),
    )
    print('Done with labeling')


def main(service):
    """The main script builds, labels and pushes"""

    build_env = {
        'COMPOSE_DOCKER_CLI_BUILD': '0',
        'PWD': os.getcwd(),
    }

    build_env['LANG'] = os.environ.get('LANG', 'C.UTF-8')

    time_stamp = ''
    if 'CI_JOB_STARTED_AT' not in os.environ:
        time_stamp = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
    build_env['CI_JOB_STARTED_AT'] = os.environ.get(
        'CI_JOB_STARTED_AT', time_stamp
    )

    sha_hash = ''
    if 'CI_COMMIT_SHA' not in os.environ:
        # pylint: disable=too-many-function-args
        sha_hash = sh.git('rev-parse', 'HEAD').stdout.rstrip().decode('ascii')
    build_env['CI_COMMIT_SHA'] = os.environ.get('CI_COMMIT_SHA', sha_hash)

    build_env['CI_PROJECT_URL'] = os.environ.get('CI_PROJECT_URL', 'unset')

    build_env['CI_PIPELINE_ID'] = os.environ.get(
        'CI_PIPELINE_ID', DEFAULT_CI_PIPELINE_ID
    )
    ci_pipeline_id = build_env['CI_PIPELINE_ID']

    docker_compose_build_files = os.environ.get(
        'DOCKER_COMPOSE_BUILD_FILES', DEFAULT_DOCKER_COMPOSE_BUILD_FILES
    )

    upx_image_registry = os.environ.get(
        'UPX_IMAGE_REGISTRY', DEFAULT_UPX_IMAGE_REGISTRY
    )

    for old_name in glob.iglob('.env.*.example'):
        new_name = old_name.replace('.example', '')
        shutil.copy2(old_name, new_name)

    # If not set the "docker-credential-secretservice" crashes
    # with "double free or corruption" for local builds
    if 'DBUS_SESSION_BUS_ADDRESS' in os.environ:
        build_env['DBUS_SESSION_BUS_ADDRESS'] = os.environ[
            'DBUS_SESSION_BUS_ADDRESS']

    # debugging gitlab:
    build_env.update(os.environ)

    sh2.docker_compose(
        docker_compose_build_files.split(),
        'build',
        service if service else '--parallel',
        _env=build_env,
    )

    services = ('gateway', 'server', 'web')
    if service:
        services = (service, )
    for cur_service in services:
        image_name = '{}container-umc/umc-{}:{}-test'.format(
            upx_image_registry, cur_service, ci_pipeline_id
        )
        try:
            add_version_label(image_name)
        except AppVersionNotFound:
            return 2

    sh2.docker_compose(
        docker_compose_build_files.split(),
        'push',
        service if service else None,
        _env=build_env,
    )

    return 0


if __name__ == '__main__':
    SERVICE = ''
    if len(sys.argv) > 1:
        SERVICE = sys.argv[1]
    sys.exit(main(SERVICE))

# [EOF]
