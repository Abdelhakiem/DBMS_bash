#!/bin/bash

source './where.sh'
source './verification.sh'

function update_table() {
    DBname=$1

    read -p "Enter Table Name: " table_name
    if ! validate_table_name "$table_name"; then
        return
    fi

    file_path="Databases/$DBname/$table_name"
    metafilepath="Databases/$DBname/.meta$table_name"

    if [[ ! -e $file_path ]]; then
        echo -e "\033[31mTable does not exist.\033[0m"
        return
    fi

    # Get column to update
    read -p "Enter Column you want to set its value: " col_set
    col_setn=$(colmapping "$DBname" "$table_name" "$col_set")

    if [[ $col_setn == -1 ]]; then
        echo -e "\033[31mColumn not found.\033[0m"
        return
    fi

    Datatype=$(awk -F: -v col_num="$col_setn" 'NR==col_num {print $2}' "$metafilepath")

    read -p "Enter the New Value: " newval
    if [[ $Datatype == 'number' && ! "$newval" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        echo -e "\033[31mInvalid Datatype: Expected a number.\033[0m"
        return
    elif [[ $Datatype == 'string' && -z "$newval" ]]; then
        echo -e "\033[31mInvalid Datatype: String value cannot be empty.\033[0m"
        return
    fi
	# Check uniqueness if column is a primary key
    is_PK=$(test "$(awk -F: -v col=$col_setn 'NR==col {print $3}' "$metafilepath")" = "PK" && echo True || echo False)
    if [[ $is_PK == "True" ]]; then
        is_Exist=$(cut -d: -f"$col_setn" "$file_path" | grep -c "^$newval$")
        if [[ $is_Exist -ge 1 ]]; then
            echo -e "\033[31mError: Value '$newval' for column '$col_set' must be unique (Primary Key).\033[0m"
            return
        fi
    fi

    # Get condition column
    read -p "Enter Condition Column: " col_cond
    col_condn=$(colmapping "$DBname" "$table_name" "$col_cond")

    if [[ $col_condn == -1 ]]; then
        echo -e "\033[31mCondition Column not found.\033[0m"
        return
    fi

    read -p "Enter Condition Value: " val_cond
    Datatype=$(awk -F: -v col_num="$col_condn" 'NR==col_num {print $2}' "$metafilepath")

    if [[ $Datatype == 'number' && ! "$val_cond" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        echo -e "\033[31mInvalid Datatype: Expected a number.\033[0m"
        return
    elif [[ $Datatype == 'string' && -z "$val_cond" ]]; then
        echo -e "\033[31mInvalid Datatype: String value cannot be empty.\033[0m"
        return
    fi

    # Choose operator based on column type
    echo -e "\033[34mChoose a comparison operator:\033[0m"
    if [[ $Datatype == "number" ]]; then
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
    elif [[ $Datatype == "string" ]]; then
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

    # Update table based on the condition
    newtable=$(awk -v col="$col_setn" -v val="$newval" -v condcol="$col_condn" -v condval="$val_cond" -v op="$operator" '
        BEGIN {
            FS = ":"; OFS = ":"
        }
        {
            if ((op == "=" && $condcol == condval) ||
                (op == "!=" && $condcol != condval) ||
                (op == "<" && $condcol < condval) ||
                (op == ">" && $condcol > condval)) {
                    $col = val
            }
            print $0
        }
    ' "$file_path")

    if [[ -z "$newtable" ]]; then
        echo -e "\033[33mNo matching rows found. No updates performed.\033[0m"
    else
        echo "$newtable" > "$file_path"
        echo -e "\033[32mUpdate successful. Updated Table:\033[0m"
        cat "$file_path"
    fi
}
