#!/bin/bash
#set -x
x=1
echo "pwd is..."
pwd
#echo start > .done
echo BDN=$BUILD_DISPLAY_NAME
sleep 5
printf "task running"
#for (( i=1; i <= 10; ++i ))
while [ $x -le 10 ]
do
  printf .
  sleep 1
  x=$(( $x + 1 ))
done
echo done > .done
