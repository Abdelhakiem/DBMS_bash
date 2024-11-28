#!/bin/bash

function ConnectDB() {
	DBName=$1
	if [ -d "Databases/$DBName" ]
	then
		echo "Database Connected Successfully"
	else 
		echo "Database doesn't exist"
	fi
}
ConnectDB $1
