#!/bin/bash

# Default Tarring Final Converted
finalTar=false

# Default Flac Directory
musicDir=.

# TODO Check if uuidgen is avail
uuid=$(uuidgen)

# Default Final Directory
convDir=./$uuid

Help() {
    echo "Syntax: convertFlacToAlac.sh [-h|d|o|t]"
    echo "h     Display this menu"
    echo "d     Set Flac Directory to Search (Default: $musicDir)"
    echo "o     Set Output Directory (Default unique ID)"
    echo "t     Tar the Output directory (Default $finalTar)"
}

while getopts ":hd:o:t:" option; do
    case $option in
        h)
            Help
            exit;;
        d)
            musicDir=$OPTARG;;
        o)
            convDir=$OPTARG;;
        t)
            finalTar=true
        /?)
            echo "[!] Invalid Option"
            exit;;
    esac
done

if [ ! -d "$musicDir" ] ; then
	echo "[!] $musicDir does not exist!!!"
	exit 1
fi

if [ ! -d "$convDir" ] ; then
	echo "[+] $convDir does not exist. Creating it..."
	mkdir -p $convDir
fi

# TODO Search case insensitive flac
# TODO Check File Collision
echo "[*] Looking for Flac files"
find "$musicDir" -path "$convDir" -prune -o -name "*.flac" -exec ls {} \; -exec cp {} $convDir/. \;

# TODO This number is off by one because header
fileCount=$(ls -l "$convDir" | wc -l)

echo "[*] Converting $fileCount files"

for i in $convDir/*
do
	newFile=$(echo $i | sed 's/flac/m4a/g')
	echo "[*] Converting $i"
    # TODO Check if ffmpeg is avail
	ffmpeg -v 0 -i "$i" -vcodec copy -acodec alac "$newFile"
	rm -f "$i"
done

if [ "$finalTar" = true ] ; then
    fileName=$(uuidgen)
    tar czf ./$fileName.tar.gz "$convDir"
fi
