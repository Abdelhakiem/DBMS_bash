#!/bin/bash
source ./where.sh
function select_table()
{   
    local DBName=$1
    local table_name=$2
    local content_file_path="Databases/$1/$2"

    local col_name=$3
    local col_value=$4
    local col_num=$(colmapping $DBName $table_name $col_name)
    if [ $col_num = -1 ]; then
        echo "Column Not Found";
    fi
    table_body=$(awk -v colnum="$col_num" -v val="$col_value" '
                BEGIN {
                    FS = ":"   # Set input field separator to ":"
                    OFS = "\t" # Set output field separator to tab
                }
                {
                    if ($colnum == val) {
                        print $0
                    } printf "\n" 
                }
            ' "$content_file_path" | column -t)  
    echo "$table_body"
}
select_table $1 $2 $3 $4