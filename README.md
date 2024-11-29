# Bash Shell Script Database Management System (DBMS)  

## **Project Description**  
This project is a **Database Management System (DBMS)** implemented in Bash shell scripting. It allows users to create and manipulate databases directly on the file system. The system supports two versions:  

1. **CLI-Based Version:**  
   A command-line interface (CLI) that provides menu-based navigation for database operations.
   
2. **GUI-Based Version:**  
   A graphical user interface (GUI) version built using **Streamlit**, which offers a more user-friendly experience.

---

## **Features**  

### **1. CLI-Based DBMS**  

#### **Main Menu:**  
When the user runs the script, the following options are presented:  
1. **Create Database:**  
   Create a new database (stored as a directory).  
2. **List Databases:**  
   Display all existing databases.  
3. **Connect to Database:**  
   Connect to a specific database to manage tables and data.  
4. **Drop Database:**  
   Delete an existing database and all its contents.  

#### **Database Management Menu:**  
Once connected to a database, the user can perform the following operations:  
1. **Create Table:**  
   - Specify table name, columns, and their data types.  
   - Define a **primary key** to enforce uniqueness.  
2. **List Tables:**  
   Display all tables within the connected database.  
3. **Drop Table:**  
   Delete a table and its contents.  
4. **Insert into Table:**  
   - Add new rows to a table.  
   - Validate data types and ensure the uniqueness of primary keys.  
5. **Select From Table:**  
   - Retrieve and display data from a table.  
   - Support for selecting all columns or specific columns.  
   - Filter data using conditions (`=`, `!=`, `<`, `>`).  
6. **Delete From Table:**  
   - Remove rows based on a specific condition.  
7. **Update Table:**  
   - Modify existing records by updating column values.  
   - Support conditional updates and validation of primary keys and data types.

---

### **2. GUI-Based DBMS**  
The GUI version, built using **Streamlit**, offers:  
- An interactive interface for creating and managing databases and tables.  
- A form-based approach for inserting, selecting, updating, and deleting data.  
- Visual feedback for each operation, making it easier for users unfamiliar with the command line.  
---

## **Technical Details**  

- **Database Storage:**  
  Each database is represented as a directory on the file system, and each table is stored as a file within its respective database directory. Metadata files are used to store information about table structure and primary keys.  

- **File Structure:**  
  ```
  ├── DBMS/
  │   ├── Databases/
  │   │   ├── database1/
  │   │   │   ├── table1
  │   │   │   └── .meta_table1
  │   │   └── database2/
  │   │       ├── table2
  │   │       └── .meta_table2
  └── main.sh (Main Bash Script)
  ```

---

## **How to Run**  

### **CLI-Based Version**  
1. Open a terminal.  
2. Navigate to the directory containing the `main.sh` script.  
3. Run the script using:  
   ```bash  
   ./main.sh  
   ```  
4. Follow the menu prompts to interact with the DBMS.

---

### **GUI-Based Version**  
1. Ensure you have **Streamlit** installed. If not, install it using:  
   ```bash  
   pip install streamlit  
   ```  
2. Navigate to the directory containing the GUI script.  
3. Run the Streamlit app using:  
   ```bash  
   streamlit run GUI.py  
   ```  
4. Access the GUI through the web browser link provided by Streamlit.
