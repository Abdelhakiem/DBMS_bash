#!/bin/bash
function rowmapping(){
DBname=$$1
col=$3
val=$4

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
' $2)
echo $result;

}
rowmapping 'hr' 'emmployees' 2 'osama'
