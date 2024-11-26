#!/bin/bash

#!/bin/bash

newtable=$(awk 'BEGIN {
    FS=":"
} 
{
    if ($3!=12000)
        print ($0)
} 
END {}' trial)
echo "$newtable" > trial
