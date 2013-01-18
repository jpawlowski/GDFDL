#!/bin/bash
#
# GDFDL - A Development Framework for Debian live-build
# Standard Linux Settings
#
# Copyright (c) 2012-2013, Julian Pawlowski <jp@jps-networks.eu>
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
## GDFDL: General system configuration\n\n"

echo -e "GDFDL: Set Time Zone ...\n"
echo ${TIMEZONE} > /etc/timezone
cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime

echo -e "GDFDL: Set locale settings ...\n"
echo "LANG=en_US.UTF-8" > /etc/locale
echo "de_DE ISO-8859-1" > /etc/locale.gen
echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen
echo "de_DE@euro ISO-8859-15" >> /etc/locale.gen
echo "en_US ISO-8859-1" >> /etc/locale.gen
echo "en_US.ISO-8859-15 ISO-8859-15" >> /etc/locale.gen
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen 2>&1 >/dev/null

echo -e "GDFDL: Correcting file permissions ...\n"
chmod 0440 /etc/sudoers.d/*
