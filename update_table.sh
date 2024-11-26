#!/bin/bash

source './where.sh'

function update_table(){
	
    DBname=$1;

    read -p "Enter Table Name" table_name;
    
    file_path="Databases/$DBname/$table_name"
    
    if [[ ! -e $file_path ]]; then
        echo "Table does not exist"
        exit
    fi

	read -p "Enter Column you want to set its value" col_set

	read -p "Enter The New Value" newval
	
    read -p "Enter Condition Column" colname;
    
    condcoln=$(colmapping $DBname $table_name $colname)
    
    if [[ $coln = -1 ]]; then
    echo "Col not found";
    exit;
    fi;
    
    read -p "Enter  the equality Column value" colval;
    
    rown=$(rowmapping $DBname $table_name $coln $colval)
    
    if [[ $rown = -1 ]]; then
    echo "Row not found";
    exit;
    fi;

    sed -i "${rown}d" "$file_path"
	cat $file_path;
}
 
