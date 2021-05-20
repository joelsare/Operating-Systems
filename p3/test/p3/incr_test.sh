#!/bin/bash
script_dir="$(dirname $(realpath $0))"
grade=100
#########################################################################
printf "testing incr_test_01... "
$script_dir/incr_test/incr_test_01.sh >/dev/null 2>&1
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error"
  grade=0
fi
#########################################################################
printf "testing incr_test_02... "
$script_dir/incr_test/incr_test_02.sh >/dev/null 2>&1
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error"
  grade=0
fi
#########################################################################
printf "testing incr_test_03... "
$script_dir/incr_test/incr_test_03.sh >/dev/null 2>&1
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error"
  grade=0
fi
#########################################################################
if [ $grade -eq 0 ]
then
    exit 1
fi
#########################################################################