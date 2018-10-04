## no_priority.sh
# Use: ./no_priority.sh [alternate between a number and +,-,x,/]
# Example: ./no_priority.sh 1 + 1 / 2 x 3 + 5 / 8 - 13
# 1 + 1 / 2 * 3 + 5 / 8 - 13 = -12
#
# Copyright (c) 2018 TheSpatializer - https://github.com/thespatializer
# Under MIT License
#!/bin/bash

if [ $# = 0 ]; then
	printf "Opérande manquante\n"
	exit 1
elif [ $# = 1 ]; then
	printf "Opération manquante\n"
	exit 2
elif [ $2 = "+" ] || [ $2 = "-" ] || [ $2 = "x" ] || [ $2 = "/" ]; then
	res=$1
	printf $res
	shift

	while [ $# != 0 ]; do
		case "$1" in
		"+")
			res=$(expr $res + $2)
			printf " + $2"
			;;
		"-")
			res=$(expr $res - $2)
			printf " - $2"
			;;
		"x")
			res=$(expr $res \* $2)
			printf " * $2"
			;;
		"/")
			if [ $2 = 0 ]; then
				printf " / $2 : Division par 0 interdite\n"
				exit 3
			else
				res=$(expr $res / $2)
				printf " / $2"
			fi
			;;
		*)
			;;
		esac
		shift
	done
	if [ $# -lt 2 ]; then
		printf " = $res\n"
	fi
else
	printf "Opération non traitée\n"
	exit 4
fi
exit 0
