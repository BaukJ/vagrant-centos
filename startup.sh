#!/usr/bin/env bash

cd $(dirname $0)

echo "CURRENT DIR: $PWD"

while [ 0 ]
do
	printf "Command [u]p, [h]alt, [p]rovision (or custom e.g halt, destroy) : "
	read ans
	[[ "$ans" == "u" ]] && ans=up
	[[ "$ans" == "h" ]] && ans=halt
	[[ "$ans" == "p" ]] && ans="up --provision"
	if [[ "$ans" == "" ]]
	then
		echo "########## NO ARGS PASSED TO VAGRANT"
	else
		echo "########## RUNNING : vagrant $ans"
		vagrant $ans
	fi
done

