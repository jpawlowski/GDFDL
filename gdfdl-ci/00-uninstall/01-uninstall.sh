#!/bin/bash -ex
if [[ -f .ci/gdfdl-develop.sh ]];
then
 bash -ex .ci/gdfdl-develop.sh uninstall
fi
