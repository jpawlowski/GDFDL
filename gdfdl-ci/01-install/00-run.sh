#!/bin/bash
#
# GDFDL - A Development Framework for Debian live-build
# Local Installer script
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
[ x"$1" == x"" ] && GDFDL_DESTINATION="${GDFDL_BASEDIR}/.ci" || GDFDL_DESTINATION="$1"

if [[ x"${GIT_BRANCH}" != x"" ]]
	then
	GDFDL_BRANCH="${GIT_BRANCH}"
else
	GDFDL_BRANCH="`cd "${GDFDL_BASEDIR}"; git branch | cut -d " " -f 2`"
fi

[ ! -d "${GDFDL_DESTINATION}" ] && mkdir "${GDFDL_DESTINATION}"
cd "${GDFDL_DESTINATION}"

# start the actual installer
bash "${GDFDL_BASEDIR}/gdfdl-scripts/gdfdl-installer" "${GDFDL_BRANCH}" "${GDFDL_BASEDIR}" "${GDFDL_BASEDIR}" ci

cd - 2>&1 >/dev/null

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
