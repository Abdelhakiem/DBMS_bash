#!/bin/bash
source ./verification.sh
function ConnectDB() {
	DBName=$1
	if ! validate_database_name "$DBName"; then
		
		return 
    fi

	if [ -d "Databases/$DBName" ]
	then
		echo "Database Connected Successfully"
		
	else 
		echo "Database doesn't exist."
	fi

}
ConnectDB $1