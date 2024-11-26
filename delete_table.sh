#!/bin/bash
source './where.sh'

function delete_from_table(){
	DBname=$1;
    table_name=$2;
    file_path="Databases/$1/$2"
    
    if [[ ! -e $file_path ]]; then
        echo "Table does not exist"
        exit
    fi

    read -p "Enter Condition Column" colname;
    read -p "Enter  the equality Column value" colval;
    
    coln=$(colmapping $DBname $table_name $colname)
    
    if [[ $coln = -1 ]]; then
    echo "Col not found";
    exit;
    fi;
    
    rown=$(rowmapping $DBname $table_name $coln $colval)
    
    if [[ $rown = -1 ]]; then
    echo "Row not found";
    exit;
    fi;

    sed -i "${rown}d" "$file_path"
	cat $file_path;
}
delete_from_table $1 $2
