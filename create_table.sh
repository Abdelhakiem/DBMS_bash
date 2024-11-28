#!/bin/bash

function create_table() {
    DBName=$1;
	CreatedTB=$2;
	numCol=$3;
	IFS=';' read -r -a col_array <<< "$4"
	IFS=';' read -r -a dtype_array <<< "$5"
	primarykey=$6
	((primarykey--))

    if [ -e "Databases/$DBName/$CreatedTB" ]; then
        echo "Table already exists."
    else
        touch "Databases/$DBName/$CreatedTB"

        if [ "$numCol" -gt 0 ]; then
            pk=0
            for ((i = 0; i < numCol; i++)); do
                line=""
                ColName="${col_array[$i]}"
                line+=":$ColName"
				colType="${dtype_array[$i]}"
				line+=":$colType"
                if [ "$primarykey" -eq $i ]; then
                    	line+=":PK"
				else
						line+=":"
                fi

                echo "${line:1}" >> "Databases/$DBName/.meta$CreatedTB"
            done
        fi

        echo "Table is created successfully."
    fi
}
create_table $1 $2 $3 $4 $5 $6
  