init_script=$1
destroy_script=$2
send=$3
receive=$4
#########################################################################
printf "testing ${send}-${receive} pri... "
$init_script
if [ $? -ne 0 ]
then
  echo "error (3)" >&2
  $destroy_script
  exit 1
fi
echo "${send} Hello_World_Again!
${send} Hello_World! 2
${send} Good_Bye!" | ./bin/myshell --echo >./test/output.txt 2>./test/error.txt
if [ $? -ne 0 ]
then
  echo "error (11a)" >&2
  $destroy_script
  exit 1
fi
echo "${receive}
${receive}
${receive}" | ./bin/myshell --echo >./test/output.txt 2>./test/error.txt
if [ $? -ne 0 ]
then
  echo "error (11b)" >&2
  $destroy_script
  exit 1
fi
echo "@> ${receive}
Hello_World!
@> ${receive}
Hello_World_Again!
@> ${receive}
Good_Bye!" >test/expected_output.txt
cat test/output.txt | sed 's/@>//' > test/output2.txt
cat test/expected_output.txt | sed 's/@>//' > test/expected_output2.txt
diff -iwB test/output2.txt test/expected_output2.txt &>/dev/null
if [ $? -ne 0 ]
then
  echo "error (12)" >&2
  $destroy_script
#   exit 1
else
  echo "ok"
fi
$destroy_script
#########################################################################
rm -f test/output2.txt