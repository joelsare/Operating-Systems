init_script=$1
destroy_script=$2
send=$3
receive=$4
#########################################################################
printf "testing ${send}-${receive} two senders... "
$init_script
if [ $? -ne 0 ]
then
  echo "error (3)" >&2
  $destroy_script
  exit 1
fi
echo "${send} message1
${send} message2
${send} message3" | ./bin/myshell --echo >./test/output.txt 2>./test/error.txt
if [ $? -ne 0 ]
then
  echo "error (15)" >&2
  $destroy_script
  exit 1
fi
echo "${send} message4
${send} message5
${send} message6" | ./bin/myshell --echo >./test/output.txt 2>./test/error.txt
if [ $? -ne 0 ]
then
  echo "error (15)" >&2
  $destroy_script
  exit 1
fi
echo "${receive}
${receive}
${receive}
${receive}
${receive}
${receive}" | ./bin/myshell --echo >./test/output.txt 2>./test/error.txt
if [ $? -ne 0 ]
then
  echo "error (15)" >&2
  $destroy_script
  exit 1
fi
echo "@> ${receive}
message1
@> ${receive}
message2
@> ${receive}
message3
@> ${receive}
message4
@> ${receive}
message5
@> ${receive}
message6" >test/expected_output.txt
cat test/output.txt | sed 's/@>//' > test/output2.txt
cat test/expected_output.txt | sed 's/@>//' > test/expected_output2.txt
diff -iwB test/output2.txt test/expected_output2.txt &>/dev/null
if [ $? -ne 0 ]
then
  echo "error (16)" >&2
  $destroy_script
  exit 1
else
  echo "ok"
fi
$destroy_script
#########################################################################
rm -f test/output2.txt
rm -f test/expected_output2.txt