EC=0
capout=/tmp/cookie.capout

make uninstall-all &> /dev/null  # >>> SETUP

make install &> "${capout}"
if ! [[ -f /usr/bin/cookie && -f /usr/bin/gutils.sh ]]; then
    echo "[FAIL] make install"
    EC=1
else
    echo "[PASS] make install"
fi

make uninstall-all &> "${capout}"
if [[ -f /usr/bin/cookie ]] || [[ -f /usr/bin/gutils.sh ]]; then
    echo "[FAIL] make uninstall-all"
    EC=1
else
    echo "[PASS] make uninstall-all"
fi

if [[ "${EC}" -ne 0 ]]; then
    printf "\n------- Captured Output -------\n"
    cat "${capout}"
fi

make install &> /dev/null  # >>> TEARDOWN

rm "${capout}"
exit "${EC}"
