#!/bin/bash

musicDir=.
convDir=./converted-music

if [ ! -z "$1" ] ; then
	echo "[*] Setting search dir to $musicDir"
	musicDir=$1
fi

if [ ! -d "$musicDir" ] ; then
	echo "[!] $musicDir does not exist!!!"
	exit 1
fi

if [ ! -d "$convDir" ] ; then
	echo "[+] $convDir does not exist. Creating it..."
	mkdir -p $convDir
fi

echo "[*] Looking for Flac files"
find $musicDir -path "$convDir" -prune -o -name "*.flac" -exec ls {} \; -exec cp {} $convDir/. \;

fileCount=$(ls -l "$convDir" | wc -l)

echo "[*] Converting $fileCount files"

for i in $convDir/*
do
	newFile=$(echo $i | sed 's/flac/m4a/g')
	echo "[*] Converting $i"
	ffmpeg -v 0 -i "$i" -vcodec copy -acodec alac "$newFile"
	rm -f "$i"
done

tar czf ./music.tar.gz "$convDir"
