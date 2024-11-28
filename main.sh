#!/bin/bash
source ./create_db.sh
source ./ls_dbs.sh
source ./delete_db.sh
source ./blank_func.sh
source ./list_tables.sh
source ./drop_table.sh
source ./table_commands.sh
source ./connect_db.sh
source ./create_table.sh
source ./verification.sh
source ./delete_table.sh
source ./insert_table.sh
source ./select_table.sh
source ./update_table.sh

function program() {
    while true; do
        clear
        echo -e "\033[32m=== Database Management System ===\033[0m"
        echo -e "Please select an option:"
        echo -e "1) Create Database"
        echo -e "2) List Databases"
        echo -e "3) Connect to Database"
        echo -e "4) Drop Database"
        echo -e "5) Exit"
        
        read -p "Enter your choice [1-5]: " choice

        case $choice in
            1)
                clear
                echo -e "\033[34m--- Create Database ---\033[0m"
                create_db
                ;;
            2)
                clear
                echo -e "\033[34m--- List Databases ---\033[0m"
                ls_dbs
                ;;
            3)
                clear
                echo -e "\033[34m--- Connect to Database ---\033[0m"
                ConnectDB
				;;
            4)
                clear
                echo -e "\033[34m--- Drop Database ---\033[0m"
                delete_db
                ;;
            5)
                echo -e "\033[32mExiting...\033[0m"
                break
                ;;
            *)
                echo -e "\033[31mInvalid option! Please select a number between 1 and 5.\033[0m"
                ;;
        esac

        echo -e "\nPress Enter to return to the main menu..."
        read
    done
}

program
