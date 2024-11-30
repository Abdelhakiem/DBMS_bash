#!/bin/bash

source './where.sh'
source './verification.sh'

#DBname=$1
#table_name=$2
#IFS=';' read -r -a input_array <<< "$3"

 
function insert_table() {
    DBname=$1
    table_name=$2
    IFS=';' read -r -a input_array <<< "$3"

    if ! validate_table_name $table_name; then
        return 
    fi


    file_path="Databases/$DBname/$table_name"
    meta_file_path="Databases/$DBname/.meta$table_name"

    if [[ ! -e $file_path ]]; then
        echo -e "Table does not exist."
        exit 1
    fi

    declare -i num_columns=$(wc -l < "$meta_file_path")

    row=""
    for (( i=1; i<=$num_columns; i++ )); do
        column_name=$(awk -F: -v col=$i 'NR==col {print $1}' "$meta_file_path")
        column_type=$(awk -F: -v col=$i 'NR==col {print $2}' "$meta_file_path")
        is_PK=$(test "$(awk -F: -v col=$i 'NR==col {print $3}' "$meta_file_path")" = "PK" && echo True || echo False)
        
       
            idx=$((i-1))
            value="${input_array[$idx]}"
            
            # Check uniqueness if column is a primary key
            if [[ $is_PK == "True" ]]; then
                is_Exist=$(cut -d: -f$i "$file_path" | grep -c "^$value$")
                if [[ $is_Exist -eq 1 ]]; then
                    echo "Value '$value' for $column_name must be unique (PK). Please try again."
                    exit
                fi
            fi

            # Validate input type
            if [[ $column_type == "number" ]]; then
                if [[ $value =~ ^[0-9]+$ ]]; then
                    row="$row:$value"
                    continue
                else
        			echo -e "Invalid input. Please enter a valid number."
                    exit
                fi
            elif [[ $column_type == "string" ]]; then
                if [[ "$value" =~ ^[a-zA-Z0-9_]+$ ]]; then
                    row="$row:$value"
                    continue
                else
                 	echo -e "Invalid input. Please enter a valid string."
                    exit
                fi
            fi
    done

    row="${row:1}"
    echo "$row" >> "$file_path"
    echo -e "Row inserted successfully."
}
insert_table $1 $2 $3
