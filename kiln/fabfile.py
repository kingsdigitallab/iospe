#!/usr/bin/env python
# -*- coding: utf-8 -*-

from fabric.api import local, task, prefix, run, sudo, env, require, cd

from getpass import getpass

import sys
import os.path

# put project directory in path
project_root = os.path.abspath(os.path.dirname(__file__))
sys.path.append(project_root)

env.user = 'agiacometti'
env.hosts = ['iospe.cch.kcl.ac.uk']
env.root_path = '/vol/iospe/webroot/'
env.envs_path = os.path.join(env.root_path, 'envs')

INDEX_ALL_URI = '/admin/solr/index/all.html'
USERNAME = 'agiacometti'


@task
def dev():
    env.srvr = 'dev'
    env.url = 'iospe-dev.cch.kcl.ac.uk'
    set_srvr_vars()


@task
def stg():
    env.srvr = 'stg'
    env.url = 'iospe-stg.cch.kcl.ac.uk'
    set_srvr_vars()


@task
def liv():
    env.srvr = 'liv'
    env.url = 'iospe.cch.kcl.ac.uk'
    set_srvr_vars()


def set_srvr_vars():
    env.path = os.path.join(env.root_path, env.srvr)
    cache_pass()
    # env.within_virtualenv = 'source {}'.format(
    #     os.path.join(env.envs_path, env.srvr, 'bin', 'activate'))


def cache_pass():
    env.password = getpass()


@task
def deploy():
    update()
    index()


@task
def update():
    require('srvr', 'path', 'password', provided_by=[dev, stg, liv])

    with cd(os.path.join(env.path, 'kiln')):
        run('svn up')


@task
def index():
    require('srvr', 'path', 'password', 'url', provided_by=[dev, stg, liv])

    run(('curl'
           ' --insecure'
           ' -u {user}'
           ' --fail'
           ' --silent'
           ' --output /dev/null'
           ' https://{url}/{iurl}').format(url=env.url,
                                           iurl=INDEX_ALL_URI,
                                           user=USERNAME))
