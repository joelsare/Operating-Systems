#!/bin/bash
script_dir="$(dirname $(realpath $0))"
grade=0
printf "testing myecho... "
$script_dir/myecho_test.sh >/dev/null 2>&1
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error"
fi
printf "testing redirect... "
$script_dir/redirect_test.sh >/dev/null 2>&1
if [ $? -eq 0 ]
then
  echo "ok"
  grade=$((grade + 1))
else
  echo "error"
fi
printf "testing pid... "
$script_dir/pid_test.sh >/dev/null 2>&1
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error"
fi
printf "testing fork... "
$script_dir/fork_test.sh >/dev/null 2>&1
if [ $? -eq 0 ]
then
  echo "ok"
  grade=$((grade + 1))
else
  echo "error"
fi
printf "testing exec... "
$script_dir/exec_test.sh >/dev/null 2>&1
if [ $? -eq 0 ]
then
  echo "ok"
  grade=$((grade + 1))
else
  echo "error"
fi
printf "testing fg... "
$script_dir/fg_test.sh >/dev/null 2>&1
if [ $? -eq 0 ]
then
  echo "ok"
  grade=$((grade + 1))
else
  echo "error"
fi
printf "testing bg... "
$script_dir/bg_test.sh >/dev/null 2>&1
if [ $? -eq 0 ]
then
  echo "ok"
  grade=$((grade + 1))
else
  echo "error"
fi
#############################################################################
cd test
rm -f output.txt error.txt expected_output.txt expected_error.txt expected_output_redirect.txt  input.txt  output_redirect.txt bash_output.txt  expected_bash_output.txt  input1.txt  input2.txt
cd ..
grade=$((grade * 20))
echo "max grade: ${grade}"
#############################################################################