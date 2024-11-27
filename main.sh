#!/bin/bash

# Source all function files
source ./create_db.sh
source ./ls_dbs.sh
source ./delete_db.sh
source ./blank_func.sh
source ./list_tables.sh
source ./drop_table.sh
source ./table_commands.sh
source ./connect_db.sh
source ./create_table.sh
source ./verification.sh
source ./delete_table.sh
source ./insert_table.sh
source ./select_table.sh
source ./update_table.sh

function program() {
	clear
	select option in CreateDB ListDBs ConnectDB DropDB exit
	do
		case $option in 
		"CreateDB")
			create_db
			;;
		"ListDBs")
			ls_dbs
			;;
		"ConnectDB")
			ConnectDB
			;;
		"DropDB")
			delete_db
			;;
		"exit")
			break
			;;
		*)
			echo -e "\033[31mWrong Input!\033[0m"
		esac
	done
}

program
