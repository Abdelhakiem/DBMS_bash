#!/bin/bash

function ls_dbs(){
	if [ -z "$(ls Databases 2>/dev/null)" ]; then
        echo -e "\033[31mNo databases found!\033[0m"
    else
        echo -e "\033[33mExisting Databases:\033[0m"
        ls Databases
    fi
}

