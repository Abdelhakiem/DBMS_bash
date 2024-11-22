#!/bin/bash

function TableCommands() {
	DBName=$1
	select option in Create List Drop Insert Select Delete Update exit
	do
		case $option in 
		"Create")
			blank_func
			;;
		"List")
			list_tables $DBName
			;;
		"Drop")
			drop_table $DBName
			;;
		"Insert")
			blank_func
			;;
		"Select")
			blank_func
			;;
		"Delete")
			blank_func
			;;
		"Update")
			blank_func
			;;
		"exit")
			break
			;;
		*)
			echo "Wrong Input"
		esac
	done
}
