#!/bin/bash
#############################################################################
printf "testing fg ls -lisa... "
echo "fg ls -lisa" | bin/myshell >test/output.txt 2>test/error.txt
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
#############################################################################
printf "testing fg ls -l -i -s -a... "
echo "fg ls -l -i -s -a" | bin/myshell >test/output.txt 2>test/error.txt
if [ $? -ne 0 ]
then
  echo "error (3)" >&2
  exit 1
fi
ls -lisa > test/expected_output.txt
cat test/output.txt | sed 's/@>//g' > test/output2.txt
diff -iwB test/output2.txt test/expected_output.txt &>/dev/null
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error (4)" >&2
  exit 1
fi
###########################################################################
printf "testing fg ps -af... "
echo "pid
fg ps -af" | bin/myshell >test/output.txt 2>test/error.txt &
child_pid=$!
if [ $? -ne 0 ]
then
  echo "error (5)" >&2
  exit 1
fi
wait $child_pid
shell_pid=$(cat test/output.txt | sed '/^$/d' | head -n 1 | sed 's/@>//g' | sed 's/ //g')
if [ -z $child_pid ] || [ -z $shell_pid ] || [ $child_pid -ne $shell_pid ]
then
  echo "error (6)" >&2
  exit 1
fi
ps_pid=$(cat test/output.txt | sed '/^$/d' | grep "ps" | sed 's/@>//g' | tr -s ' ' | cut -d ' ' -f 2)
if [ -z $child_pid ] || [ -z $ps_pid ] || [ $child_pid -eq $ps_pid ]
then
  echo "error (7)" >&2
  exit 1
fi
ps_ppid=$(cat test/output.txt | sed '/^$/d' | grep "ps" | sed 's/@>//g' | tr -s ' ' | cut -d ' ' -f 3)
if [ -z $child_pid ] || [ -z $ps_ppid ] || [ $child_pid -ne $ps_ppid ]
then
  echo "error (8)" >&2
  exit 1
else
  echo "ok"
fi
###########################################################################
printf "testing bash test/input.txt... "
echo "echo 'Hello World!' > test/bash_output.txt" > test/input.txt
echo "fg bash test/input.txt" | bin/myshell >test/output.txt 2>test/error.txt 
if [ $? -ne 0 ]
then
  echo "error (9)" >&2
  exit 1
fi
echo 'Hello World!' > test/expected_bash_output.txt
diff -iwB test/bash_output.txt test/expected_bash_output.txt &>/dev/null
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error (10)" >&2
  exit 1
fi
###########################################################################
rm -f test/output2.txt
