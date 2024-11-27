#!/bin/bash

function delete_db(){
	read -p "Please Enter Database Name: " DBName
	if ! validate_database_name "$DBName"; then
        return 
    fi

	if [ -d "Databases/$DBName" ]
	then
		rm -r "Databases/$DBName"
		echo "Database deleted successfully"
	else 
		echo "Database doesn't exist"
	fi	
}