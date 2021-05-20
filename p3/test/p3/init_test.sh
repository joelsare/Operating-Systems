printf "testing myshell --init... "
shm_name="myshell_$(whoami)_shm"
rm -f /dev/shm/${shm_name}
bin/myshell --init >test/output.txt 2>test/error.txt
if [ $? -ne 0 ]
then
  echo "error (1)" >&2
  rm -f /dev/shm/${shm_name}
  exit 1
fi
check=$(ls /dev/shm/${shm_name} 2>/dev/null)
if [ "${check}" != "/dev/shm/${shm_name}" ]
then
  echo "error (2)" >&2
  rm -f /dev/shm/${shm_name}
  exit 1
fi
echo "ok"
rm -f /dev/shm/${shm_name}
