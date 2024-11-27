#!/bin/bash
source './where.sh'
source './verification.sh'

function insert_table() {
    DBname=$1

    read -p "Enter Table Name: " table_name

    file_path="Databases/$DBname/$table_name"
    meta_file_path="Databases/$DBname/.meta$table_name"

    if [[ ! -e $file_path ]]; then
        echo "Table does not exist."
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
                    echo "Invalid input. Please enter a valid number."
                fi
            elif [[ $column_type == "string" ]]; then
                if [[ "$value" =~ ^[a-zA-Z0-9_]+$ ]]; then
                    break
                else
                    echo "Invalid input. Please enter a valid string."
                fi
            fi
        done
        row="$row:$value"
    done

    row="${row:1}"
    echo "$row" >> "$file_path"
    echo "Row inserted successfully into $table_name."
}

