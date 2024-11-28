#!/bin/bash
source './where.sh'

function delete_from_table(){
	
    DBname=$1;
    table_name=$2;
    colname=$3
    colval=$4

    file_path="Databases/$DBname/$table_name"
    
    if [[ ! -e $file_path ]]; then
        echo "Table does not exist"
        exit
    fi

    
    coln=$(colmapping $DBname $table_name $colname)
    
    if [[ $coln = -1 ]]; then
    echo "Col not found";
    exit;
    fi;
    
    
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
delete_from_table $1 $2 $3 $4