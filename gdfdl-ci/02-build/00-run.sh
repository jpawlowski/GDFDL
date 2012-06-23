#!/bin/bash
#
# GDFDL - A Development Framework for Debian live-build
# CI build wrapper
#
# Copyright (c) 2012, Julian Pawlowski <jp@jps-networks.eu>
# See LICENSE.GDFDL file for details.
#

set -e

SELF="`readlink -f $0`"
GDFDL_BASEDIR_CI_02="`dirname ${SELF}`"
GDFDL_BASEDIR_CI="`dirname ${GDFDL_BASEDIR_CI_02}`"
GDFDL_BASEDIR="`dirname ${GDFDL_BASEDIR_CI}`"
GDFDL_ENTRYWRAPPER="`find "${GDFDL_BASEDIR}/.ci" -maxdepth 1 -name *.sh`"

if [[ -f "${GDFDL_ENTRYWRAPPER}" ]];
	then
	bash -ex "${GDFDL_ENTRYWRAPPER}" build --verbose
fi
