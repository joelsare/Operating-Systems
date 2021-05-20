#!/bin/bash
script_dir="$(dirname $(realpath $0))"
grade=100
#########################################################################
printf "testing msg_queue_test_01... "
$script_dir/msg_queue/test_01.sh >/dev/null 2>&1
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error"
  exit 1
  grade=0
fi
#########################################################################
printf "testing msg_queue_test_02... "
$script_dir/msg_queue/test_02.sh >/dev/null 2>&1
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error"
  exit 1
  grade=0
fi
#########################################################################
printf "testing msg_queue_test_03... "
$script_dir/msg_queue/test_03.sh >/dev/null 2>&1
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error"
  exit 1
  grade=0
fi
#########################################################################
printf "testing msg_queue_test_04... "
$script_dir/msg_queue/test_04.sh >/dev/null 2>&1
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error"
  exit 1
  grade=0
fi
#########################################################################
printf "testing msg_queue_test_04... "
$script_dir/msg_queue/test_05.sh >/dev/null 2>&1
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error"
  exit 1
  grade=0
fi
#########################################################################
if [ $grade -eq 0 ]
then
    exit 1
fi
#########################################################################