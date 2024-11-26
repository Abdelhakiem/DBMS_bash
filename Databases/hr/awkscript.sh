#!/bin/bash

#!/bin/bash

newtable=$(awk 'BEGIN {
    FS=":";
    OFS = ":"; 
} 
{
    if ($3==12000)
     {$3=0}   
        print ($0)
} 
END {}' trial)
echo "$newtable" > trial
