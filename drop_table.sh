#!/bin/bash

function drop_table() {
	DBName=$1
	read -p "Please Enter Table Name: " TableName
	
	if [ -f "Databases/$DBName/$TableName" ]
	then
	# drop the table 
		rm "Databases/$DBName/$TableName"
	#drop metadata
		rm "Databases/$DBName/.meta$TableName"
		echo "Dropped Successfully"
	else 
		echo "Table does not exist"
	fi
}
