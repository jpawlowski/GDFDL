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

# update the Git in chroot with revision from CI
#
if [[ -f "${GDFDL_ENTRYWRAPPER}" ]];
	then

	GDFDL_ENTRYPATH="`"${GDFDL_ENTRYWRAPPER}" chroot --printdir`"
	GDFDL_BRANCH="`"${GDFDL_ENTRYWRAPPER}" chroot cat /${GDFDL_BRANDNAME,,}_branch`"
	[ ! -d "${GDFDL_ENTRYPATH}/ci-sources" ] && "${GDFDL_ENTRYWRAPPER}" chroot mkdir -m 777 -p /ci-sources
	[[ -d "${GDFDL_ENTRYPATH}/ci-sources/gdfdl-current" ]] && rm -rf "${GDFDL_ENTRYPATH}/ci-sources/gdfdl-current"

	# implement Git upgrade path from CI system into local copy of build environment in chroot
	echo "CI - Creating Git local transfer copy ..."
	git clone "${GDFDL_BASEDIR}" "${GDFDL_ENTRYPATH}/ci-sources/gdfdl-current"

	# re-create correct branch name in case CI system has somehow weird Git handling (fix for Jenkins)
	BRANCHCHECK="`git --git-dir="${GDFDL_ENTRYPATH}/ci-sources/gdfdl-current/.git" --work-tree="${GDFDL_ENTRYPATH}/ci-sources/gdfdl-current" branch | grep ^* | cut -d " " -f 2`"
	if [[ x"${BRANCHCHECK}" != x"${GDFDL_BRANCH}" ]]
		then
		echo "CI - Correcting Git branch name in transfer copy ..."
		git --git-dir="${GDFDL_ENTRYPATH}/ci-sources/gdfdl-current/.git" --work-tree="${GDFDL_ENTRYPATH}/ci-sources/gdfdl-current" checkout -b "${GDFDL_BRANCH}"
	fi

	# correct Git remote tracking for local directory
	set +e
	REMOTECHECK="`git --git-dir="${GDFDL_ENTRYPATH}/ci-sources/gdfdl-current/.git" --work-tree="${GDFDL_ENTRYPATH}/ci-sources/gdfdl-current" remote -v | grep fetch | grep "/ci-sources/gdfdl-current"`"
	set -e
	if [[ x"${REMOTECHECK}" == x"" ]]
		then
		GDFDL_OLDREMOTE="`"${GDFDL_ENTRYWRAPPER}" chroot git --git-dir="${GDFDL_DIR}/.git" --work-tree="${GDFDL_DIR}" remote`"
		echo "CI - Updating build environment to use Git transfer copy as remote upstream ..."
		"${GDFDL_ENTRYWRAPPER}" chroot git --git-dir="${GDFDL_DIR}/.git" --work-tree="${GDFDL_DIR}" remote rm "${GDFDL_OLDREMOTE}"
		"${GDFDL_ENTRYWRAPPER}" chroot git --git-dir="${GDFDL_DIR}/.git" --work-tree="${GDFDL_DIR}" remote add "${GDFDL_OLDREMOTE}" /ci-sources/gdfdl-current
		"${GDFDL_ENTRYWRAPPER}" chroot git --git-dir="${GDFDL_DIR}/.git" --work-tree="${GDFDL_DIR}" config "branch.${GDFDL_BRANCH}.remote" "${GDFDL_OLDREMOTE}"
		"${GDFDL_ENTRYWRAPPER}" chroot git --git-dir="${GDFDL_DIR}/.git" --work-tree="${GDFDL_DIR}" config "branch.${GDFDL_BRANCH}.merge" "refs/heads/${GDFDL_BRANCH}"
	fi

	# use normal GDFDL functions to update build environment
	"${GDFDL_ENTRYWRAPPER}" update
	"${GDFDL_ENTRYWRAPPER}" update --forceconfig
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
