#!/bin/bash
###########################################################################
printf "testing bash test/input.txt... "
rm -f ./test/myshell_wait_fifo
mkfifo ./test/myshell_wait_fifo
echo "echo 'Hello World!' > test/bash_output.txt
echo 'ok' > ./test/myshell_wait_fifo" > test/input.txt
echo "bg bash test/input.txt" | bin/myshell >test/output.txt 2>test/error.txt 
if [ $? -ne 0 ]
then
  echo "error (5)" >&2
  rm -f ./test/myshell_wait_fifo
  exit 1
fi
echo 'Hello World!' > test/expected_bash_output.txt
wait_ok=`cat ./test/myshell_wait_fifo`
rm -f ./test/myshell_wait_fifo
wait $bash_pid
diff -iwB test/bash_output.txt test/expected_bash_output.txt &>/dev/null
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error (6)" >&2
  exit 1
fi
###########################################################################
printf "testing bg fifo... "
rm -f ./test/myshell_wait_fifo
rm -f ./test/myshell_testing_fifo
mkfifo ./test/myshell_wait_fifo
mkfifo ./test/myshell_testing_fifo
echo "echo 'Hello world!' > test/bash_output.txt
cat <./test/myshell_testing_fifo >> test/bash_output.txt
echo 'ok' > ./test/myshell_wait_fifo" > test/input1.txt
echo "echo 'Bye bye.' >./test/myshell_testing_fifo" > test/input2.txt
echo "bg bash test/input1.txt
fg bash test/input2.txt" | bin/myshell >test/output.txt 2>test/error.txt
if [ $? -ne 0 ]
then
  echo "error (7)" >&2
  rm -f ./test/myshell_wait_fifo
  rm -f ./test/myshell_testing_fifo
  exit 1
fi
echo 'Hello World!
Bye bye.' > test/expected_bash_output.txt
wait_ok=`cat ./test/myshell_wait_fifo`
rm -f ./test/myshell_wait_fifo
rm -f ./test/myshell_testing_fifo
diff -iwB test/bash_output.txt test/expected_bash_output.txt &>/dev/null
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error (8)" >&2
  rm -f ./test/myshell_wait_fifo
  rm -f ./test/myshell_testing_fifo
  exit 1
fi
###########################################################################
rm -f test/output2.txt
rm -f test/expected_bash_output.txt
rm -f ./test/myshell_wait_fifo
rm -f ./test/myshell_testing_fifo