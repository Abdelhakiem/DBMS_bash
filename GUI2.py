import subprocess
import streamlit as st
import pandas as pd
import warnings  # Importing the warnings library
st.set_option('deprecation.showfileUploaderEncoding', False)
git_bash_path = "C:\\Program Files\\Git\\bin\\bash.exe"
table_name="employees"
file_path=f"Databases/hr/.meta{table_name}"
results = subprocess.run(
    [git_bash_path, "-c", f"cut -d ':' -f 1 {file_path}"],  # -c is required for passing commands to Git Bash
    capture_output=True,
    text=True
)

# Print the standard output
print(pd.DataFrame(columns=results.stdout.splitlines()))
