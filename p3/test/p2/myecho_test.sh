#!/bin/bash
rm -f test/output.txt
rm -f test/output.txt
rm -f test/output2.txt
#############################################################################
printf "testing echo... "
echo "myecho Hellow world!
myecho Good bye.
exit" | bin/myshell --echo >test/output.txt
if [ $? -ne 0 ]
then
  echo "error (1)" >&2
  exit 1
fi
echo "@> myecho Hellow world!
Hellow world!
@> myecho Good bye.
Good bye." >test/expected_output.txt
cat test/output.txt | sed '/^$/d' | head -n 4  > test/output2.txt
diff -iwB test/output2.txt test/expected_output.txt &>/dev/null
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error (2)" >&2
  exit 1
fi
rm -f test/output2.txt
