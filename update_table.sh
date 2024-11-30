#!/bin/bash

source './where.sh'
source './verification.sh'

function update_table() {
    DBname=$1
    table_name=$2
    col_set=$3
	newval=$4
	col_cond=$5
    operator=$6
    val_cond=$7
	
    if ! validate_table_name "$table_name"; then
        return
    fi

    file_path="Databases/$DBname/$table_name"
    metafilepath="Databases/$DBname/.meta$table_name"

    if [[ ! -e $file_path ]]; then
        echo -e "Table does not exist."
        return
    fi

    # Get column to update
    
    col_setn=$(colmapping "$DBname" "$table_name" "$col_set")

    if [[ $col_setn == -1 ]]; then
        echo -e "Column not found."
        return
    fi

    Datatype=$(awk -F: -v col_num="$col_setn" 'NR==col_num {print $2}' "$metafilepath")

    if [[ $Datatype == 'number' && ! "$newval" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        echo -e "Invalid Datatype: Expected a number."
        return
    elif [[ $Datatype == 'string' && -z "$newval" ]]; then
        echo -e "Invalid Datatype: String value cannot be empty."
        return
    fi
	# Check uniqueness if column is a primary key
    is_PK=$(test "$(awk -F: -v col=$col_setn 'NR==col {print $3}' "$metafilepath")" = "PK" && echo True || echo False)
    if [[ $is_PK == "True" ]]; then
        is_Exist=$(cut -d: -f"$col_setn" "$file_path" | grep -c "^$newval$")
        if [[ $is_Exist -ge 1 ]]; then
            echo -e "Error: Value '$col_cond' for column '$col_set' must be unique (Primary Key)."
            return
        fi
    fi

    # Get condition column
    
    col_condn=$(colmapping "$DBname" "$table_name" "$col_cond")

    if [[ $col_condn == -1 ]]; then
        echo -e "Condition Column not found."
        return
    fi

    Datatype=$(awk -F: -v col_num="$col_condn" 'NR==col_num {print $2}' "$metafilepath")

    if [[ $Datatype == 'number' && ! "$val_cond" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        echo -e "Invalid Datatype: Expected a number."
        return
    elif [[ $Datatype == 'string' && -z "$val_cond" ]]; then
        echo -e "Invalid Datatype: String value cannot be empty."
        return
    fi

    # Choose operator based on column type
    

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
        echo -e "No matching rows found. No updates performed."
    else
        echo "$newtable" > "$file_path"
        echo -e "Update successful."
    fi
}
update_table $1 $2 $3 $4 $5 $6 $7