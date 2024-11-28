import subprocess
import streamlit as st
import pandas as pd
import warnings  # Importing the warnings library

warnings.filterwarnings("ignore", category=UserWarning, module="streamlit")

# Suppress all warnings
warnings.filterwarnings("ignore")
git_bash_path = "./"
DBName=None
# Placeholder functions for database operations
def create_db(db_name):
    results = subprocess.run([ "./create_db.sh", db_name], capture_output=True, text=True)
    return results.stdout

def list_dbs():
    st.info("Listing all databases...")
    # Example databases
    results = subprocess.run(["./ls_dbs.sh"], capture_output=True, text=True)
    databases = results.stdout.splitlines() 
    st.write("Databases:")
    st.table(databases)

def connect_db(db_name):
    results = subprocess.run(["./connect_db.sh",db_name], capture_output=True, text=True)
    msg=results.stdout.strip()
    return msg
    

def drop_db(db_name):
    results = subprocess.run(["./drop_db.sh",db_name], capture_output=True, text=True)
    output = results.stdout
    return output

def create_table():
    st.success("Table created successfully!")

def list_tables(db_name):
    st.info("Listing all tables...")
    # Example tables
    results = subprocess.run([ "./list_tables.sh",db_name], capture_output=True, text=True)
    tables = results.stdout.splitlines()
    st.write("Tables:")
    st.table(tables)

def drop_table(db_name,table_name):
    results = subprocess.run([ "./drop_table.sh",db_name,table_name], capture_output=True, text=True)
    msg = results.stdout
    return msg
    
def insert_into_table():
    st.success("Data inserted into table successfully!")

def select_from_table(db_name,table_name,cond_col,cond_val):
    st.write(subprocess.run([ "pwd"], capture_output=True, text=True).stdout)
    results = subprocess.run([ "./select_table.sh",db_name,table_name,cond_col,cond_val], capture_output=True, text=True)
    msg = results.stdout
    return msg

def delete_from_table(db_name,table_name,cond_col,cond_val):
    results = subprocess.run([ "./delete_table.sh",db_name,table_name,cond_col,cond_val], capture_output=True, text=True)
    msg = results.stdout
    return msg

def update_table(db_name,table_name,update_col,update_val,cond_col,cond_val):
    results = subprocess.run([ "./update_table.sh",db_name,table_name,update_col,update_val,cond_col,cond_val], capture_output=True, text=True)
    msg = results.stdout
    st.write(msg)
    return msg

# Page routing

query_params = st.experimental_get_query_params()
page = query_params.get("page", ["main"])[0]
db_name = query_params.get("db_name", [""])[0]

if page == "main":
    st.title("Database Management")

    st.write("Choose an operation:")

    # Buttons for database operations
    with st.expander("Do You Want To Create Database"):
        # Text input for database name (required)
        db_name_input = st.text_input("Enter the database name:")
        # Button to confirm creation, only enabled if db_name_input is provided
        if db_name_input and st.button("Create DB"):
            msg=create_db(db_name_input)
            st.warning(msg)
        elif not db_name_input:
            st.error("Database name is required!")

    with st.expander("Do You Want To Display All Databases"):
        if st.button("ListDBs"):
            list_dbs()

    with st.expander("Connect to Database?"):
        db_name_input = st.text_input("Enter database name to connect:")
        connect_button=st.button("ConnectDB")
        if connect_button and not db_name_input:
            st.warning("Enter Database Name")
        if connect_button and db_name_input:
            msg=connect_db(db_name_input)
            st.write(msg=="Database Connected Successfully")
            if msg=="Database Connected Successfully":
                st.success(f"Connected to the database: {db_name_input}")
                st.experimental_set_query_params(page="table_commands", db_name=db_name_input)
            else:
                st.error(msg)

    
    with st.expander("Drop Database?"):
        db_name_input = st.text_input("Enter database name to Drop:")
        Drop_button=st.button("DropDB")
        if Drop_button and not db_name_input:
            st.warning("Enter Database")
        if Drop_button and db_name_input:
            msg=drop_db(db_name_input)
            st.warning(msg)
        

