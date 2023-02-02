#!/bin/bash

#to run this script well, you have to install 7z and lzop
#sudo apt install p7zip-full
#sudo apt install lzop

if [ "$#" -eq 0 ]; then							#if argument count not equal to 0
  echo "No argument given! Give a filename as a input"			#error message print
  exit 0
fi;

if [[ ! -f "$1" ]]; then							#find directory using -d
	echo "$0 : can not find file $1"				#error display
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

declare -A namearr							# this assoc array is for manage file name and it's algorithm

namearr[gzip]="${1}.gz"						#type gzip and it's file name
namearr[bzip]="${1}.tar.bz2" 						#type bzip and it's file name
namearr[p7zip]="${1}.tar.7z"						#type p7zip and it's file name
namearr[lzop]="${1}.tar.lzo"						#type lzop and it's file name

gzip -k -9 $1 &				#gzip process
tar cf - $1 | bzip2 > ${namearr[bzip]}	&	 			#bzip2 process
tar cf - $1 | 7z a -si ${namearr[p7zip]} -bso0 -bsp0 &			#7zip process for silently compress
tar cf - $1 | lzop -f -9 -q > ${namearr[lzop]}				#lzop process
									#parallel process using special char &
wait
orgsize=$(stat -c%s "$1")						#original file size
maxf=$((4*1024*1024*1024)); 							#max file 4GB
alg="";
for key in ${!namearr[@]}
do
	siz=$(stat -c%s "${namearr[$key]}")				#every generated file size
	if [ "$siz" -lt "$maxf" ]; then					#if it's smaller than max
		maxf=$siz						#update max size
		alg=$key						#current type name
	fi
done
for key in ${!namearr[@]}
do
	if [ "$alg" != "$key" ]; then					#if type is not smallest
		rm ${namearr[$key]}					#remove other generated compress file
	fi
done
if [ "$orgsize" -gt "$maxf" ]; then					#if original file bigger than generated
	rm $1								#remove it
fi;

echo "Most compression obtained by $alg. Compressed file is ${namearr[$alg]}."
