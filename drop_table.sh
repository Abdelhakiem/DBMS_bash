#!/bin/bash
source ./verification.sh

function drop_table() {
	DBName=$1
	TableName=$2
  	if ! validate_table_name $TableName; then
        return 
    fi

	if [ -f "Databases/$DBName/$TableName" ]
	then
	# drop the table 
		rm "Databases/$DBName/$TableName"
	#drop metadata
		rm "Databases/$DBName/.meta$TableName"
		echo -e "Dropped Successfully."
	else 
		echo -e "Table does not exist."
	fi
}
drop_table $1 $2