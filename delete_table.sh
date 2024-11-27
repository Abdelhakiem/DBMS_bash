#!/bin/bash
source './where.sh'

function delete_from_table(){
	
    DBname=$1;

    read -p "Enter Table Name" table_name;
   	if ! validate_table_name $table_name; then
        return 
    fi

    
    file_path="Databases/$DBname/$table_name"
    
    if [[ ! -e $file_path ]]; then
        echo "Table does not exist"
        exit
    fi

    read -p "Enter Condition Column" colname;
    
    coln=$(colmapping $DBname $table_name $colname)
    
    if [[ $coln = -1 ]]; then
    echo "Col not found";
    exit;
    fi;
    
    read -p "Enter  the equality Column value" colval;
    
    newtable=$(awk -v colnum="$coln" -v val="$colval" 'BEGIN {
        FS=":"
    } 
    {
        if ($colnum != val)
            print $0
    }' "$file_path")

    echo "$newtable" > "$file_path"

    cat "$file_path"
}