#!/bin/bash

grad_date=$(date -d "2019-12-17" "+%s")
datum2=$(date "+%s")

diff=$(($grad_date-$datum2))

days=$(($diff/(60*60*24)))

echo  $diff | sed ':a;s/\B[0-9]\{3\}\>/,&/;ta'
