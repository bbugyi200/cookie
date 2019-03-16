#!/bin/bash

_files=( 'cookie' )

for f in ${_files[@]}
do
	chmod 755 $f
done
