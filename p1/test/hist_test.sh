#!/bin/bash
cdir=$(pwd)
tmp_dir=$(mktemp -d -t create_test_XXXXXXXXXX)
cd $tmp_dir
echo "moving current directory to " $(pwd)
#############################################################################
printf "testing list files... "
echo "create -d test_dir_01
cdir test_dir_01
create test_file_01.txt
create test_file_02.txt
delete test_file_01.txt
cdir ..
hist
create test_file_03.txt
hist -c
delete -d test_dir_01
hist" | $cdir/bin/myshell --echo >$cdir/test/output.txt 2>$cdir/test/error.txt
if [ $? -ne 0 ]
then
  echo "error (1)" >&2
  rm -rf $tmp_dir
  exit 1
fi
printf "@> create -d test_dir_01
@> cdir test_dir_01
@> create test_file_01.txt
@> create test_file_02.txt
@> delete test_file_01.txt
@> cdir ..
@> hist
create -d test_dir_01
cdir test_dir_01
create test_file_01.txt
create test_file_02.txt
delete test_file_01.txt
cdir ..
hist
@> create test_file_03.txt
@> hist -c
@> delete -d test_dir_01
@> hist
delete -d test_dir_01
hist
@> " >$cdir/test/expected_output.txt
cat $cdir/test/output.txt | sed 's/@>//' > $cdir/test/output2.txt
cat $cdir/test/expected_output.txt | sed 's/@>//' > $cdir/test/expected_output2.txt
diff -iwB $cdir/test/output2.txt $cdir/test/expected_output2.txt &>/dev/null
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error (2)" >&2
  rm -rf $tmp_dir
  exit 1
fi
#############################################################################
rm -rf $tmp_dir
rm -f $cdir/test/output2.txt $cdir/test/expected_output2.txt