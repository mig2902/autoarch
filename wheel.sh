#!/bin/bash
# your real command here, instead of sleep
#sleep 7 &

sudo pacman -Rsn vim
PID=$!
i=1
sp="/-\|"
echo -n ' '
while [ -d /proc/$PID ]
do
  printf "\b${sp:i++%${#sp}:1}"
done
