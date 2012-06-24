#!/bin/bash
#
# GDFDL - A Development Framework for Debian live-build
# CI uninstall wrapper
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

# If we find another script named '01-run.sh', start this instead.
# If --force option was given, stay in line...
#
if [[ -f "${GDFDL_BASEDIR_CI_STEP}/01-run.sh" && x"$1" != "--force" ]]
	then
	echo "NOTE: '${GDFDL_BASEDIR_CI_STEP}/01-run.sh' found, handing over to that one ..."
	"${GDFDL_BASEDIR_CI_STEP}/01-run.sh" "${@}"
	exit 0
fi

# run uninstaller
#
if [ -d "${GDFDL_BASEDIR}/.ci" ]
	then
	GDFDL_ENTRYWRAPPER="`find "${GDFDL_BASEDIR}/.ci" -maxdepth 1 -name *.sh`"

	if [[ -f "${GDFDL_ENTRYWRAPPER}" ]];
		then
		"${GDFDL_ENTRYWRAPPER}" uninstall --force
		rm -rf "${GDFDL_BASEDIR}/.ci"
	fi
fi

# if we find another script in the series, go on and run that
# (but ignore 01-run.sh to avoid loops)
#
GDFDL_CI_NEXT="`find "${GDFDL_BASEDIR_CI_STEP}" -type f -maxdepth 1 -name '01-*.sh' | grep -v 01-run.sh`"
if [ x"${GDFDL_CI_NEXT}" != x"" ]
	then
	echo "NOTE: Next script '${GDFDL_CI_NEXT}' found, handing over now ..."
	"${GDFDL_CI_NEXT}" "${@}"
	exit 0
fi
