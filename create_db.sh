#!/bin/bash

function create_db(){
	read -p "Please Enter Database Name: " DBName
	if ! validate_database_name "$DBName"; then
        return 
    fi

	if [ -d "Databases/$DBName" ]
	then
		echo -e "\033[31mDatabase already exists\033[0m"

	else 
		mkdir -p "Databases/$DBName"
		echo -e "\033[32mDatabase created successfully\033[0m"
	fi	
}