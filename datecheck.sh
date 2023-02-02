#!/bin/bash
month_days=(31 28 31 30 31 30 31 31 30 31 30 31)				#month's max days. January is 31 days,...
declare -A month_names1=([jan]=1 [feb]=2 [mar]=3 [apr]=4 [may]=5 [jun]=6 [jul]=7 [aug]=8 [sep]=9 [oct]=10 [nov]=11 [dec]=12)
										#associative array to get month name and index
declare -A month_names2=([1]=jan [2]=feb [3]=mar [4]=apr [5]=may [6]=jun [7]=jul [8]=aug [9]=sep [10]=oct [11]=nov [12]=dec)

if [ "$#" -ne 3 ]; then								#if argument count not equal to 3
	echo "Usage : $0 Month Day Year"					#error message print
	exit 0
fi;

if [ "$2" -lt 0 ]; then
	echo "BAD INPUT : day can not less than 0"				#day can not less than 0
	exit 0	
fi;

if [ "$3" -lt 0 ]; then
	echo "BAD INPUT : year can not less than 0"				#year can not less than 0
	exit 0	
fi;

if [ `expr $3 % 400` -eq 0 ]; then						#calc leap year and update max days of feb
	month_days[1]=$((${month_days[1]}+1))
elif [ `expr $3 % 100` -eq 0 ]; then
	month_days[1]=$((${month_days[1]}+0))
elif [ `expr $3 % 4` -eq 0 ]; then	
	month_days[1]=$((${month_days[1]}+1))
else
	month_days[1]=$((${month_days[1]}+0))
fi;

month_idx=-1							#month_index, 0 means January, 1 means Feb, ...
month_name=""							#month name, if you input 2 then name is Feb
temp_month=${1,,}						#temp variable to store month, to lowercase
for key in ${!month_names1[@]}					#find in associative aray
do
	if [ "$temp_month" == "$key" ] ; then
		month_idx=$((${month_names1[$key]}-1));		#calc month index and name
		month_name=${temp_month^}
	fi
done
for key in ${!month_names2[@]}
do
	if [ "$temp_month" == "$key" ] ; then			#find in associative array
		month_idx=$(($key-1));
		temp_month=${month_names2[$key]}		#calc month index and name
		month_name=${temp_month^}
	fi
done

if [ $month_idx -lt 0 ]; then					#if we input bad month like 13 or aaa
	echo "BAD INPUT : Input month correctly"
	exit 0
fi

month_max_day=${month_days[$month_idx]}				#month's max days from month_index
if [ "$2" -gt "$month_max_day" ]; then
	if [ "$2" -eq 29 ]; then
		echo "BAD INPUT: $month_name $3 does not have 29 days: not a leap year."
		exit 0
	else
		echo "BAD INPUT: $month_name does not have $2 days."
		exit 0
	fi
fi 
echo "EXIST! $month_name $2 $3 is someone's birthday."
