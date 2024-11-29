#!/bin/bash
validate_indices() {
    local indices=("$@")   # Passed indices as an array
    local num_columns=$1   # Number of available columns
    shift                  # Remove the first argument, which is num_columns

    # Check if each selected index is a valid positive integer within the range of available columns
    for index in "${indices[@]}"; do
        if ! [[ $index =~ ^[0-9]+$ ]] || (( index < 1 || index > num_columns )); then
            return 1  # Invalid index found
        fi
    done

    # Check for duplicate indices
    local unique_indices=($(printf "%s\n" "${indices[@]}" | sort -n | uniq))
    if [[ ${#unique_indices[@]} -ne ${#indices[@]} ]]; then
        return 2  # Duplicate indices found
    fi

    return 0  # All indices are valid
}

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
    local ColArray=("${!2}")  

    if [ -z "$ColName" ]; then
        echo -e "\033[31mColumn name cannot be empty.\033[0m"
        return 1
    fi

    if ! [[ "$ColName" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
        echo -e "\033[31mInvalid column name.\nOnly letters, numbers, and underscores are allowed,\nand it must start with a letter or underscore.\033[0m"
        return 1
    fi

    if [[ " ${ColArray[@]} " =~ " $ColName " ]]; then
        echo -e "\033[31mColumn name '$ColName' already exists. Please enter a unique name.\033[0m"
        return 1
    fi

    return 0
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

