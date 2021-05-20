#!/bin/bash
#############################################################################
printf "testing fork... "
echo "pid
fork
pid
pid -p
exit" | bin/myshell --echo >test/output.txt 2>test/error.txt &
child_pid=$!
if [ $? -ne 0 ]
then
  echo "error (1)" >&2
  exit 1
fi
wait $child_pid
shell_pid=$(cat test/output.txt | head -n 2 | tail -n 1 | sed 's/@>//g' | sed 's/ //g')
if  [ -z $child_pid ] || [ -z $shell_pid ] || [ $child_pid -ne $shell_pid ]
then
  echo "error (2)" >&2
  exit 1
fi
fork_pid=$(cat test/output.txt | head -n 5 | tail -n 1 | sed 's/@>//g' | sed 's/ //g')
if  [ -z $fork_pid ] || [ -z $shell_pid ] || [ $fork_pid -eq $shell_pid ]
then
  echo "error (3) the parent and the child share the same pid $shell_pid" >&2
  exit 1
fi
fork_ppid=$(cat test/output.txt | head -n 7 | tail -n 1 | sed 's/@>//g' | sed 's/ //g')
if [ -z $fork_ppid ] || [ -z $child_pid ] || [ $fork_ppid -ne $child_pid ]
then
  echo "error (4) the parent pid is not the shell" >&2
  exit 1
fi
shell_pid=$(cat test/output.txt | head -n 10 | tail -n 1 | sed 's/@>//g' | sed 's/ //g')
if [ -z $child_pid ] || [ -z $shell_pid ] || [ $child_pid -ne $shell_pid ]
then
  echo "error (2)" >&2
  exit 1
fi
shell_pid=$(cat test/output.txt | head -n 12 | tail -n 1 | sed 's/@>//g' | sed 's/ //g')
echo $shell_pid
if [ -z $shell_pid ] || [ $shell_pid -ne $BASHPID ]
then
  echo "error (4)" >&2
  exit 1
else
    echo "ok"
fi