#!/bin/bash
#############################################################################
printf "testing cdir... "
echo "cdir" | ./bin/myshell --echo >./test/output.txt 2>./test/error.txt
if [ $? -ne 0 ]
then
  echo "error" >&2
  exit 1
fi
printf "@> cdir
$(pwd)
@>" > ./test/expected_output.txt
cat ./test/output.txt | sed 's/@>//' > ./test/output2.txt
cat ./test/expected_output.txt | sed 's/@>//' > ./test/expected_output2.txt
diff -iwB ./test/output2.txt ./test/expected_output2.txt &>/dev/null
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error (1)" >&2
  exit 1
fi
#############################################################################
printf "testing cdir bin... "
echo "cdir bin
cdir
cdir ..
cdir" | ./bin/myshell --echo >./test/output.txt 2>./test/error.txt
if [ $? -ne 0 ]
then
  echo "error (2)" >&2
  exit 1
fi
printf "@> cdir bin
@> cdir
$(pwd)/bin
@> cdir ..
@> cdir
$(pwd)
@> " > ./test/expected_output.txt
cat ./test/output.txt | sed 's/@>//' > ./test/output2.txt
cat ./test/expected_output.txt | sed 's/@>//' > ./test/expected_output2.txt
diff -iwB ./test/output2.txt ./test/expected_output2.txt &>/dev/null
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error (3)" >&2
  exit 1
fi
#############################################################################
printf "testing cdir nonexistent... "
echo "cdir nonexistent" | ./bin/myshell --echo >./test/output.txt 2>./test/error.txt
if [ $? -ne 0 ]
then
  echo "error (4)" >&2
  exit 1
fi
printf "cdir: No such file or directory" > ./test/expected_error.txt
diff -iwB ./test/error.txt ./test/expected_error.txt &>/dev/null
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error (5)" >&2
  exit 1
fi
#############################################################################
printf "testing cdir file... "
echo "cdir Makefile" | ./bin/myshell --echo >./test/output.txt 2>./test/error.txt
if [ $? -ne 0 ]
then
  echo "error (6)" >&2
  exit 1
fi
printf "cdir: Not a directory" > ./test/expected_error.txt
diff -iwB ./test/error.txt ./test/expected_error.txt &>/dev/null
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error (7)" >&2
  exit 1
fi
rm -f ./test/output2.txt ./test/expected_output2.txt