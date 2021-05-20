#!/bin/bash
cdir=$(pwd)
tmp_dir=$(mktemp -d -t create_test_XXXXXXXXXX)
cd $tmp_dir
echo "moving current directory to " $(pwd)
#############################################################################
printf "testing list files... "
echo "Hellow world" > test_file_01.txt
echo "Hellow world" > test_file_02.txt
echo "Hellow world" > test_file_03.txt
echo "list" | $cdir/bin/myshell --echo >$cdir/test/output.txt 2>$cdir/test/error.txt
if [ $? -ne 0 ]
then
  echo "error (1)" >&2
  rm -rf $tmp_dir
  exit 1
fi
echo "@> list" >$cdir/test/expected_output.txt
ls -a >>$cdir/test/expected_output.txt
printf "@> " >>$cdir/test/expected_output.txt
cat $cdir/test/expected_output.txt | tail -n +2 | tr -s ' '  '\n' | sort  > $cdir/test/expected_output2.txt
cat $cdir/test/output.txt | tail -n +2 | tr -s ' '  '\n' | sort | sed 's/@>//' > $cdir/test/output2.txt
cat $cdir/test/expected_output2.txt | sed 's/@>//' > $cdir/test/expected_output3.txt
diff -iwB $cdir/test/output2.txt $cdir/test/expected_output3.txt &>/dev/null
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
printf "testing list directories... "
mkdir test_dir_01
mkdir test_dir_02
mkdir test_dir_03
echo "list" | $cdir/bin/myshell --echo >$cdir/test/output.txt 2>$cdir/test/error.txt
if [ $? -ne 0 ]
then
  echo "error (1)" >&2
  rm -rf $tmp_dir
  exit 1
fi
echo "@> list" >$cdir/test/expected_output.txt
ls -a >>$cdir/test/expected_output.txt
printf "@> " >>$cdir/test/expected_output.txt
cat $cdir/test/expected_output.txt | tail -n +2 | tr -s ' '  '\n' | sort  > $cdir/test/expected_output2.txt
cat $cdir/test/output.txt | tail -n +2 | tr -s ' '  '\n' | sort | sed 's/@>//' > $cdir/test/output2.txt
cat $cdir/test/expected_output2.txt | sed 's/@>//' > $cdir/test/expected_output3.txt
diff -iwB $cdir/test/output2.txt $cdir/test/expected_output3.txt &>/dev/null
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error (2)" >&2
  rm -rf $tmp_dir
  exit 1
fi
rm -rdf test_dir_01 test_dir_02 test_dir_03
rm -f $cdir/test/output2.txt $cdir/test/expected_output2.txt
rm -rf $tmp_dir