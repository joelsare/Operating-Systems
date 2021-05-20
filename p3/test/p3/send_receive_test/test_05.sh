init_script=$1
destroy_script=$2
send=$3
receive=$4
#########################################################################
printf "testing ${send}-${receive} several senders and receivers... "
$init_script
if [ $? -ne 0 ]
then
  echo "error (3)" >&2
  $destroy_script
  exit 1
fi

sender() {
  sender_id=$1
  command=""
  for message_id in {001..100}
  do
    command="${command}${send} message_${sender_id}_${message_id}\n"
  done
  printf "${command}" | ./bin/myshell --echo >./test/output_sender_${sender_id}.txt 2>./test/error_sender_${sender_id}.txt
  if [ $? -ne 0 ]
  then
    echo "error (15_${sender_id})" >&2
    exit 1
  fi
}

receiver() {
  receiver_id=$1
  command=""
  for message_id in {1..200}
  do
    command="${command}${receive}\n"
  done
  printf "${command}" | ./bin/myshell --echo >./test/output_receiver_${receiver_id}.txt 2>./test/error_receiver_${receiver_id}.txt
  if [ $? -ne 0 ]
  then
    echo "error (15_${receiver_id})" >&2
    exit 1
  fi
}

sender 1&
sender1=$!
sender 2&
sender2=$!
sender 3&
sender3=$!
sender 4&
sender4=$!
sleep 1
receiver 1&
receiver1=$!
receiver 2&
receiver2=$!

printf "" > test/expected_output.txt

for sender_id in {1..4}
do
  for message_id in {001..100}
  do
    echo "message_${sender_id}_${message_id}">> test/expected_output.txt
  done
done

wait ${receiver1}
wait ${receiver2}

cat ./test/output_receiver_1.txt ./test/output_receiver_2.txt | grep -v "@>" | sort > ./test/output.txt
diff -iwB test/output.txt test/expected_output.txt &>/dev/null
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