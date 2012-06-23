#!/bin/bash -e
#

SELF="`readlink -f $0`"
GDFDL_INSTALLER_BASEDIR_CI_00="`dirname ${SELF}`"
GDFDL_INSTALLER_BASEDIR_CI="`dirname ${GDFDL_INSTALLER_BASEDIR_CI_00}`"
GDFDL_INSTALLER_BASEDIR="`dirname ${GDFDL_INSTALLER_BASEDIR_CI}`"
[ x"$1" == x"" ] && GDFDL_INSTALLER_DESTINATION="${GDFDL_INSTALLER_BASEDIR}/.ci" || GDFDL_INSTALLER_DESTINATION="$1"

[ ! -d "${GDFDL_INSTALLER_DESTINATION}" ] && mkdir "${GDFDL_INSTALLER_DESTINATION}"
cd "${GDFDL_INSTALLER_DESTINATION}"

GDFDL_BRANCH="`git remote show origin | grep HEAD | cut -d " " -f 5`"

if [ x"$1" == x"" ];
	then
	# run installer in debug mode for correct CI tracking of changes
	bash -ex "${GDFDL_INSTALLER_BASEDIR}/gdfdl-scripts/gdfdl-installer" "${GDFDL_BRANCH}" "${GDFDL_INSTALLER_BASEDIR}" "${GDFDL_INSTALLER_BASEDIR}" ci
else
	# run installer in normal mode for humans
	bash "${GDFDL_INSTALLER_BASEDIR}/gdfdl-scripts/gdfdl-installer" "${GDFDL_BRANCH}" "${GDFDL_INSTALLER_BASEDIR}" "${GDFDL_INSTALLER_BASEDIR}" ci
fi

cd -
