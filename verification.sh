#!/bin/bash

function validate_database_name() {
    local DBName=$1
    if [ -z "$DBName" ]; then
        echo -e "\033[31mDatabase name cannot be empty\033[0m"
        return 1
    fi
    if ! [[ "$DBName" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
        echo -e "\033[31mInvalid data base name.\n Only letters, numbers, and underscores are allowed,\n and it must start with a letter or underscore.\033[0m"
        return 1
    fi
    return 0 
}

function validate_table_name() {
    local TableName=$1

    if [ -z "$TableName" ]; then
        echo -e "\033[31mTable name cannot be empty\033[0m"
        return 1
    fi
    if ! [[ "$TableName" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
        echo -e "\033[31mInvalid table name.\n Only letters, numbers, and underscores are allowed,\n and it must start with a letter or underscore.\033[0m"
        return 1
    fi
    return 0  
}


function validate_column_name() {
    local ColName=$1
    local -n ColArray=$2  # Pass column names as a reference for checking duplicates

    # Check if the column name is empty
    if [ -z "$ColName" ]; then
        echo "Column name cannot be empty."
        return 1
    fi

    # Check if the column name contains only valid characters
    if ! [[ "$ColName" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
        echo "Invalid column name. Only letters, numbers, and underscores are allowed, and it must start with a letter or underscore."
        return 1
    fi

    # Check if the column name is already in the list (duplicate check)
    if [[ " ${ColArray[@]} " =~ " $ColName " ]]; then
        echo "Column name '$ColName' already exists. Please enter a unique name."
        return 1
    fi

    return 0  # Valid column name
}




function num_verify() {
    numbers=$1
    if [[ $numbers =~ ^[0-9]+$ ]]; then
        echo true
    else
        echo false
    fi
    
}

function pk_verify() {
    
    if [[ $# -gt 0 ]]; then
        pk_inp=$1
        pk_f=$2
        table_name=$3
        uniq=1
        for num in $(cut -d : -f $pk_f $table_name); do
        
            if [[ $pk_inp = $num ]]; then 
                uniq=0;
                break;
            fi
            
        done;

        if [ $uniq -eq 1 ]; then
            echo "This is unique"
        else
            echo "This is not unique"
        fi;
    else
        echo "Please enter a value";
    fi;
}

