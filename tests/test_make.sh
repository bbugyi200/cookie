EC=0
capout=/tmp/cookie.capout

make uninstall-all &> "${capout}"

if [[ -f /usr/bin/cookie ]] || [[ -f /usr/bin/gutils.sh ]]; then
    echo "[FAIL] make uninstall-all"
    EC=1
else
    echo "[PASS] make uninstall-all"
fi

make install &> "${capout}"

if ! [[ -f /usr/bin/cookie && -f /usr/bin/gutils.sh ]]; then
    echo "[FAIL] make install"
    EC=1
else
    echo "[PASS] make install"
fi

if [[ "${EC}" -ne 0 ]]; then
    printf "\n------- Captured Output -------\n"
    cat "${capout}"
fi

rm "${capout}"
exit "${EC}"
