#!/bin/bash

if [ "$#" -ne 1 ]; then					#if argument count not equal to 3	
  echo "Usage: $0 number[B,KB,MB,GB]"			#error message print
  exit 1
fi;

num=$(echo $1 | grep -Eo "[[:digit:]]+")		#get number field of argument
typ=$(echo $1 | tr -d [0-9])				#get string field of argument
typ=${typ^^}						#make it to upper
if [ "$typ" == "B" ]; then				#if type is byte
	echo "Bytes: $num"
	echo "Kilobytes: $((echo scale=4 ; echo $num / 1024) | bc )"		#scale=3 tell bc to use 4 digit after dot/comma
	echo "Megabytes: $((echo scale=4 ; echo $num / 1024 / 1024) | bc )"	#echo $num / 1024 just compute division
	echo "Gigabytes: $((echo scale=4 ; echo $num / 1024 / 1024 / 1024) | bc )"
fi;
if [ "$typ" == "KB" ]; then
	echo "Bytes: " `expr $(($num*1024))`
	echo "Kilobytes: $num"
	echo "Megabytes: $((echo scale=4 ; echo $num / 1024) | bc )"
	echo "Gigabytes: $((echo scale=4 ; echo $num / 1024 / 1024) | bc )"
fi;
if [ "$typ" == "MB" ]; then
	echo "Bytes: `expr $(($num*1024*1024))`"
	echo "Kilobytes: `expr $(($num*1024))`"
	echo "Megabytes: $num"
	echo "Gigabytes: $((echo scale=4 ; echo $num / 1024) | bc )"
fi;
if [ "$typ" == "GB" ]; then
	echo "Bytes: `expr $(($num*1024*1024*1024))`"
	echo "Kilobytes: `expr $(($num*1024*1024))`"
	echo "Megabytes: `expr $(($num*1024))`"
	echo "Gigabytes: $num"
fi;
