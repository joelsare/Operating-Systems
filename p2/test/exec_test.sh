#!/bin/bash
#############################################################################
printf "testing exec... "
echo "exec ls -lisa" | bin/myshell >test/output.txt 2>test/error.txt
if [ $? -ne 0 ]
then
  echo "error (1)" >&2
  exit 1
fi
ls -lisa > test/expected_output.txt
cat test/output.txt | sed 's/@>//g' > test/output2.txt
diff -iwB test/output2.txt test/expected_output.txt &>/dev/null
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error (2)" >&2
  exit 1
fi
############################################################################
printf "testing exec... "
echo "pid
exec ps -a" | bin/myshell >test/output.txt 2>test/error.txt &
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
fi
ps_pid=$(cat test/output.txt | grep "ps" | sed 's/@>//g' | tr -s ' ' | cut -d ' ' -f 1)
if [ -z $child_pid ] || [ -z $shell_pid ] || [ $child_pid -ne $ps_pid ]
then
  echo "error (3)" >&2
  exit 1
else
  echo "ok"
fi
############################################################################
rm -f test/output2.txt
