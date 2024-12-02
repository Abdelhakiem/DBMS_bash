#!/bin/bash

function ls_dbs(){
	if [ -z "$(ls Databases 2>/dev/null)" ]; then
        echo -e "No databases found!"
    else
        ls Databases
    fi
}
ls_dbs