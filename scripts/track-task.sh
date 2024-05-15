#!/bin/bash
#set -x
if [ -f .pid ]; then
  read pid < .pid
  y=$(ps -p $pid -o comm=)
  echo PID $pid is $y
  x=1
  while [ $x -le 15 ]
  do
  ps --pid "$pid" >/dev/null
  if [ "$?" -eq 0 ]; then
    echo "PID $y exists and is running."
  else
    echo "PID $y does NOT exist."
	break
  fi
  sleep 1
  x=$(( $x + 1 ))
  ps -p $pid > /dev/null
  done
fi
