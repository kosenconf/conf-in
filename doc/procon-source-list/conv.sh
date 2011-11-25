#!/bin/sh


for i in `find ../../ -type f -name '*.js'`
do
	nkf -e $i > ./tmp-source/`echo $i | sed 's/\([.]*\/\)*//'`
done

