#!/bin/bash

PID=$1
echo "Proceso: $PID"
i=0
#sp="/-\|"
sp="┤┘┴└├┌┬┐"

echo -n ' '
while [ -d /proc/$PID ]
do
  printf "\b${sp:i++%${#sp}:1}"
  sleep 0.2
done
echo ""