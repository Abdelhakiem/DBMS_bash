#!/bin/bash
source './where.sh'
source './verification.sh'

function delete_from_table() {
    DBname=$1

    read -p "Enter Table Name: " table_name
    if ! validate_table_name "$table_name"; then
        return
    fi

    file_path="Databases/$DBname/$table_name"
    meta_file_path="Databases/$DBname/.meta$table_name"

    if [[ ! -e $file_path ]]; then
        echo -e "\033[31mTable does not exist.\033[0m"
        return
    fi

    read -p "Enter Column you want to delete based on: " colname
    coln=$(colmapping $DBname $table_name $colname)

    if [[ $coln = -1 ]]; then
        echo -e "\033[31mColumn not found.\033[0m"
        return
    fi

    # Get column type
    col_type=$(awk -F: -v col="$colname" '
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

    read -p "Enter the Column Value: " colval

    # Validate value based on column type
    if [[ $col_type == "number" && ! $colval =~ ^[0-9]+$ ]]; then
        echo -e "\033[31mInvalid input: Expected a numeric value.\033[0m"
        return
    elif [[ $col_type == "string" && -z "$colval" ]]; then
        echo -e "\033[31mInvalid input: String value cannot be empty.\033[0m"
        return
    fi

    # Filter rows based on the condition and rewrite the table
    newtable=$(awk -v colnum="$coln" -v op="$operator" -v val="$colval" '
        BEGIN { FS = ":"; OFS = ":" }
        {
            if ((op == "=" && $colnum == val) ||
                (op == "<" && $colnum < val) ||
                (op == ">" && $colnum > val) ||
                (op == "!=" && $colnum != val)) {
                next
            }
                print $0
        }
    ' "$file_path")

    echo "$newtable" > "$file_path"
    echo -e "\033[32mDeletion successful. Updated Table:\033[0m"
    cat "$file_path"
}
