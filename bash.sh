#! /bin/bash 


function create_db(){
	
	read -p "Please Enter Database Name: " DBName
	
	if [ -d "Databases/$DBName" ]
	then
		echo "Database is already exist"
	else 
		mkdir "Databases/$DBName"
		echo "Database is created successfully"
	fi	
}
function ls_dbs(){
	ls Databases
}

function delete_db(){
	
	read -p "Please Enter Database Name: " DBName
	
	if [ -d "Databases/$DBName" ]
	then
		rm "Databases/$DBName" -r
		echo "Database got deleted successfully"
	else 
		echo "Database doesn't exist"
	fi	
}

function blank_func()
{
	echo "Not Implemeted";
}
function list_tables() {
	DBName=$1
	if [ -d "Databases/$DBName" ]
	then
		echo "DataBase Tables:"
		ls "Databases/$DBName"
	else 
		echo "Database doesn't exist"
	fi
}

function drop_table() {
	DBName=$1
	read -p "Please Enter Database Name: " TableName
	
	if [ -f "Databases/$DBName/$TableName" ]
	then
		rm "Databases/$DBName/$TableName"
		echo "Dropped Succesfully"
	else 
		echo "Table Does not exist"
	fi
	}
function TableCommands()
{
	DBName=$1
	select option in Create List Drop Insert Select Delete Update exit
	do
	case $option in 
	"Create")
		blank_func
		;;
	"List")
		list_tables $DBName
		;;
	"Drop")
		drop_table $DBName
		;;
	"Insert")
		blank_func
		;;
	"Select")
		blank_func
		;;
	"Delete")
		blank_func
		;;
	"Update")
		blank_func
		;;
		
	"exit")
		break
		;;
	*)
		echo Wrong Input
	esac

	done
}
function ConnectDB()
{
	read -p "Please Enter Database Name You want to connect to: " DBName
		if [ -d "Databases/$DBName" ]
		then
			echo "Database Connected Succcesfully"
			TableCommands $DBName
		else 
			echo "Database doesn't exist"
		fi
		
		
}
function program()
{
select option in CreateDB ListDBs ConnectDB DropDB exit
do
case $option in 
"CreateDB")
	create_db
	
	;;
"ListDBs")
	ls_dbs
	
	;;
"ConnectDB")
	ConnectDB
	;;
"DropDB")
	delete_db
	;;
"exit")
	break
	;;
*)
	echo Wrong Input
esac

done
}



program 