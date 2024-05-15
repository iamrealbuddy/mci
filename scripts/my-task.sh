#!/bin/bash
#set -x
x=1
printf "task running"
while [ $x -le 10 ]
do
  printf .
  sleep 1
  x=$(( $x + 1 ))
done
