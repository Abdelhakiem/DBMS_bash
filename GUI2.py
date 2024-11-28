import streamlit as st
import pandas as pd

# Title of the webpage
st.title("Dynamic Table with 3 Columns")

# Sidebar for user to specify the number of rows
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
if form.form_submit_button("Submit"):
    # Convert the collected data into a DataFrame
    df = pd.DataFrame(data)
    st.write(";".join(df['Name'].to_list()))
    st.write(";".join(df['Datatype'].to_list()))
    st.table(df)
    
