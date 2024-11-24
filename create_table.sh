#!/bin/bash

function create_table() {
    DBName=$1;
	read -p "Please Enter Table Name: " CreatedTB
    if [ -e "Databases/$DBName/$CreatedTB" ]; then
        echo "Table already exists."
    else
        touch "Databases/$DBName/$CreatedTB"
        read -p "Please Enter Number of Columns: " numCol

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
                    select option in yes no
					do
					print "Do you want to make this Column PK (y/n)? "
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

  