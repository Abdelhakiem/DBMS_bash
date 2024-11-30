#!/bin/bash
source './where.sh'
source './verification.sh'

function delete_from_table() {
    DBname=$1
    table_name=$2
    colname=$3
    operator=$4
    colval=$5
    
    if ! validate_table_name "$table_name"; then
        return
    fi

    file_path="Databases/$DBname/$table_name"
    meta_file_path="Databases/$DBname/.meta$table_name"

    if [[ ! -e $file_path ]]; then
        echo -e "Table does not exist."
        return
    fi

    coln=$(colmapping $DBname $table_name $colname)

    if [[ $coln = -1 ]]; then
        echo -e "Column not found."
        return
    fi

    # Get column type
    col_type=$(awk -F: -v col="$colname" '
        {
            if ($1 == col) {
                print $2
                exit
            }
        }
    ' "$meta_file_path")

    # Choose operator based on column type
    
    # Validate value based on column type
    if [[ $col_type == "number" && ! $colval =~ ^[0-9]+$ ]]; then
        echo -e "Invalid input: Expected a numeric value."
        return
    elif [[ $col_type == "string" && -z "$colval" ]]; then
        echo -e "Invalid input: String value cannot be empty."
        return
    fi

    # Filter rows based on the condition and rewrite the table
    newtable=$(awk -v colnum="$coln" -v op="$operator" -v val="$colval" '
        BEGIN { FS = ":"; OFS = ":" }
        {
            if ((op == "=" && $colnum == val) ||
                (op == "<" && $colnum < val) ||
                (op == ">" && $colnum > val) ||
                (op == "!=" && $colnum != val)) {
                next
            }
                print $0
        }
    ' "$file_path")

    echo "$newtable" > "$file_path"
    echo -e "Deletion successful. Updated Table:"
    
}
delete_from_table $1 $2 $3 $4 $5