#!/bin/bash
#set -x
x=1
echo "pwd is..."
pwd
#echo start > .done
printf "task running"
for (( i=1; i <= 10; ++i ))
do
  printf .
  sleep 1
#  x=$(( $x + 1 ))
done
echo done > .done
