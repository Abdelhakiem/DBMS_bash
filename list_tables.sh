#!/bin/bash

function list_tables() {
	DBName=$1
	if [ -d "Databases/$DBName" ]
	then
		echo "Database Tables:"
		ls "Databases/$DBName"
	else 
		echo "Database doesn't exist"
	fi
}
