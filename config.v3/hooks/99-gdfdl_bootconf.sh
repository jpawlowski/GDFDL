#!/bin/bash
#
# GDFDL - A Development Framework for Debian live-build
# Enable system services
#
# Copyright (c) 2012, Julian Pawlowski <jp@jps-networks.eu>
# See LICENSE.GDFDL file for details.
#

# check each command return codes for errors
#
set -e

###
# Don't change this file directly. Create separate file with sort order after this file instead.
###

# General settings
source /gdfdl.conf
[ -f /gdfdl-custom.conf ] && source /gdfdl-custom.conf

echo -e "\n###########################################################
## GDFDL: System bootup configuration\n\n"

echo -e "GDFDL: Enabling system services ...\n"
[ -f /etc/init.d/gdfdl-custom-prompt ] && mv -f /etc/init.d/gdfdl-custom-prompt /etc/init.d/gdfdl-prompt
[ -f /etc/init.d/gdfdl-custom-init ] && update-rc.d gdfdl-custom-init defaults 2>&1
update-rc.d gdfdl-init defaults 2>&1
update-rc.d gdfdl-prompt defaults 2>&1
