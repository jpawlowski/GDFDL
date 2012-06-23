#!/bin/bash -e
#

SELF="`readlink -f $0`"
GDFDL_INSTALLER_BASEDIR_CI_00="`dirname ${SELF}`"
GDFDL_INSTALLER_BASEDIR_CI="`dirname ${GDFDL_INSTALLER_BASEDIR_CI_00}`"
GDFDL_INSTALLER_BASEDIR="`dirname ${GDFDL_INSTALLER_BASEDIR_CI}`"
if [ -d "${GDFDL_INSTALLER_BASEDIR}/.ci" ]
	then
	echo "ERROR: CI directory '${GDFDL_INSTALLER_BASEDIR}/.ci' already exists. Run uninstaller to cleanup first."
	exit 1
fi
mkdir "${GDFDL_INSTALLER_BASEDIR}/.ci"
cd "${GDFDL_INSTALLER_BASEDIR}/.ci"

GDFDL_BRANCH="`git remote show origin | grep HEAD | cut -d " " -f 5`"

GDFDL_INSTALLTYPE="ci" bash -ex "${GDFDL_INSTALLER_BASEDIR}/gdfdl-scripts/gdfdl-installer" "${GDFDL_BRANCH}" "${GDFDL_INSTALLER_BASEDIR}" "${GDFDL_INSTALLER_BASEDIR}"
