#!/bin/bash

source ./verification.sh
function create_table() {
    DBName=$1;
	CreatedTB=$2
    numCol=$3
    IFS=';' read -r -a input_cols <<< "$4"
	IFS=';' read -r -a input_dtypes <<< "$5"
	PKidx=$6
	((PKidx--))
	if ! validate_table_name $CreatedTB; then
        return 
    fi
	if [ -e "Databases/$DBName/$CreatedTB" ]; then
        echo "Table already exists."
    else
        touch "Databases/$DBName/$CreatedTB"

       
		if ! [[ "$numCol" =~ ^[1-9][0-9]*$ ]]; then
			echo "Invalid input. Number of columns must be a positive integer."
			rm -f "Databases/$DBName/$CreatedTB"
			return
		fi

        if [ "$numCol" -gt 0 ]; then
            for ((i = 0; i < numCol; i++)); do
                line=""
				declare -a ColArray
				
				ColName="${input_cols[$i]}"
				if validate_column_name "$ColName" ColArray[@]; then
					ColArray+=("$ColName")
					line+=":$ColName"
					
				else
					echo -e "Please enter a valid column name."
					exit
				fi
				
					colType="${input_dtypes[$i]}"
				
				line+=":$colType"
                
				if [ "$PKidx" -eq $i ]; then
					line+=":PK"
				else
					line+=":"
                fi

                echo "${line:1}" >> "Databases/$DBName/.meta$CreatedTB"
            done
        fi
		echo -e "Table is created successfully."
    fi
}
create_table $1 $2 $3 $4 $5 $6
  