elif page == "table_commands" and db_name:
    st.title(f"Table Commands - {db_name}")

    st.write("Choose a table operation:")

    # Buttons for table operations
    
    with st.expander("New Table?"):
        if st.button("Create Table"):
            create_table()

    with st.expander("Display your Tables?"):
        if st.button("List Tables"):
            msg=list_tables(db_name)
            

    with st.expander("Drop Table?"):
        table_name = st.text_input("Enter Table name to Drop:")
        Drop_button=st.button("Drop Table")
        if Drop_button and not table_name:
            st.warning("Enter Database")
        if Drop_button and table_name:
            msg=drop_table(db_name,table_name)
            st.success(msg)
            
    with st.expander("Add Row?"):
        table_name = st.text_input("Enter Table name to Add Row:")
        display_Input_fields=st.button("Display Table Input Fields")
        if display_Input_fields and table_name:
            results = subprocess.run(
                ["cut", "-d", ":", "-f", "1", f"Databases/{db_name}/.meta{table_name}"]
                ,  # -c is required for passing commands to Git Bash
                capture_output=True,
                text=True)
            fields=list()
            for col in results.stdout.splitlines():
                fields.append(st.text_input(f"Enter {col}"))
            insert_button=st.button("Insert Into Table")
            if all(fields) and insert_button:
                msg=insert_into_table(db_name,table_name,fields)
                st.success(msg)


    with st.expander("Diplay rows?"):
        table_name = st.text_input("Enter Table name For Select")
        cond_col = st.text_input("Enter Condition Column For Select: ")
        cond_val = st.text_input("Enter Condition Value For Select: ")
        select_button=st.button("Select From Table")
        if select_button and table_name and cond_col and cond_val:
            st.write("Displaying......")
            msg=select_from_table(db_name,table_name,cond_col,cond_val)
            if ":" in msg:
                results = subprocess.run(
                ["cut", "-d", ":", "-f", "1", f"Databases/{db_name}/.meta{table_name}"],
                capture_output=True,
                text=True
                )
                cols=results.stdout.splitlines()
                st.write(cols)
                df=pd.DataFrame(list(map(lambda msg: msg.split(":"), msg.splitlines())),columns=cols)
                st.table(df)
            else:
                st.error(msg)
        if select_button and not (table_name and cond_col and cond_val):
            st.warning("Enter All inputs")
        

    with st.expander("Delete from table?"):
        table_name = st.text_input("Enter Table name to Delete From:")
        cond_col = st.text_input("Enter Condition Column:")
        cond_val = st.text_input("Enter Condition Value:")
        delete_button=st.button("Delete From Table")
        if delete_button and table_name and cond_col and cond_val:
            st.write("Deleting......")
            delete_from_table(db_name,table_name,cond_col,cond_val)
        if delete_button and not (table_name and cond_col and cond_val):
            st.warning("Enter All inputs")


    with st.expander("Modify Table?"):
        table_name = st.text_input("Enter Table name to Update:")
        set_col = st.text_input("Enter Set Columns:")
        set_val = st.text_input("Enter Set Value:")
        cond_col = st.text_input("Enter Update Condition Column:")
        cond_val = st.text_input("Enter Update Condition Value:")
        update_button=st.button("Update Table")
        if update_button:
            if not table_name or not set_col or not set_val or not cond_col or not cond_val:
                st.error("Please fill in all fields before updating the table.")
            else:
                st.info("Updating table, please wait...")
                msg = update_table(db_name, table_name, set_col, set_val, cond_col, cond_val)
                st.write(msg)




    # Navigate back to the main page
    if st.button("<-- Back to Main"):
        db_name=None
        st.experimental_set_query_params(page="main")

