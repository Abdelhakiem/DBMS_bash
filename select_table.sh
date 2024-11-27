#!/bin/bash
source './where.sh'
source './verification.sh'

select_from_where() {
    local content_file_path=$1
    local meta_file_path=$2
    local option=$3
    local headers=$(awk -F: '{print $1}' "$meta_file_path" | tr '\n' '\t')

    echo "--------------------------------------------------------"
    echo -e "\033[32m$headers\033[0m"
    echo "--------------------------------------------------------"
    # Displaying the whole table:
        if [[ $option -eq 1 ]]; then
            table_body=$(awk 'BEGIN {
                    FS=":"
                    OFS="\t"  
                }                 {
                    for (i = 1; i <= NF; i++) {
                    printf "%s ", $i  # Print each field followed by a space
                    }
                    printf "\n"  # Print a newline after each record
                }
                ' "$content_file_path" | column -t)
        # Filter with specific field value:
        elif [[ $option -eq 2 ]]; then
                local col_num=$4
                local col_value=$5
                table_body=$(awk -v colnum="$col_num" -v val="$col_value" '
                    BEGIN {
                        FS = ":"   # Set input field separator to ":"
                        OFS = "\t" # Set output field separator to tab
                    }
                    {
                        if ($colnum == val) {
                            for (i = 1; i <= NF; i++) {
                                printf "%s ", $i  
                            }
                        } printf "\n" 
                    }
                ' "$content_file_path" | column -t)      
        fi
        echo -e "\033[33m$table_body\033[0m"
}



function select_table() {
    DBname=$1

    read -p "Enter Table Name: " table_name
    if ! validate_table_name $table_name; then
        return 
    fi


    file_path="Databases/$DBname/$table_name"
    meta_file_path="Databases/$DBname/.meta$table_name"

    if [[ ! -e $file_path ]]; then
        echo "Table does not exist."
        exit 1
    fi
    echo "Select an Option: "
    	select option in whole_table search_with_specific_key exit 
				do
					case $option in 
					"whole_table")
                        select_from_where $file_path $meta_file_path 1
						break
						;;
					"search_with_specific_key")
                        read -p "Enter Column you want to search based on: " col_search
                	    col_num=$(colmapping $DBname $table_name $col_search)
                        if [[ $col_num = -1 ]]; then
                                echo "Col not found";
                                exit;
                        fi;
                        read -p "Enter The Search Value: " col_value

                        col_type=$(awk -F: -v col="$col_search" '
                            {
                                if ($1 == col) {
                                    split($2, type, ":")
                                    print $2
                                    exit
                                }
                            }
                        ' "Databases/$DBname/.meta$table_name")
                        case "$col_type" in
                            'number')
                                if ! [[ "$col_value" =~ ^[0-9]+$ ]]; then
                                    echo "Invalid input: Expected a numeric value."
                                    exit
                                fi
                                ;;
                            'string')
                                if ! [[ "$col_value" =~ [a-zA-Z]+ ]]; then
                                    echo "Invalid input: Expected a string value."
                                    exit
                                fi
                                ;;
                        esac

                        select_from_where "$file_path" "$meta_file_path" 2 "$col_num" "$col_value"
                        break
                        ;;
                    "exit")
						break
						;;
                        *)
                        echo INVALID OPTION PLEASE TRY AGAIN
                    
					esac
				
				done

    
   
}
