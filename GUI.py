import subprocess
import streamlit as st

git_bash_path = "C:\\Program Files\\Git\\bin\\bash.exe"

# Placeholder functions for database operations
def create_db():
    st.success("Database created successfully!")

def list_dbs():
    
    st.info("Listing all databases...")
    # Example databases
    results=subprocess.run([git_bash_path, "ls_dbs.sh"],capture_output=True,text=True)
    databases =results.stdout 
    st.write("Databases:", databases)
    

def connect_db(db_name):
    if db_name:
        st.success(f"Connected to the database: {db_name}")
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

if page == "main":
    st.title("Database Management")

    st.write("Choose an operation:")

    # Buttons for database operations
    if st.button("CreateDB"):
        create_db()

    if st.button("ListDBs"):
        list_dbs()

    db_name = st.text_input("Enter database name to connect:")
    if st.button("ConnectDB"):
        connect_db(db_name)

    if st.button("DropDB"):
        drop_db()

    # Navigate to table commands page
    if st.button("Go to Table Commands"):
        st.experimental_set_query_params(page="table_commands")

elif page == "table_commands":
    st.title("Table Commands")

    st.write("Choose an operation:")

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


