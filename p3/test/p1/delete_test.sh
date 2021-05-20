#!/bin/bash
cdir=$(pwd)
tmp_dir=$(mktemp -d -t create_test_XXXXXXXXXX)
cd $tmp_dir
echo "moving current directory to " $(pwd)
#############################################################################
printf "testing delete files... "
echo "Hellow world" > test_file_01.txt
echo "Hellow world" > test_file_02.txt
echo "Hellow world" > test_file_03.txt
printf "delete test_file_01.txt
delete test_file_02.txt
delete test_file_03.txt" | $cdir/bin/myshell --echo >$cdir/test/output.txt 2>$cdir/test/error.txt
if [ $? -ne 0 ]
then
  echo "error (1)" >&2
  rm -rf $tmp_dir
  exit 1
fi
ls >$cdir/test/output_ls.txt
printf "" > $cdir/test/expected_ls.txt
diff -iwB $cdir/test/output_ls.txt $cdir/test/expected_ls.txt &>/dev/null
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error (2)" >&2
  rm -rf $tmp_dir
  exit 1
fi
rm -f test_file_01.txt test_file_02.txt test_file_03.txt
#############################################################################
printf "testing delete directories... "
mkdir test_dir_01
mkdir test_dir_02
mkdir test_dir_03
printf "delete test_dir_01
delete test_dir_02
delete test_dir_03" | $cdir/bin/myshell --echo >$cdir/test/output.txt 2>$cdir/test/error.txt
if [ $? -ne 0 ]
then
  echo "error (1)" >&2
  rm -rf $tmp_dir
  exit 1
fi
ls >$cdir/test/output_ls.txt
printf "" > $cdir/test/expected_ls.txt
diff -iwB $cdir/test/output_ls.txt $cdir/test/expected_ls.txt &>/dev/null
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error (2)" >&2
  rm -rf $tmp_dir
  exit 1
fi
rm -rdf test_dir_01 test_dir_02 test_dir_03
#############################################################################
printf "testing delete non-empty directories... "
mkdir test_dir_01
echo "Hellow world" > test_dir_01/test_file_01.txt
echo "Hellow world" > test_dir_01/test_file_02.txt
echo "Hellow world" > test_dir_01/test_file_03.txt
mkdir test_dir_01/test_dir_02
echo "Hellow world" > test_dir_01/test_dir_02/test_file_01.txt
echo "Hellow world" > test_dir_01/test_dir_02/test_file_02.txt
echo "Hellow world" > test_dir_01/test_dir_02/test_file_03.txt
printf "delete test_dir_01" | $cdir/bin/myshell --echo >$cdir/test/output.txt 2>$cdir/test/error.txt
if [ $? -ne 0 ]
then
  echo "error (1)" >&2
  rm -rf $tmp_dir
  exit 1
fi
printf "delete: Directory not empty" > $cdir/test/expected_error.txt
diff -iw $cdir/test/error.txt $cdir/test/expected_error.txt &>/dev/null
if [ $? -ne 0 ]
then
  echo "error (2)" >&2
  rm -rf $tmp_dir
  exit 1
fi
ls >$cdir/test/output_ls.txt
printf "test_dir_01" > $cdir/test/expected_ls.txt
diff -iwB $cdir/test/output_ls.txt $cdir/test/expected_ls.txt &>/dev/null
if [ $? -ne 0 ]
then
  echo "error (3)" >&2
  rm -rf $tmp_dir
  exit 1
fi
ls test_dir_01 >$cdir/test/output_ls.txt
echo "test_dir_02
test_file_01.txt
test_file_02.txt
test_file_03.txt" > $cdir/test/expected_ls.txt
diff -iwB $cdir/test/output_ls.txt $cdir/test/expected_ls.txt &>/dev/null
if [ $? -ne 0 ]
then
  echo "error (4)" >&2
  rm -rf $tmp_dir
  exit 1
else
  echo "ok"
fi
rm -rf test_dir_01
#############################################################################
printf "testing delete -r non-empty directories... "
mkdir test_dir_01
echo "Hellow world" > test_dir_01/test_file_01.txt
echo "Hellow world" > test_dir_01/test_file_02.txt
echo "Hellow world" > test_dir_01/test_file_03.txt
mkdir test_dir_01/test_dir_02
echo "Hellow world" > test_dir_01/test_dir_02/test_file_01.txt
echo "Hellow world" > test_dir_01/test_dir_02/test_file_02.txt
echo "Hellow world" > test_dir_01/test_dir_02/test_file_03.txt
printf "delete -r test_dir_01" | $cdir/bin/myshell --echo >$cdir/test/output.txt 2>$cdir/test/error.txt
if [ $? -ne 0 ]
then
  echo "error (1)" >&2
  rm -rf $tmp_dir
  exit 1
fi
ls >$cdir/test/output_ls.txt
printf "" > $cdir/test/expected_ls.txt
diff -iwB $cdir/test/output_ls.txt $cdir/test/expected_ls.txt &>/dev/null
if [ $? -ne 0 ]
then
  echo "error (3)" >&2
  rm -rf $tmp_dir
  exit 1
else
  echo "ok"
fi
rm -rf $tmp_dir