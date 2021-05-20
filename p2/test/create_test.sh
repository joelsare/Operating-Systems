#!/bin/bash
cdir=$(pwd)
tmp_dir=$(mktemp -d -t create_test_XXXXXXXXXX)
cd $tmp_dir
#############################################################################
printf "testing create files... "
printf "create test_file_01.txt
create test_file_02.txt
create test_file_03.txt" | $cdir/bin/myshell --echo >$cdir/test/output.txt 2>$cdir/test/error.txt
if [ $? -ne 0 ]
then
  echo "error (1)" >&2
  rm -rf $tmp_dir
  exit 1
fi
ls >$cdir/test/output_ls.txt
echo "test_file_01.txt
test_file_02.txt
test_file_03.txt" > $cdir/test/expected_ls.txt
diff -iwB $cdir/test/output_ls.txt $cdir/test/expected_ls.txt &>/dev/null
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error (2)" >&2
  rm -rf $tmp_dir
  exit 1
fi
rm test_file_01.txt test_file_02.txt test_file_03.txt
#############################################################################
printf "testing create directories... "
printf "create -d test_dir_01
create -d test_dir_02
create -d test_dir_03" | $cdir/bin/myshell --echo >$cdir/test/output.txt 2>$cdir/test/error.txt
if [ $? -ne 0 ]
then
  echo "error (3)" >&2
  rm -rf $tmp_dir
  exit 1
fi
ls >$cdir/test/output_ls.txt
echo "test_dir_01
test_dir_02
test_dir_03" > $cdir/test/expected_ls.txt
diff -iwB $cdir/test/output_ls.txt $cdir/test/expected_ls.txt &>/dev/null
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error (4)" >&2
  rm -rf $tmp_dir
  exit 1
fi
#############################################################################
printf "testing create files in directories... "
printf "create test_dir_01/test_file_01.txt
create test_dir_01/test_file_02.txt
create test_dir_01/test_file_03.txt" | $cdir/bin/myshell --echo >$cdir/test/output.txt 2>$cdir/test/error.txt
if [ $? -ne 0 ]
then
  echo "error (5)" >&2
  rm -rf $tmp_dir
  exit 1
fi
ls test_dir_01 >$cdir/test/output_ls.txt
echo "test_file_01.txt
test_file_02.txt
test_file_03.txt" > $cdir/test/expected_ls.txt
diff -iwB $cdir/test/output_ls.txt $cdir/test/expected_ls.txt &>/dev/null
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error (6)" >&2
  rm -rf $tmp_dir
  exit 1
fi
#############################################################################
printf "testing create existing files... "
printf "create test_dir_01" | $cdir/bin/myshell --echo >$cdir/test/output.txt 2>$cdir/test/error.txt
if [ $? -ne 0 ]
then
  echo "error (7)" >&2
  rm -rf $tmp_dir
  exit 1
fi
printf "create: File exists" > $cdir/test/expected_error.txt
diff -iwB $cdir/test/error.txt $cdir/test/expected_error.txt &>/dev/null
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error (8)" >&2
  exit 1
fi
#############################################################################
printf "testing create existing directory... "
printf "create -d test_dir_01" | $cdir/bin/myshell --echo >$cdir/test/output.txt 2>$cdir/test/error.txt
if [ $? -ne 0 ]
then
  echo "error (9)" >&2
  rm -rf $tmp_dir
  exit 1
fi
printf "create: File exists" > $cdir/test/expected_error.txt
diff -iwB $cdir/test/error.txt $cdir/test/expected_error.txt &>/dev/null
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error (10)" >&2
  exit 1
fi
#############################################################################
printf "testing create noname... "
echo "create" | $cdir/bin/myshell --echo >$cdir/test/output.txt 2>$cdir/test/error.txt
if [ $? -ne 0 ]
then
  echo "error" >&2
  rm -rf $tmp_dir
  exit 1
fi
printf "usage: create [-d] name" > $cdir/test/expected_error.txt
diff -iwB $cdir/test/error.txt $cdir/test/expected_error.txt &>/dev/null
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error (11)" >&2
  exit 1
fi
#############################################################################
printf "testing create -d noname... "
echo "create -d" | $cdir/bin/myshell --echo >$cdir/test/output.txt 2>$cdir/test/error.txt
if [ $? -ne 0 ]
then
  echo "error (12)" >&2
  rm -rf $tmp_dir
  exit 1
fi
printf "usage: create [-d] name" > $cdir/test/expected_error.txt
diff -iwB $cdir/test/error.txt $cdir/test/expected_error.txt &>/dev/null
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error (13)" >&2
  exit 1
fi
#############################################################################
# printf "testing create -a file... "
# printf "create -a file" | $cdir/bin/myshell --echo >$cdir/test/output.txt 2>$cdir/test/error.txt
# if [ $? -ne 0 ]
# then
#   echo "error" >&2
#   rm -rf $tmp_dir
#   exit 1
# fi
# printf "usage: create [-d] name" > $cdir/test/expected_error.txt
# diff -iwB $cdir/test/error.txt $cdir/test/expected_error.txt &>/dev/null
# if [ $? -eq 0 ]
# then
#   echo "ok"
# else
#   echo "error" >&2
#   exit 1
# fi
#############################################################################
rm -rf $tmp_dir