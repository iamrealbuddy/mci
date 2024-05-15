#!/bin/bash
#set -x
if [ -f .pid ]; then
  read pid < .pid
  echo $pid
  
  while true
  do
  ps --pid "$pid" >/dev/null
  if [ "$?" -eq 0 ]; then
    echo "PID $pid exists and is running."
  else
    echo "PID $pid does NOT exist."
	break
  fi
  sleep 1
  ps -p $pid > /dev/null
  done
fi
