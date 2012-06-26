#!/bin/bash
#
# GDFDL - A Development Framework for Debian live-build
# CI update script
#
# Copyright (c) 2012, Julian Pawlowski <jp@jps-networks.eu>
# See LICENSE.GDFDL file for details.
#

###
# Don't change this file directly.
# If you create additional scripts following the series 01-,02-,03- etc
# we will hand over the stick to the next one in this same directory.
###

set -e

SELF="`readlink -f $0`"
GDFDL_BASEDIR_CI_STEP="`dirname ${SELF}`"
GDFDL_BASEDIR_CI="`dirname ${GDFDL_BASEDIR_CI_STEP}`"
GDFDL_BASEDIR="`dirname ${GDFDL_BASEDIR_CI}`"
GDFDL_ENTRYWRAPPER="`find "${GDFDL_BASEDIR}/.ci" -maxdepth 1 -name '*.sh'`"

# If we find another script named '01-run.sh', start this instead.
# If --force option was given, stay in line...
#
if [[ -f "${GDFDL_BASEDIR_CI_STEP}/01-run.sh" && x"$1" != x"--force" ]]
	then
	echo "NOTE: '${GDFDL_BASEDIR_CI_STEP}/01-run.sh' found, handing over to that one ..."
	"${GDFDL_BASEDIR_CI_STEP}/01-run.sh" "${@}"
	exit 0
fi

# update the Git in chroot with our version
#
if [[ -f "${GDFDL_ENTRYWRAPPER}" ]];
	then

	echo "Copying current version into chroot environment ..."
	GDFDL_ENTRYPATH="`"${GDFDL_ENTRYWRAPPER}" chroot --printdir`"
	GDFDL_BRANCH="`"${GDFDL_ENTRYWRAPPER}" chroot cat /gdfdl_branch`"
	GDFDL_BRANCH_OLDREMOTE="`"${GDFDL_ENTRYWRAPPER}" chroot git --git-dir=/be/.git --work-tree=/be remote`"
	[ ! -d "${GDFDL_ENTRYPATH}/ci-sources" ] && "${GDFDL_ENTRYWRAPPER}" chroot mkdir -m 777 -p /ci-sources
	[ -d "${GDFDL_ENTRYPATH}/ci-sources/gdfdl-current" ] && rm -rf "${GDFDL_ENTRYPATH}/ci-sources/gdfdl-current"
	git clone "${GDFDL_BASEDIR}" "${GDFDL_ENTRYPATH}/ci-sources/gdfdl-current"
	"${GDFDL_ENTRYWRAPPER}" chroot git --git-dir=/be/.git --work-tree=/be remote rm "${GDFDL_BRANCH_OLDREMOTE}"
	"${GDFDL_ENTRYWRAPPER}" chroot git --git-dir=/be/.git --work-tree=/be remote add origin /ci-sources/gdfdl-current
	"${GDFDL_ENTRYWRAPPER}" chroot git --git-dir=/be/.git --work-tree=/be config "branch.${GDFDL_BRANCH}.remote" origin
	"${GDFDL_ENTRYWRAPPER}" chroot git --git-dir=/be/.git --work-tree=/be config "branch.${GDFDL_BRANCH}.merge" "refs/heads/${GDFDL_BRANCH}"
	"${GDFDL_ENTRYWRAPPER}" chroot update
	"${GDFDL_ENTRYWRAPPER}" chroot update --forceconfig
else
	echo "ERROR: No existing build environment installation found. Run installer first."
	exit 1
fi

# if we find another script in the series, go on and run that
# (but ignore 01-run.sh to avoid loops)
#
set +e
GDFDL_CI_NEXT="`find "${GDFDL_BASEDIR_CI_STEP}" -maxdepth 1 -type f -name '01-*.sh' | grep -v 01-run.sh`"
if [ x"${GDFDL_CI_NEXT}" != x"" ]
	then
	echo "NOTE: Next script '${GDFDL_CI_NEXT}' found, handing over now ..."
	"${GDFDL_CI_NEXT}" "${@}"
	exit 0
fi
