#!/bin/bash
#############################################################################
printf "testing pipe ls -lisa | grep -e bin... "
echo "pipe ls -lisa | grep -e bin" | bin/myshell >test/output.txt 2>test/error.txt
if [ $? -ne 0 ]
then
  echo "error (1)" >&2
  exit 1
fi
ls -lisa | grep -e bin > test/expected_output.txt
cat test/output.txt | sed 's/@>//g' > test/output2.txt
diff -iwB test/output2.txt test/expected_output.txt &>/dev/null
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error (2)" >&2
  exit 1
fi
#############################################################################
printf "testing pipe ls -l -i -s -a | grep -e bin... "
echo "pipe ls -l -i -s -a | grep -e bin" | bin/myshell >test/output.txt 2>test/error.txt
if [ $? -ne 0 ]
then
  echo "error (3)" >&2
  exit 1
fi
ls -lisa | grep -e bin > test/expected_output.txt
cat test/output.txt | sed 's/@>//g' > test/output2.txt
diff -iwB test/output2.txt test/expected_output.txt &>/dev/null
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error (4)" >&2
  exit 1
fi
###########################################################################
rm -f test/output2.txt
