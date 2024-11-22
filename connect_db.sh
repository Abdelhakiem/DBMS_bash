#!/bin/bash

function ConnectDB() {
	read -p "Please Enter Database Name You want to connect to: " DBName
	if [ -d "Databases/$DBName" ]
	then
		echo "Database Connected Successfully"
		TableCommands $DBName
	else 
		echo "Database doesn't exist"
	fi
}
