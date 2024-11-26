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

	col_setn=$(colmapping $DBname $table_name $col_set)
    
	if [[ $col_setn = -1 ]]; then
    echo "Col not found";
    exit;
    fi;


	read -p "Enter The New Value" newval



    read -p "Enter Condition Column" col_cond;
    
    col_condn=$(colmapping $DBname $table_name $col_cond)
    
    if [[ $col_condn = -1 ]]; then
    echo "Col not found";
    exit;
    fi;

	read -p "Enter Condition Column" val_cond;
    
    newtable=$(awk -v col=$col_setn -v val=$newval -v condcol=$col_condn -v condval=$val_cond  '
					BEGIN {
						FS=":";
						OFS = ":"; 
					} 
					{
						if ($condcol==condval)
							{$col=val}   
							print ($0)
					} 
					END {}' "$file_path")

	echo "$newtable" > "$file_path"

	cat "$file_path"
}
 
update_table $1