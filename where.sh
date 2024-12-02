#!/bin/bash

function colmapping(){
DBname=$1
metafile=".meta$2"
colname=$3
file_path="Databases/$DBname/$metafile"
# Use awk with -v to pass variables and capture the output
result=$(awk -v val=$colname 'BEGIN{
		FS=":"
		row=-1
	}{
        if( $1 == val )
        {
            row = NR
        }
        

	}END{
        print(row)
	}
' $file_path)
echo $result;
}

function rowmapping(){
DBname=$1
table=$2
col=$3
val=$4
file_path="Databases/$DBname/$table"
# Use awk with -v to pass variables and capture the output
result=$(awk -v colv=$col -v val=$val 'BEGIN{
		FS=":"
		row=-1
	}{
        if( $colv == val )
        {
            row = NR
        }
        

	}END{
        print(row)
	}
' $file_path)
echo $result;

}
#coln=$(colmapping 'hr' 'emmployees' 'name')
#rowmapping 'hr' 'emmployees' $coln 'hazem'
