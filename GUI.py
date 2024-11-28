import subprocess
import streamlit as st
import pandas as pd
import warnings  # Importing the warnings library
st.set_option('deprecation.showfileUploaderEncoding', False)
warnings.filterwarnings("ignore", category=UserWarning, module="streamlit")

# Suppress all warnings
warnings.filterwarnings("ignore")
git_bash_path = "C:\\Program Files\\Git\\bin\\bash.exe"
DBName=None
# Placeholder functions for database operations
def create_db(db_name):
    results = subprocess.run([git_bash_path, "create_db.sh", db_name], capture_output=True, text=True)
    return results.stdout

def list_dbs():
    st.info("Listing all databases...")
    # Example databases
    results = subprocess.run([git_bash_path, "ls_dbs.sh"], capture_output=True, text=True)
    databases = results.stdout.splitlines() 
    st.write("Databases:")
    st.table(databases)

def connect_db(db_name):
    results = subprocess.run([git_bash_path, "connect_db.sh",db_name], capture_output=True, text=True)
    msg=results.stdout.strip()
    return msg
    

def drop_db(db_name):
    results = subprocess.run([git_bash_path, "drop_db.sh",db_name], capture_output=True, text=True)
    output = results.stdout
    return output

def create_table(db_name,table_name,num_rows,colnames,dtypes,pkn):
    results = subprocess.run([git_bash_path, "create_table.sh",db_name,table_name,str(num_rows),colnames,dtypes,str(pkn)], capture_output=True, text=True)
    output = results.stdout
    return output

def list_tables(db_name):
    st.info("Listing all tables...")
    # Example tables
    results = subprocess.run([git_bash_path, "list_tables.sh",db_name], capture_output=True, text=True)
    tables = results.stdout.splitlines()
    st.write("Tables:")
    st.table(tables)

def drop_table(db_name,table_name):
    results = subprocess.run([git_bash_path, "drop_table.sh",db_name,table_name], capture_output=True, text=True)
    msg = results.stdout
    return msg
    
def insert_into_table(db_name,table_name,fields):
    results = subprocess.run([git_bash_path, "insert_table.sh",db_name,table_name,fields], capture_output=True, text=True)
    st.success("Data inserted into table successfully!")

def select_from_table(db_name,table_name,cond_col,cond_val):
    results = subprocess.run([git_bash_path, "select_table.sh",db_name,table_name,cond_col,cond_val], capture_output=True, text=True)
    msg = results.stdout
    return msg

def delete_from_table(db_name,table_name,cond_col,cond_val):
    results = subprocess.run([git_bash_path, "delete_table.sh",db_name,table_name,cond_col,cond_val], capture_output=True, text=True)
    msg = results.stdout
    return msg

def update_table(db_name,table_name,update_col,update_val,cond_col,cond_val):
    results = subprocess.run([git_bash_path, "update_table.sh",db_name,table_name,update_col,update_val,cond_col,cond_val], capture_output=True, text=True)
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
        table_name=st.text_input("Enter Table name to Create:")
        num_rows = st.number_input("Number of rows", min_value=1, max_value=100, value=5)
        # Create an empty list to store user inputs
        data = []

        # Dynamic form for input
        form = st.form("dynamic_table_form")
        st.write("Enter data for the table:")

        for i in range(num_rows):
            with form:
                # Create 3 columns
                col1, col2 = st.columns(2)
                name = col1.text_input(f"Name (Row {i + 1})", key=f"name_{i}")
                datatype = col2.selectbox("Datatype", ['number','string'], key=f"age_{i}",)
                data.append({"Name": name, "Datatype": datatype})
                if i ==num_rows-1:
                    pk = st.selectbox("chose the primary key",["None"]+list(range(1,num_rows+1))),
        # Submit button

        df = pd.DataFrame(data)
        if form.form_submit_button("Submit") and all(df['Name'].to_list()):
            # Convert the collected data into a DataFrame
            #st.write(num_rows)
            colnames=";".join(df['Name'].to_list())
            #st.write(colnames)
            dtypes=";".join(df['Datatype'].to_list())
            #st.write(dtypes)
            pkn=pk[0]
            #st.write(pkn)
            msg=create_table(db_name,table_name,num_rows,colnames,dtypes,pkn)
            st.success(msg)
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
###########################################

# Initialize session state for 'display_fields'
    if "display_fields" not in st.session_state:
        st.session_state.display_fields = False

    # Expander for adding a row
    with st.expander("Add Row?"):
        # Input for table name
        table_name = st.text_input("Enter Table name to Add Row:")

        # Button to display input fields
        if st.button("Display Table Input Fields", key="display_button"):
            if table_name:
                st.session_state.display_fields = True  # Update session state to display fields

        # Check session state to display input fields
        if st.session_state.display_fields and table_name:
            # Run the subprocess command
            results = subprocess.run(
                [git_bash_path, "-c", f"cut -d ':' -f 1 Databases/{db_name}/.meta{table_name}"],
                capture_output=True,
                text=True,
                check=True
            )

            # Generate input fields for the table
            fields = []
            for col in results.stdout.splitlines():
                fields.append(st.text_input(f"Enter {col}", key=f"{table_name}_{col}"))

            # Button to insert into the table
            if st.button("Insert Into Table", key="insert_button"):
                conc_fields=";".join(fields)
                fields=st.write(conc_fields)
                msg = insert_into_table(db_name, table_name,conc_fields)
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
                [git_bash_path, "-c", f"cut -d ':' -f 1 Databases/{db_name}/.meta{table_name}"],  # -c is required for passing commands to Git Bash
                capture_output=True,
                text=True)
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
