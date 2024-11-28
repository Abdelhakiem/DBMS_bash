#!/bin/bash

function create_db(){
	DBName=$1
	
	if [ -d "Databases/$DBName" ]
	then
		echo "Database already exists"
	else 
		mkdir -p "Databases/$DBName"
		echo "Database created successfully"
	fi	
}
create_db $1