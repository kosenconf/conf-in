#!/bin/sh

for i in `find ../tmp-source -type f`
do
	j=`echo $i | sed 's/[.]*\/tmp-source\///'`
	echo "\InputSource{$i}{$j}"
done
