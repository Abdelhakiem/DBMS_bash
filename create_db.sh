#!/bin/bash
source ./verification.sh
function create_db(){
	DBName=$1
	if ! validate_database_name "$DBName"; then
        echo "Invalid Database Name!"
		return 
    fi

	if [ -d "Databases/$DBName" ]
	then
		echo -e "Database already exists"

	else 
		mkdir -p "Databases/$DBName"
		echo -e "Database created successfully"
	fi	
}
create_db $1