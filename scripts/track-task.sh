#!/bin/bash
#set -x
if [ -f .pid ]; then
  read pid < .pid
  echo $pid
  x=1
  while [ $x -le 15 ]
  do
  ps --pid "$pid" >/dev/null
  if [ "$?" -eq 0 ]; then
    echo "PID $pid exists and is running."
  else
    echo "PID $pid does NOT exist."
	break
  fi
  sleep 1
  x=$(( $x + 1 ))
  ps -p $pid > /dev/null
  done
fi
