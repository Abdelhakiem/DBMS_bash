#!/bin/bash

function num_verify() {
    numbers=$1

    if [[ $numbers =~ ^[0-9]+$ ]]; then
        echo "This is a number"
    else
        echo "This is not a number"
    fi
}

function pk_verify() {
    
    if [[ $# -gt 0 ]]; then
        pk_inp=$1
        pk_f=$2
        table_name=$3
        uniq=1
        for num in $(cut -d : -f $pk_f $table_name); do
        
            if [[ $pk_inp = $num ]]; then 
                uniq=0;
                break;
            fi
            
        done;

        if [ $uniq -eq 1 ]; then
            echo "This is unique"
        else
            echo "This is not unique"
        fi;
    else
        echo "Please enter a value";
    fi;
}

