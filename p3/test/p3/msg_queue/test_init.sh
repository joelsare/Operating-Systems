shm_name="myshell_$(whoami)_shm"
rm -f /dev/shm/${shm_name}
mq_name="myshell_$(whoami)_mqueue"
rm -f /dev/mqueue/${mq_name}
bin/myshell --init >test/output.txt 2>test/error.txt
if [ $? -ne 0 ]
then
  echo "error (1)" >&2
  rm -f /dev/shm/${shm_name}
  rm -f /dev/mqueue/myshell_mqueue
  exit 1
fi
check=$(ls /dev/mqueue/${mq_name} 2>/dev/null)
if [ "${check}" != "/dev/mqueue/${mq_name}" ]
then
  echo "error (2)" >&2
  rm -f /dev/shm/${shm_name}
  rm -f /dev/mqueue/${mq_name}
  exit 1
fi