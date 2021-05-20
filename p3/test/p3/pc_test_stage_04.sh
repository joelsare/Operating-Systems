#!/bin/bash
script_dir="$(dirname $(realpath $0))"
grade=100
#########################################################################
printf "testing pc_test_05... "
$script_dir/producer_consumer/test_05.sh >/dev/null 2>&1
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