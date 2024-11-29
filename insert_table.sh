#!/bin/bash
source './where.sh'

function insert_table() {
    DBname=$1

    read -p "Enter Table Name: " table_name
    if ! validate_table_name $table_name; then
        return 
    fi


    file_path="Databases/$DBname/$table_name"
    meta_file_path="Databases/$DBname/.meta$table_name"

    if [[ ! -e $file_path ]]; then
        echo -e "\033[31mTable does not exist.\033[0m"
        exit 1
    fi

    declare -i num_columns=$(wc -l < "$meta_file_path")

    row=""
    for (( i=1; i<=$num_columns; i++ )); do
        column_name=$(awk -F: -v col=$i 'NR==col {print $1}' "$meta_file_path")
        column_type=$(awk -F: -v col=$i 'NR==col {print $2}' "$meta_file_path")
        is_PK=$(test "$(awk -F: -v col=$i 'NR==col {print $3}' "$meta_file_path")" = "PK" && echo True || echo False)
        
        while true; do
            read -p "Enter value for $column_name ($column_type): " value
            
            # Check uniqueness if column is a primary key
            if [[ $is_PK == "True" ]]; then
                is_Exist=$(cut -d: -f$i "$file_path" | grep -c "^$value$")
                if [[ $is_Exist -eq 1 ]]; then
                    echo "Value '$value' for $column_name must be unique (PK). Please try again."
                    continue
                fi
            fi

            # Validate input type
            if [[ $column_type == "number" ]]; then
                if [[ $value =~ ^[0-9]+$ ]]; then
                    break
                else
        			echo -e "\033[31mInvalid input. Please enter a valid number.\033[0m"
                fi
            elif [[ $column_type == "string" ]]; then
                if [[ "$value" =~ ^[a-zA-Z0-9_]+$ ]]; then
                    break
                else
                 	echo -e "\033[31mInvalid input. Please enter a valid string.\033[0m"
                fi
            fi
        done
        row="$row:$value"
    done

    row="${row:1}"
    echo "$row" >> "$file_path"
    echo -e "\033[32mRow inserted successfully.\033[0m"
}