#!/bin/bash
source './where.sh'
source './verification.sh'



select_from_where() {
    local content_file_path=$1
    local meta_file_path=$2
    local option=$3

    # Display the whole table
    if [[ $option -eq 1 ]]; then
        local headers=$(awk -F: '{print $1}' "$meta_file_path" | tr '\n' '\t')
        echo "--------------------------------------------------------"
        echo -e "\033[32m$headers\033[0m"
        echo "--------------------------------------------------------"

        table_body=$(awk 'BEGIN {
                FS=":"
                OFS="\t"
            } 
            {
                for (i = 1; i <= NF; i++) {
                    printf "%s ", $i  # Print each field followed by a space
                }
                printf "\n"  # Print a newline after each record
            }' "$content_file_path" | column -t)

    # Filter with a specific field value using comparison operator
    elif [[ $option -eq 2 ]]; then
        local headers=$(awk -F: '{print $1}' "$meta_file_path" | tr '\n' '\t')
        echo "--------------------------------------------------------"
        echo -e "\033[32m$headers\033[0m"
        echo "--------------------------------------------------------"

        local col_num=$4
        local operator=$5
        local col_value=$6

        table_body=$(awk -v colnum="$col_num" -v op="$operator" -v val="$col_value" '
            BEGIN {
                FS = ":"
                OFS = "\t"
            }
            {
                if ((op == "=" && $colnum == val) ||
                    (op == "<" && $colnum < val) ||
                    (op == ">" && $colnum > val) ||
                    (op == "!=" && $colnum != val)) {
                    for (i = 1; i <= NF; i++) {
                        printf "%s ", $i
                    }
                    printf "\n"
                }
            }' "$content_file_path" | column -t)

    # Display specific columns
    elif [[ $option -eq 3 ]]; then
        local selected_cols=("${!4}")
        
        local headers=$(awk -v cols="${selected_cols[*]}" '
                BEGIN {
                    FS = ":"
                    OFS = "\t"
                    split(cols, col_indices, " ")
                }
                {
                    for (i in col_indices) {
                        if ( NR == col_indices[i] ){
                            print $1
                        }
                    }
                }' "$meta_file_path" | tr '\n' '\t')
        echo "--------------------------------------------------------"
        echo -e "\033[32m$headers\033[0m"
        echo "--------------------------------------------------------"

        table_body=$(awk -v cols="${selected_cols[*]}" '
            BEGIN {
                FS = ":"
                OFS = "\t"
                split(cols, rev_col_indices, " ")
                for (i = 1; i <= length(rev_col_indices); i++) {
                   col_indices[length(rev_col_indices) - i + 1] = rev_col_indices[i]
                 }
            }
            {
                for (i in col_indices) {
                    printf "%s ", $col_indices[i]
                }
                printf "\n"
            }' "$content_file_path" | column -t)
    fi
    # 

    echo -e "\033[33m$table_body\033[0m"
}

# Function to select and display data from a table
function select_table() {
    DBname=$1

    read -p "Enter Table Name: " table_name
    if ! validate_table_name "$table_name"; then
        return
    fi

    file_path="Databases/$DBname/$table_name"
    meta_file_path="Databases/$DBname/.meta$table_name"

    if [[ ! -e $file_path ]]; then
        echo "Table does not exist."
        exit 1
    fi

    echo "Select an Option: "
    select option in whole_table search_with_specific_key select_specific_columns exit; do
        case $option in
        "whole_table")
            select_from_where "$file_path" "$meta_file_path" 1
            break
            ;;
        "search_with_specific_key")
            read -p "Enter Column you want to search based on: " col_search
            col_num=$(colmapping $DBname $table_name $col_search)
            if [[ $col_num = -1 ]]; then
                echo "Column not found."
                exit
            fi

            # Get column type
            col_type=$(awk -F: -v col="$col_search" '
                {
                    if ($1 == col) {
                        print $2
                        exit
                    }
                }
            ' "$meta_file_path")

            # Choose operator based on column type
            echo -e "\033[34mChoose a comparison operator:\033[0m"
            if [[ $col_type == "number" ]]; then
                select operator in = != '<' '>'; do
                    case $operator in
                    "=" | "!=" | "<" | ">")
                        break
                        ;;
                    *)
                        echo "Invalid operator. Please try again."
                        ;;
                    esac
                done
            elif [[ $col_type == "string" ]]; then
                select operator in = '!='; do
                    case $operator in
                    "=" | "!=")
                        break
                        ;;
                    *)
                        echo "Invalid operator. Please try again."
                        ;;
                    esac
                done
            fi

            read -p "Enter the Search Value: " col_value

            # Validate value based on column type
            if [[ $col_type == "number" && ! $col_value =~ ^[0-9]+$ ]]; then
                echo "Invalid input: Expected a numeric value."
                exit
            elif [[ $col_type == "string" && -z "$col_value" ]]; then
                echo "Invalid input: String value cannot be empty."
                exit
            fi

            select_from_where "$file_path" "$meta_file_path" 2 "$col_num" "$operator" "$col_value"
            break
            ;;
        "select_specific_columns")
            # Get all available columns and their indices
            columns=($(awk -F: '{print $1}' "$meta_file_path"))
            echo "Available Columns:"
            for i in "${!columns[@]}"; do
                echo "$((i + 1)). ${columns[i]}"
            done

            read -p "Enter the numbers of the columns you want to display (space-separated): " -a selected_indices
            if [ ${#selected_indices[@]} -eq 0 ]; then
                echo "No columns selected. Please try again."
            else
                select_from_where "$file_path" "$meta_file_path" 3 selected_indices[@]
            fi
            break
            ;;
        "exit")
            break
            ;;
        *)
            echo "Invalid option. Please try again."
            ;;
        esac
    done
}
select_table $1