#!/bin/bash

function TableCommands() {
    DBName=$1
    echo -e "\033[33mSelect an option from the following table operations:\033[0m"
    select option in Create List Drop Insert Select Delete Update Exit
    do
        case $option in 
            "Create")
                create_table "$DBName"
                ;;
            "List")
                list_tables "$DBName"
                ;;
            "Drop")
                drop_table "$DBName"
                ;;
            "Insert")
                insert_table "$DBName"
                ;;
            "Select")
                select_table "$DBName"
                ;;
            "Delete")
                delete_from_table "$DBName"
                ;;
            "Update")
                update_table "$DBName"
                ;;
            "Exit")
                break
                ;;
            *)
                echo "Invalid Option. Please try again."
        esac
    done
}
