## unique_operation.sh
# Use: ./unique_operation.sh [add,supp,mult,div] [args]
# Example: ./unique_operation.sh mult 1 1 2 3 5 8 13
# 1 * 1 * 2 * 3 * 5 * 8 * 13 = 3120
#
# Copyright (c) 2018 TheSpatializer - https://github.com/thespatializer
# Under MIT License
#!/bin/bash

if [ $# = 0 ]; then
	echo "Opération manquante\n"
	exit 1
elif [ $# = 1 ];then
	echo "Opérande manquante\n"
	exit 2
else
	res=$2
	case "$1" in
	"add")
		printf $res
		shift
		shift
		for arg in $@; do
			res=$(expr $res + $arg)
			printf " + $arg"
		done
		printf " = $res\n"
		;;
	"supp")
		printf $res
		shift
		shift
		for arg in $@;do
			res=$(expr $res - $arg)
			printf " - $arg"
		done
		printf " = $res\n"
		;;
	"mult")
		printf $res
		shift
		shift
		for arg in $@;do
			res=$(expr $res \* $arg)
			printf " * $arg"
		done
		printf " = $res\n"
		;;
	"div")
		printf $res
		shift
		shift
		for arg in $@;do
			if [ $arg = 0 ]; then
				printf " / $arg : Division par 0 interdite\n"
				exit 3
			else
				res=$(expr $res / $arg)
				printf " / $arg"
			fi
		done
		if [ $# != 0 ]; then
			if [ $arg != 0 ]; then
				printf " = $res \n"
			fi
		else
			printf " = $res \n"
		fi
		;;
	*)
		echo "Opération inconnue\n"
		exit 4
		;;
	esac
fi
