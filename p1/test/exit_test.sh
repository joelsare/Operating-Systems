#!/bin/bash
printf "testing myshell --echo... "
printf "exit" | ./bin/myshell --echo >./test/output.txt 2>./test/error.txt
if [ $? -ne 0 ]
then
  echo "error" >&2
  exit 1
fi
printf "@> exit" > ./test/expected_output.txt
cat ./test/output.txt | sed 's/@>//' > ./test/output2.txt
cat ./test/expected_output.txt | sed 's/@>//' > ./test/expected_output2.txt
diff -iwB ./test/output2.txt ./test/expected_output2.txt &>/dev/null
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error" >&2
  exit 1
fi