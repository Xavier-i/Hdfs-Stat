#!/bin/bash

if [ ${#} -ne 1 ]; then
	echo please enter input path >&2
	exit 200
fi
if [[ ${1} =~ '/'$ ]]; then
	inputPath="${1}*"
else
	inputPath="${1}/*"
fi

tmptableFile=$(mktemp tmp.XXXXX)
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

$(hadoop fs -ls ${inputPath}|egrep "^d"|awk '{print $8}' > ${tmptableFile})
$(hadoop fs -ls -R ${inputPath}|egrep "^-"|awk '{print $5"   " $8}'> ${tmpFile})
for db in $(cat $tmptableFile); do
	fileSize=$(cat ${tmpFile}|egrep  "${db}""/"|awk '{print $1}')
	nu=$(num $fileSize)
	siz=$(size $fileSize)
	echo $db","$nu","$siz
done

rm "$tmptableFile"
rm "$tmpFile"
