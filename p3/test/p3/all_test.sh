#!/bin/bash
script_dir="$(dirname $(realpath $0))"
grade=0
time="5s"
#########################################################################
printf "testing pipe... "
$script_dir/pipe_test.sh >/dev/null 2>&1
if [ $? -eq 0 ]
then
  grade=$((grade + 20))
  echo "ok"
else
  echo "error"
fi
#########################################################################
printf "testing message queue... "
timeout -k ${time} ${time} $script_dir/msg_queue_test.sh >/dev/null 2>&1
if [ $? -eq 0 ]
then
  grade=$((grade + 20))
  echo "ok"
else
  echo "error"
fi
#########################################################################
printf "testing init... "
timeout -k ${time} ${time} $script_dir/init_test.sh >/dev/null 2>&1
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error"
fi
#########################################################################
printf "testing init_destroy... "
timeout -k ${time} ${time} $script_dir/init_destroy_test.sh >/dev/null 2>&1
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error"
fi
#########################################################################
printf "testing incr... "
timeout -k ${time} ${time} $script_dir/incr_test.sh >/dev/null 2>&1
if [ $? -eq 0 ]
then
  grade=$((grade + 20))
  echo "ok"
else
  echo "error"
fi
#########################################################################
printf "testing producer-consumer stage 1... "
timeout -k ${time} ${time} $script_dir/pc_test_stage_01.sh >/dev/null 2>&1
if [ $? -eq 0 ]
then
  grade=$((grade + 10))
  echo "ok"
else
  echo "error"
fi
#########################################################################
printf "testing producer-consumer stage 2... "
timeout -k ${time} ${time}  $script_dir/pc_test_stage_02.sh >/dev/null 2>&1
if [ $? -eq 0 ]
then
  grade=$((grade + 20))
  echo "ok"
else
  echo "error"
fi
#########################################################################
printf "testing producer-consumer stage 3... "
timeout -k ${time} ${time}  $script_dir/pc_test_stage_03.sh >/dev/null 2>&1
if [ $? -eq 0 ]
then
  grade=$((grade + 10))
  echo "ok"
else
  echo "error"
fi
#########################################################################
printf "testing producer-consumer stage 4... "
timeout -k ${time} ${time}  $script_dir/pc_test_stage_04.sh >/dev/null 2>&1
if [ $? -eq 0 ]
then
  grade=$((grade + 20))
  echo "ok"
else
  echo "error"
fi
#########################################################################
cd test
rm -f output.txt error.txt expected_output.txt expected_error.txt expected_output_redirect.txt  input.txt  output_redirect.txt bash_output.txt  expected_bash_output.txt  input1.txt  input2.txt
rm -f error2.txt error_02.txt error_03.txt expected_output2.txt expected_output_01.txt expected_output_01b.txt expected_output_02.txt expected_output_02b.txt expected_output_03.txt expected_output_03b.txt output_01.txt output_01b.txt output_02.txt output_02b.txt output_03.txt output_03b.txt
killall myshell >/dev/null 2>&1
cd ..
echo "max grade (project3): ${grade}"