init_script=$1
destroy_script=$2
send=$3
receive=$4
#########################################################################
printf "testing ${send}-${receive}... "
$init_script
if [ $? -ne 0 ]
then
  $destroy_script
  exit 1
fi
echo "${send} Hello_World!
${receive}" | ./bin/myshell --echo >./test/output.txt 2>./test/error.txt
if [ $? -ne 0 ]
then
  echo "error (3)" >&2
  $destroy_script
  exit 1
fi
echo "@> ${send} Hello_World!
@> ${receive}
Hello_World!" >test/expected_output.txt
cat test/output.txt | sed 's/@>//' > test/output2.txt
cat test/expected_output.txt | sed 's/@>//' > test/expected_output2.txt
diff -iwB test/output2.txt test/expected_output2.txt &>/dev/null
if [ $? -ne 0 ]
then
  echo "error (4)" >&2
  $destroy_script
  exit 1
else
  echo "ok"
fi
$destroy_script
#########################################################################
printf "testing ${send}-recevie 3... "
$init_script
if [ $? -ne 0 ]
then
  echo "error (3)" >&2
  $destroy_script
  exit 1
fi
echo "${send} Hello_World!
${send} Hello_World_Again!
${send} Good_Bye!
${receive}
${receive}
${receive}" | ./bin/myshell --echo >./test/output.txt 2>./test/error.txt
if [ $? -ne 0 ]
then
  echo "error (7)" >&2
  $destroy_script
  exit 1
fi
echo "@> ${send} Hello_World!
@> ${send} Hello_World_Again!
@> ${send} Good_Bye!
@> ${receive}
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
  echo "error (8)" >&2
  $destroy_script
  exit 1
else
  echo "ok"
fi
$destroy_script
#########################################################################
printf "testing ${send}-recevie 10... "
$init_script
if [ $? -ne 0 ]
then
  echo "error (3)" >&2
  $destroy_script
  exit 1
fi
echo "${send} message1
${send} message2
${send} message3
${send} message4
${send} message5
${send} message6
${send} message7
${send} message8
${send} message9
${send} message10
${receive}
${receive}
${receive}
${receive}
${receive}
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
echo "@> ${send} message1
@> ${send} message2
@> ${send} message3
@> ${send} message4
@> ${send} message5
@> ${send} message6
@> ${send} message7
@> ${send} message8
@> ${send} message9
@> ${send} message10
@> ${receive}
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
message6
@> ${receive}
message7
@> ${receive}
message8
@> ${receive}
message9
@> ${receive}
message10" >test/expected_output.txt
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