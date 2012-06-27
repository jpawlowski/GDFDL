#!/bin/bash
#
# GDFDL - A Development Framework for Debian live-build
# CI build wrapper
#
# Copyright (c) 2012, Julian Pawlowski <jp@jps-networks.eu>
# See LICENSE.GDFDL file for details.
#

###
# Don't change this file directly. Create your own file 01-run.sh instead.
# You can call your script directly or still call this script, it will hand over
# to your own smoothly.
# Also if you create additional scripts following the series 01-,02-,03- etc
# we will hand over the stick to the next one in this same directory.
###

set -e

SELF="`readlink -f $0`"
GDFDL_BASEDIR_CI_STEP="`dirname ${SELF}`"
GDFDL_BASEDIR_CI="`dirname ${GDFDL_BASEDIR_CI_STEP}`"
GDFDL_BASEDIR="`dirname ${GDFDL_BASEDIR_CI}`"
source "${GDFDL_BASEDIR}/gdfdl.conf"
[ -f "${GDFDL_BASEDIR}/gdfdl-custom.conf" ] && source "${GDFDL_BASEDIR}/gdfdl-custom.conf"
GDFDL_ENTRYWRAPPER="`find "${GDFDL_BASEDIR}/.ci" -maxdepth 1 -name '*.sh'`"

# If we find another script named '01-run.sh', start this instead.
# If --force option was given, stay in line...
#
if [[ -f "${GDFDL_BASEDIR_CI_STEP}/01-run.sh" && x"$1" != x"--force" ]]
	then
	echo "CI - NOTE: '${GDFDL_BASEDIR_CI_STEP}/01-run.sh' found, handing over to that one ..."
	"${GDFDL_BASEDIR_CI_STEP}/01-run.sh" "${@}"
	exit 0
fi

# run build
#
if [[ -f "${GDFDL_ENTRYWRAPPER}" ]];
	then
	"${GDFDL_ENTRYWRAPPER}" build --verbose
else
	echo "CI - ERROR: No existing build environment installation found. Run installer first."
	exit 1
fi

# if we find another script in the series, go on and run that
# (but ignore 01-run.sh to avoid loops)
#
set +e
GDFDL_CI_NEXT="`find "${GDFDL_BASEDIR_CI_STEP}" -maxdepth 1 -type f -name '01-*.sh' | grep -v 01-run.sh`"
if [ x"${GDFDL_CI_NEXT}" != x"" ]
	then
	echo "CI - NOTE: Next script '${GDFDL_CI_NEXT}' found, handing over now ..."
	"${GDFDL_CI_NEXT}" "${@}"
	exit 0
fi
