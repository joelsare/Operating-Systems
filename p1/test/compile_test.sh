#!/bin/bash
printf "extracting p1.tar.gz... "
tar -xzvf p1.tar.gz >/dev/null 2>&1
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error" >&2
  exit 1
fi
printf "compiling myshell... "
make >/dev/null 2>&1
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error" >&2
  exit 1
fi
printf "testing myshell... "
echo "" | ./bin/myshell >/dev/null 2>&1
if [ $? -eq 0 ]
then
  echo "ok"
else
  echo "error" >&2
  exit 1
fi