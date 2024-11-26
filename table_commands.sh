#!/bin/bash

function TableCommands() {
	DBName=$1
	select option in Create List Drop Insert Select Delete Update exit
	do
		case $option in 
		"Create")
			create_table $DBName
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
			delete_from_table $DBName
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
