#!/bin/bash

# Example string
col_names=$1
col_datatypes=$2

# Convert string to array
IFS=';' read -r -a col_array <<< "$col_names"
IFS=';' read -r -a dtype_array <<< "$col_datatypes"

# Print the array elements
i=0
for element in "${col_array[@]}"; do
  nm="${col_array[$i]}" 
  dt="${dtype_array[$i]}"
  echo $nm 
  echo $dt
  ((i++)); 
done;
