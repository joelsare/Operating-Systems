#!/bin/bash
#############################################################################
printf "testing redirect output... "
echo "myecho Hellow world!
redirect - test/output_redirect.txt
myecho Good bye." | bin/myshell --echo >test/output.txt
if [ $? -ne 0 ]
then
  echo "error (1)" >&2
  exit 1
fi
echo "@> myecho Hellow world!
Hellow world!
@> redirect - test/output_redirect.txt" >test/expected_output.txt

echo "@> myecho Good bye.
Good bye." >test/expected_output_redirect.txt

cat test/output_redirect.txt | head -n 2  > test/output_redirect2.txt
diff -iwB test/output.txt test/expected_output.txt &>/dev/null
if [ $? -ne 0 ]
then
  echo "error (2)" >&2
  exit 1
fi
diff -iwB test/output_redirect2.txt test/expected_output_redirect.txt &>/dev/null
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error (3)" >&2
  exit 1
fi
rm -f test/output_redirect2.txt
#############################################################################
printf "testing redirect input... "
echo "myecho Bye bye." > test/input.txt
echo "myecho Hellow world!
redirect test/input.txt
myecho Good bye.
myecho Good bye." | bin/myshell --echo >test/output.txt
if [ $? -ne 0 ]
then
  echo "error (1)" >&2
  exit 1
fi
echo "@> myecho Hellow world!
Hellow world!
@> redirect test/input.txt
@> myecho Bye bye.
Bye bye." >test/expected_output.txt

cat test/output.txt | head -n 5  > test/output2.txt
diff -iwB test/output2.txt test/expected_output.txt &>/dev/null
if [ $? -ne 0 ]
then
  echo "error (4)" >&2
  exit 1
else
  echo "ok"
fi
rm -f test/output2.txt
#############################################################################
printf "testing redirect input and output... "
echo "myecho Bye bye." > test/input.txt
echo "myecho Hellow world!
redirect test/input.txt test/output_redirect.txt
myecho Good bye." | bin/myshell --echo >test/output.txt
if [ $? -ne 0 ]
then
  echo "error (1)" >&2
  exit 1
fi
echo "@> myecho Hellow world!
Hellow world!
@> redirect test/input.txt test/output_redirect.txt" >test/expected_output.txt

echo "@> myecho Bye bye.
Bye bye." >test/expected_output_redirect.txt

cat test/output_redirect.txt | head -n 2  > test/output_redirect2.txt
diff -iwB test/output.txt test/expected_output.txt &>/dev/null
if [ $? -ne 0 ]
then
  echo "error (5)" >&2
  exit 1
fi
diff -iwB test/output_redirect2.txt test/expected_output_redirect.txt &>/dev/null
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error (6)" >&2
  exit 1
fi
#############################################################################
rm -f test/output_redirect2.txt