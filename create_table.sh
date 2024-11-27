#!/bin/bash

function create_table() {
    DBName=$1;
	read -p "Please Enter Table Name: " CreatedTB
	if ! validate_table_name $CreatedTB; then
        return 
    fi
	if [ -e "Databases/$DBName/$CreatedTB" ]; then
        echo "Table already exists."
    else
        touch "Databases/$DBName/$CreatedTB"

        read -p "Please Enter Number of Columns: " numCol
		if ! [[ "$numCol" =~ ^[1-9][0-9]*$ ]]; then
			echo "Invalid input. Number of columns must be a positive integer."
			rm -f "Databases/$DBName/$CreatedTB"
			return
		fi

        if [ "$numCol" -gt 0 ]; then
            pk=0
            for ((i = 0; i < numCol; i++)); do
                line=""
                read -p "Please Enter Column Name: " ColName
                line+=":$ColName"
				select option in Number String
				do
					case $option in 
					"Number")
						colType="number"
						break
						;;
					"String")
						colType="string"
						break
						;;
					esac
				
				done
				line+=":$colType"
                if [ "$pk" -eq 0 ]; then
					echo -e "\033[34mDo you want to make this Column PK (y/n)?\033[0m"
                    select option in yes no
					do
					case $option in 
					"yes")
						line+=":PK"
                        pk=1
						break
						;;
					"no")
						line+=":"
						break
						;;
					esac
				done
                fi

                echo "${line:1}" >> "Databases/$DBName/.meta$CreatedTB"
            done
        fi

        echo "Table is created successfully."
    fi
}