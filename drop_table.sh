#!/bin/bash

function drop_table() {
	DBName=$1
	read -p "Please Enter Table Name: " TableName
  	if ! validate_table_name $TableName; then
        return 
    fi

	if [ -f "Databases/$DBName/$TableName" ]
	then
	# drop the table 
		rm "Databases/$DBName/$TableName"
	#drop metadata
		rm "Databases/$DBName/.meta$TableName"
		echo -e "\033[32mDropped Successfully.\033[0m"
	else 
		echo -e "\033[31mTable does not exist.\033[0m"
	fi
}
