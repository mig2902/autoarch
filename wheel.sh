#!/bin/bash
function system_info {
       echo "### OS information ###"
       lsb_release -a

       echo
       echo "### Processor information ###"
       processor=`grep -wc "processor" /proc/cpuinfo`
       model=`grep -w "model name" /proc/cpuinfo  | awk -F: '{print $2}'`
       echo "Processor = $processor"
       echo "Model     = $model"

       echo
       echo "### Memory information ###"
       total=`grep -w "MemTotal" /proc/meminfo | awk '{print $2}'`
       free=`grep -w "MemFree" /proc/meminfo | awk '{print $2}'`
       echo "Total memory: $total kB"
       echo "Free memory : $free kB"
}



function progress_bar {
  sleep 20 & PID=$! #simulate a long process

  echo "THIS MAY TAKE A WHILE, PLEASE BE PATIENT WHILE ______ IS RUNNING..."
  printf "["
  # While process is running...
  while kill -0 $PID 2> /dev/null; do
      printf  "▓"
      sleep 1
  done
  printf "] done!"
}

progress_bar

system_info
