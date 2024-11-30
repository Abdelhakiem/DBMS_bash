import subprocess
import streamlit as st
import pandas as pd
import time
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
    msg=results.stdout
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
    loadingholder=st.empty()
    listing=loadingholder.info("Listing all tables...")
    # Example tables
    time.sleep(1)
    loadingholder.empty()
    results = subprocess.run([git_bash_path, "list_tables.sh",db_name], capture_output=True, text=True)
    msg = results.stdout
    if "Database doesn't exist" in msg:
        st.error("Database doesn't exist")
    else:
        msg = results.stdout.splitlines()
        if len(msg)>0:
            st.write("Existing tables:")
            st.table({"Tables Names":msg})
        else:
            st.error("No tables found in the database")


def drop_table(db_name,table_name):
    results = subprocess.run([git_bash_path, "drop_table.sh",db_name,table_name], capture_output=True, text=True)
    msg = results.stdout
    return msg
    
def insert_into_table(db_name,table_name,fields):
    results = subprocess.run([git_bash_path, "insert_table.sh",db_name,table_name,fields], capture_output=True, text=True)
    return results.stdout

def select_from_table(db_name,table_name,cond_col,cond_val):
    results = subprocess.run([git_bash_path, "select_table.sh",db_name,table_name,cond_col,cond_val], capture_output=True, text=True)
    msg = results.stdout
    return msg

def delete_from_table(db_name,table_name,cond_col,operator,cond_val):
    results = subprocess.run([git_bash_path, "delete_table.sh",db_name,table_name,cond_col,operator,cond_val], capture_output=True, text=True)
    msg = results.stdout
    return msg

def update_table(db_name,table_name,update_col,update_val,cond_col,operator,cond_val):
    results = subprocess.run([git_bash_path, "update_table.sh",db_name,table_name,update_col,update_val,cond_col,operator,cond_val], capture_output=True, text=True)
    msg = results.stdout
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
            if "succ" in msg:
                st.success(msg)
            else:
                st.error(msg)
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
            if "Successfully" in msg:
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
            if "succ" in msg:
                st.success(f"{msg}")
            else:
                st.error(msg)
        

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
        submit_button=form.form_submit_button("Submit")
        if submit_button and not all(df['Name'].to_list()):
            st.warning("Please fill all Column names!!")
        if submit_button and all(df['Name'].to_list()):
            # Convert the collected data into a DataFrame
            #st.write(num_rows)
            colnames=";".join(df['Name'].to_list())
            #st.write(colnames)
            dtypes=";".join(df['Datatype'].to_list())
            #st.write(dtypes)
            pkn=pk[0]
            #st.write(pkn)
            msg=create_table(db_name,table_name,num_rows,colnames,dtypes,pkn)
            if "succ" in msg:
                st.success(msg)
            else:
                st.error(msg)
        

    
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
            if "Successfully" in msg:
                st.success(msg)
            else:
                st.error(msg)
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
            insert_button=st.button("Insert Into Table", key="insert_button")
            if insert_button and not all(fields):
                st.warning("Please fill all fields")
            # Button to insert into the table
            if insert_button and all(fields):
                conc_fields=";".join(fields)
                #st.write(conc_fields)
                msg = insert_into_table(db_name, table_name,conc_fields)
                if "succ" in msg:
                    st.success(msg)
                else:
                    st.error(msg)

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
        meta_file_path=f"Databases/{db_name}/.meta{table_name}"
        bash_script = f"""
                        if [ -f "{meta_file_path}" ]; then
                            echo "Table Found"
                        else
                            echo "Table does not exist"
                        fi
                        """
        result = subprocess.run(
                    [git_bash_path, "-c",bash_script],                    
                    capture_output=True,
                    text=True,
                    check=True)
        
        table_existence = result.stdout.strip()
        if "Table does not exist" in table_existence and table_name:
            st.error("Table doesn't exist")
        elif table_name and "Table Found" in table_existence :
            cond_col = st.text_input("Enter Condition Column:")
            if cond_col:
                result = subprocess.run(
                        [git_bash_path, "-c", 
                        f"awk -F: -v col='{cond_col}' '{{if ($1 == col) {{print $2;exit;}}}}' \"{meta_file_path}\""],
                        capture_output=True,
                        text=True,
                        check=True)
                col_datatype = result.stdout.strip()
                if col_datatype == "number":
                    operators = ["=", "!=", "<", ">"]
                else:
                    operators = ["=", "!="]
                operator= st.selectbox("Choose an operator:", operators)
                cond_val = st.text_input("Enter Condition Value:")
                delete_button=st.button("Delete From Table")
                if delete_button and table_name and cond_col and operator and cond_val:
                    placeholder = st.empty()
                    placeholder.info("Deleting Rows")
                    time.sleep(1)
                    msg=delete_from_table(db_name,table_name,cond_col,operator,cond_val)
                    if "Deletion successful. Updated Table:" in msg:
                        placeholder.success(msg)
                    else:
                        placeholder.error(msg)
                if delete_button and not (table_name and cond_col and operator and cond_val):
                    st.warning("Enter All inputs")


    with st.expander("Modify Table?"):
        table_name = st.text_input("Enter Table name to Update:")
        meta_file_path=f"Databases/{db_name}/.meta{table_name}"
        bash_script = f"""
                        if [ -f "{meta_file_path}" ]; then
                            echo "Table Found"
                        else
                            echo "Table does not exist"
                        fi
                        """
        result = subprocess.run(
                    [git_bash_path, "-c",bash_script],                    
                    capture_output=True,
                    text=True,
                    check=True)
        
        table_existence = result.stdout.strip()
        if "Table does not exist" in table_existence and table_name:
            st.error("Table doesn't exist")
        elif table_name and "Table Found" in table_existence :
            set_col = st.text_input("Enter Set Columns:")
            set_val = st.text_input("Enter Set Value:")
            cond_col = st.text_input("Enter Update Condition Column:")
            if cond_col:
                result = subprocess.run(
                        [git_bash_path, "-c", 
                        f"awk -F: -v col='{cond_col}' '{{if ($1 == col) {{print $2;exit;}}}}' \"{meta_file_path}\""],
                        capture_output=True,
                        text=True,
                        check=True)
                col_datatype = result.stdout.strip()
                if col_datatype == "number":
                    operators = ["=", "!=", "<", ">"]
                else:
                    operators = ["=", "!="]
                operator= st.selectbox("Choose operator:", operators)
                cond_val = st.text_input("Enter Update Condition Value:")
                update_button=st.button("Update Table")
                if update_button:
                    if not table_name or not set_col or not set_val or not cond_col or not cond_val:
                        st.error("Please fill in all fields before updating the table.")
                    else:
                        placeholder = st.empty()
                        placeholder.info("Updating table, please wait...")
                        time.sleep(1)
                        msg = update_table(db_name, table_name, set_col, set_val, cond_col,operator,cond_val)
                        if "Update successful." in msg:
                            placeholder.success(msg)
                        else:
                            placeholder.error(msg)



    # Navigate back to the main page
    if st.button("<-- Back to Main"):
        db_name=None
        st.experimental_set_query_params(page="main")
