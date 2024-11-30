#!/bin/bash
source ./verification.sh

function drop_db(){
	DBName=$1
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
drop_db $1