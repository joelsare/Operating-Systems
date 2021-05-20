#!/bin/bash
#############################################################################
printf "testing pid... "
echo "pid" | bin/myshell >test/output.txt 2>test/error.txt &
child_pid=$!
if [ $? -ne 0 ]
then
  echo "error (1)" >&2
  exit 1
fi
wait $child_pid
shell_pid=$(cat test/output.txt | head -n 1 | sed 's/@>//g' | sed 's/ //g')
if [ -z $child_pid ] || [ -z $shell_pid ] || [ $child_pid -ne $shell_pid ]
then
  echo "error (2)" >&2
  exit 1
else
  echo "ok"
fi
#############################################################################
printf "testing pid -p... "
echo "pid -p" | bin/myshell >test/output.txt 2>test/error.txt
if [ $? -ne 0 ]
then
  echo "error (3)" >&2
  exit 1
fi
shell_pid=$(cat test/output.txt | head -n 1 | sed 's/@>//g' | sed 's/ //g')
if [ -z $child_pid ] || [ -z $shell_pid ] || [ $shell_pid -ne $BASHPID ]
then
  echo "error (4)" >&2
  exit 1
else
  echo "ok"
fi
#############################################################################