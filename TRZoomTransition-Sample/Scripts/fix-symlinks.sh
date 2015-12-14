#!/bin/bash

cd ../Pods/Headers/Public

InvalidSymLinkMatches=`find . -type f`

for SymLinkReference in $InvalidSymLinkMatches; do
	ActualFile=`cat ${SymLinkReference}`
	echo "--> Fixing ${SymLinkReference} ..."
	rm ${SymLinkReference} && ln -s ${ActualFile} ${SymLinkReference}
done
