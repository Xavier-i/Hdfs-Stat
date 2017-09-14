#!/bin/bash

if [ ${#} -ne 1 ]; then
	echo please enter input path >&2
	exit 200
fi
inputPath=${1}

tmpdbFile=$(mktemp tmp.XXXXX)
tmpFile=$(mktemp tmp.XXXXX)

num(){
	echo "${#}"
}

size(){
	sz=0
	for inte in ${@};do
		sz=$(($sz+$inte))
	done
	echo "$sz"
}



$(hadoop fs -ls ${inputPath}|egrep "^d"|awk '{print $8}' > ${tmpdbFile})
$(hadoop fs -ls -R ${inputPath}|egrep "^-"|awk '{print $5"   " $8}'> ${tmpFile})
for db in $(cat $tmpdbFile); do
	fileSize=$(cat ${tmpFile}|egrep  "${db}""/"|awk '{print $1}')
	nu=$(num $fileSize)
	siz=$(size $fileSize)
	echo $db","$nu","$siz

done		


rm "$tmpdbFile"
rm "$tmpFile"



