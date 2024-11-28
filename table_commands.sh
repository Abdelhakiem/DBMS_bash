#!/bin/bash

function TableCommands() {
    DBName=$1

    while true; do
        clear
        echo -e "\033[33m=== Table Operations for Database: $DBName ===\033[0m"
        echo -e "1) Create Table"
        echo -e "2) List Tables"
        echo -e "3) Drop Table"
        echo -e "4) Insert into Table"
        echo -e "5) Select from Table"
        echo -e "6) Delete from Table"
        echo -e "7) Update Table"
        echo -e "8) Back to Main Menu"

        read -p "Enter your choice [1-8]: " choice

        case $choice in
            1)
                clear
                echo -e "\033[34m--- Create Table ---\033[0m"
                create_table "$DBName"
                ;;
            2)
                clear
                echo -e "\033[34m--- List Tables ---\033[0m"
                list_tables "$DBName"
                ;;
            3)
                clear
                echo -e "\033[34m--- Drop Table ---\033[0m"
                drop_table "$DBName"
                ;;
            4)
                clear
                echo -e "\033[34m--- Insert into Table ---\033[0m"
                insert_table "$DBName"
                ;;
            5)
                clear
                echo -e "\033[34m--- Select from Table ---\033[0m"
                select_table "$DBName"
                ;;
            6)
                clear
                echo -e "\033[34m--- Delete from Table ---\033[0m"
                delete_from_table "$DBName"
                ;;
            7)
                clear
                echo -e "\033[34m--- Update Table ---\033[0m"
                update_table "$DBName"
                ;;
            8)
                break
                ;;
            *)
                echo -e "\033[31mInvalid option! Please select a number between 1 and 8.\033[0m"
                ;;
        esac

        echo -e "\nPress Enter to return to the table menu..."
        read
    done
}
