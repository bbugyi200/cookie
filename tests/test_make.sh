#!/bin/bash

EC=0
capout=/tmp/cookie.capout

###########
#  Setup  #
###########
make uninstall-all &> /dev/null

##################
#  make install  #
##################
make install &> "${capout}"

error_msg=

if ! [[ -f /usr/bin/cookie && -f /usr/bin/gutils.sh ]]; then
    error_msg="/usr/bin/cookie does not exist"
elif ! [[ -x /usr/bin/cookie ]]; then
    error_msg="/usr/bin/cookie is not executable"
fi

if [[ -n "${error_msg}" ]]; then
    echo "[FAIL] make install: ${error_msg}"
    EC=1
else
    echo "[PASS] make install"
fi

########################
#  make uninstall-all  #
########################
make uninstall-all &> "${capout}"

error_msg=

if [[ -f /usr/bin/cookie ]]; then
    error_msg="/usr/bin/cookie still exists"
fi

if [[ -f /usr/bin/gutils.sh ]]; then
    error_msg="/usr/bin/gutils.sh still exists"
fi

if [[ -n "${error_msg}" ]]; then
    echo "[FAIL] make uninstall-all: ${error_msg}"
    EC=1
else
    echo "[PASS] make uninstall-all"
fi

##############
#  Teardown  #
##############
if [[ "${EC}" -ne 0 ]]; then
    printf "\n------- Captured Output -------\n"
    cat "${capout}"
fi

make install &> /dev/null  # >>> TEARDOWN

rm "${capout}"
exit "${EC}"
