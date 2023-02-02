#!/bin/bash

if [ "$#" -eq 0 ]; then							#if argument count not equal to 1
  echo "No argument given! Give a directory as a input"			#error message print
  exit 0
fi;

if [ ! -d "$1" ]; then							#find directory using -d
	echo "$0 : can not find directory $1"				#error display
  	exit 0
fi

parentdir="$(dirname "$1")"						#directory's parent

DIR="$( cd "$( dirname "$0" )" && pwd )"				#current directory

if [[ "$parentdir" != "." && "$parentdir" != "$DIR" ]]; then		#check subdirectory
	echo "$0 : you must specify a subdirectory"
  	exit 0
fi

if [ ! -w "$DIR" ]; then						#check write permission
	echo "$0 : can not write the compressed file to current directory."
  	exit 0
fi;

size=$(du -sb "$1" | cut -f 1)						#check file size

if [ $size -gt 536870912 ]; then					#it is larger than 512M
	while [[ ! "$inn" == "y" && ! "$inn" == "n" ]]
	do
		echo "Warning!. directory is over 512M. Proceed?[y/n]"
		read inn
	done
	
	if [ "$inn" == "n" ]; then					#if you select no exit
		exit 0	
	fi;
	echo "It can take sometime. please wait..."
fi;  


filename="${1}.tgz"							#new file name	

if [ -e "$filename" ]; then
  	echo "WARNING: file exists: $filename" >&2
else
  	tar -cf "$filename" "$@"
	echo "Directory $1 archived as $filename"
fi
