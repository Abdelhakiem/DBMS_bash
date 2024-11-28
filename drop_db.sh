#!/bin/bash

function delete_db(){
	DBName=$1
	
	if [ -d "Databases/$DBName" ]
	then
		rm -r "Databases/$DBName"
		echo "Database deleted successfully"
	else 
		echo "Database doesn't exist"
	fi	
}
delete_db $1