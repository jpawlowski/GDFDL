#!/bin/bash
#
# GDFDL - A Development Framework for Debian live-build
# Installer script
#
# Copyright (c) 2012, Julian Pawlowski <jp@jps-networks.eu>
# See LICENSE.GDFDL file for details.
#

set -e

SELF="`readlink -f $0`"
GDFDL_INSTALLER_BASEDIR_CI_00="`dirname ${SELF}`"
GDFDL_INSTALLER_BASEDIR_CI="`dirname ${GDFDL_INSTALLER_BASEDIR_CI_00}`"
GDFDL_INSTALLER_BASEDIR="`dirname ${GDFDL_INSTALLER_BASEDIR_CI}`"
GDFDL_BRANCH="`git branch | cut -d " " -f 2`"
[ x"$1" == x"" ] && GDFDL_INSTALLER_DESTINATION="${GDFDL_INSTALLER_BASEDIR}/.ci" || GDFDL_INSTALLER_DESTINATION="$1"

[ ! -d "${GDFDL_INSTALLER_DESTINATION}" ] && mkdir "${GDFDL_INSTALLER_DESTINATION}"
cd "${GDFDL_INSTALLER_DESTINATION}"

if [ x"$1" == x"" ];
	then
	# run installer in debug mode for correct CI tracking of changes
	bash -ex "${GDFDL_INSTALLER_BASEDIR}/gdfdl-scripts/gdfdl-installer" "${GDFDL_BRANCH}" "${GDFDL_INSTALLER_BASEDIR}" "${GDFDL_INSTALLER_BASEDIR}" ci
else
	# run installer in normal mode for humans
	bash "${GDFDL_INSTALLER_BASEDIR}/gdfdl-scripts/gdfdl-installer" "${GDFDL_BRANCH}" "${GDFDL_INSTALLER_BASEDIR}" "${GDFDL_INSTALLER_BASEDIR}" ci
fi

cd -
