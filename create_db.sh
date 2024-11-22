#!/bin/bash

function create_db(){
	read -p "Please Enter Database Name: " DBName
	
	if [ -d "Databases/$DBName" ]
	then
		echo "Database already exists"
	else 
		mkdir -p "Databases/$DBName"
		echo "Database created successfully"
	fi	
}
