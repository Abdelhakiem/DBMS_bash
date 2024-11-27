import subprocess
import streamlit as st
import pandas as pd
import warnings  # Importing the warnings library

# Suppress all warnings
warnings.filterwarnings("ignore")
git_bash_path = "C:\\Program Files\\Git\\bin\\bash.exe"

# Placeholder functions for database operations
def create_db():
    st.success("Database created successfully!")

def list_dbs():
    st.info("Listing all databases...")
    # Example databases
    results = subprocess.run([git_bash_path, "ls_dbs.sh"], capture_output=True, text=True)
    databases = results.stdout.splitlines() 
    st.write("Databases:")
    st.table(databases)

def connect_db(db_name):
    if db_name:
        st.success(f"Connected to the database: {db_name}")
        st.experimental_set_query_params(page="table_commands", db_name=db_name)
    else:
        st.error("Please enter a database name to connect.")

def drop_db():
    st.warning("Database dropped successfully!")

def create_table():
    st.success("Table created successfully!")

def list_tables():
    st.info("Listing all tables...")
    # Example tables
    tables = ["Table1", "Table2", "Table3"]
    st.write("Tables:", tables)

def drop_table():
    st.warning("Table dropped successfully!")

def insert_into_table():
    st.success("Data inserted into table successfully!")

def select_from_table():
    st.info("Data selected from table:")
    # Example data
    st.write([{"id": 1, "name": "John"}, {"id": 2, "name": "Jane"}])

def delete_from_table():
    st.warning("Data deleted from table successfully!")

def update_table():
    st.success("Table updated successfully!")

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
            results = subprocess.run([git_bash_path, "create_db.sh", db_name_input], capture_output=True, text=True)
            msg = results.stdout 
            st.write(msg)
        elif not db_name_input:
            st.error("Database name is required!")

    with st.expander("Do You Want To Display All Databases"):
        if st.button("ListDBs"):
            list_dbs()

    with st.expander("Connect to Database?"):
        db_name_input = st.text_input("Enter database name to connect:")
        if st.button("ConnectDB"):
            connect_db(db_name_input)

    if st.button("DropDB"):
        drop_db()

elif page == "table_commands" and db_name:
    st.title(f"Table Commands - {db_name}")

    st.write("Choose a table operation:")

    # Buttons for table operations
    if st.button("Create Table"):
        create_table()

    if st.button("List Tables"):
        list_tables()

    if st.button("Drop Table"):
        drop_table()

    if st.button("Insert into Table"):
        insert_into_table()

    if st.button("Select From Table"):
        select_from_table()

    if st.button("Delete From Table"):
        delete_from_table()

    if st.button("Update Table"):
        update_table()

    # Navigate back to the main page
    if st.button("Back to Main"):
        st.experimental_set_query_params(page="main")
