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


function program() {
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
			echo "Wrong Input"
		esac
	done
}

program
