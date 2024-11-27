#!/bin/bash
source './verification.sh'

function list_tables() {
    DBName=$1
    if ! validate_database_name "$DBName"; then
        return 
    fi

    if [ -d "Databases/$DBName" ]; then
        if [ -z "$(ls "Databases/$DBName" 2>/dev/null)" ]; then
            echo -e "\033[31mNo tables found in $DBName database.\033[0m"
        else
            echo -e "\033[33mTables in $DBName database:\033[0m"
            ls "Databases/$DBName"
        fi
    else
        echo -e "\033[31mDatabase $DBName does not exist.\033[0m"
    fi
}
