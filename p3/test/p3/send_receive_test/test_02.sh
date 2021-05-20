init_script=$1
destroy_script=$2
send=$3
receive=$4
#########################################################################
printf "testing ${send}-recevie... "
$init_script
if [ $? -ne 0 ]
then
  echo "error (3)" >&2
  $destroy_script
  exit 1
fi
echo "${send} Hello_World!" | ./bin/myshell --echo >./test/output.txt 2>./test/error.txt
if [ $? -ne 0 ]
then
  echo "error (3a)" >&2
  $destroy_script
  exit 1
fi
echo "${receive}" | ./bin/myshell --echo >./test/output.txt 2>>./test/error.txt
if [ $? -ne 0 ]
then
  echo "error (3b)" >&2
  $destroy_script
  exit 1
fi
echo "@> ${receive}
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
${send} Good_Bye!" | ./bin/myshell --echo >./test/output.txt 2>./test/error.txt
if [ $? -ne 0 ]
then
  echo "error (7a)" >&2
  $destroy_script
  exit 1
fi
echo "${receive}
${receive}
${receive}" | ./bin/myshell --echo >./test/output.txt 2>>./test/error.txt
if [ $? -ne 0 ]
then
  echo "error (7b)" >&2
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
  echo "error (8)" >&2
  $destroy_script
#   exit 1
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
${send} message10" | ./bin/myshell --echo >./test/output.txt 2>./test/error.txt
if [ $? -ne 0 ]
then
  echo "error (15a)" >&2
  $destroy_script
  exit 1
fi
echo "${receive}
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
  echo "error (15b)" >&2
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
#   exit 1
else
  echo "ok"
fi
$destroy_script
#########################################################################
# printf "testing ${send}-recevie 15... "
# $init_script
# if [ $? -ne 0 ]
# then
#   echo "error (3)" >&2
#   $destroy_script
#   exit 1
# fi
# echo "${send} message1
# ${send} message2
# ${send} message3
# ${send} message4
# ${send} message5
# ${send} message6
# ${send} message7
# ${send} message8
# ${send} message9
# ${send} message10
# ${send} message11
# ${send} message12
# ${send} message13
# ${send} message14
# ${send} message15" | ./bin/myshell --echo >./test/output2.txt 2>./test/error2.txt&
# if [ $? -ne 0 ]
# then
#   echo "error (19a)" >&2
#   $destroy_script
#   exit 1
# fi
# sleep 1s
# echo "${receive}
# ${receive}" | ./bin/myshell --echo >./test/output.txt 2>./test/error.txt
# if [ $? -ne 0 ]
# then
#   echo "error (19b)" >&2
#   $destroy_script
#   exit 1
# fi
# echo "@> ${receive}
# message1
# message2
# message3
# message4
# message5
# message6
# message7
# message8
# message9
# message10
# @> ${receive}
# message11
# message12
# message13
# message14
# message15" >test/expected_output.txt
# cat test/output.txt | sed 's/@>//' > test/output2.txt
# cat test/expected_output.txt | sed 's/@>//' > test/expected_output2.txt
# diff -iwB test/output2.txt test/expected_output2.txt &>/dev/null
# if [ $? -ne 0 ]
# then
#   echo "error (20)" >&2
#   $destroy_script
#   exit 1
# else
#   echo "ok"
# fi
# $destroy_script
#########################################################################
rm -f test/output2.txt