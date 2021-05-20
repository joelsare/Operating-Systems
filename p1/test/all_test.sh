#!/bin/bash
script_dir="$(dirname $(realpath $0))"
printf "testing exit... "
$script_dir/exit_test.sh >/dev/null 2>&1
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error"
fi
printf "testing cdir... "
$script_dir/cdir_test.sh >/dev/null 2>&1
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error"
fi
printf "testing create... "
$script_dir/create_test.sh >/dev/null 2>&1
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error"
fi
printf "testing delete... "
$script_dir/delete_test.sh >/dev/null 2>&1
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error"
fi
printf "testing list... "
$script_dir/list_test.sh >/dev/null 2>&1
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error"
fi
printf "testing hist... "
$script_dir/hist_test.sh >/dev/null 2>&1
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error"
fi
cd test
rm -f output.txt error.txt expected_output.txt expected_error.txt output_ls.txt expected_ls.txt