#!/bin/bash

function ConnectDB() {
	read -p "Please Enter Database Name You want to connect to: " DBName
	if ! validate_database_name "$DBName"; then
        return 
    fi


	if [ -d "Databases/$DBName" ]
	then
		echo -e "\033[32mDatabase Connected Successfully.\033[0m"
		sleep 1
		clear
		TableCommands $DBName
	else 
		echo -e "\033[31mDatabase doesn't exist.\033[0m"
	fi

}
