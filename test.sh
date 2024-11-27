#! /bin/bash

input=240506

vv=$( awk -v id="$input" 'BEGIN {FS=":";}{if ($3 = $id) max="True"}END{print max;}' passwd.txt )

# Use the variable in the shell
echo "The maximum age is: $vv"
