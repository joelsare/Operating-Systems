printf "testing incr... "
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
echo "incr 1000000" | ./bin/myshell --echo >./test/output.txt 2>./test/error.txt
echo "@> incr 1000000
open shells: 1
increment counter (local): 1000000
increment counter address (local): XXXXXXX
increment counter (global): 1000000
increment counter address (global): XXXXXXX" >test/expected_output.txt
cat test/output.txt | grep -v "increment counter address" | sed 's/@>//' > test/output2.txt
cat test/expected_output.txt | grep -v "increment counter address" | sed 's/@>//' > test/expected_output2.txt
diff -iwB test/output2.txt test/expected_output2.txt &>/dev/null
if [ $? -ne 0 ]
then
  echo "error (3)" >&2
  rm -f /dev/shm/${shm_name}
  exit 1
fi
echo "incr 500
incr 30
incr 700" | ./bin/myshell --echo >./test/output.txt 2>./test/error.txt
echo "@> incr 500
open shells: 1
increment counter (local): 500
increment counter (global): 500
@> incr 30
open shells: 1
increment counter (local): 530
increment counter (global): 530
@> incr 700
open shells: 1
increment counter (local): 1230
increment counter (global): 1230" >test/expected_output.txt
cat test/output.txt | grep -v "increment counter address" | sed 's/@>//' > test/output2.txt
cat test/expected_output.txt | grep -v "increment counter address" | sed 's/@>//' > test/expected_output2.txt
diff -iwB test/output2.txt test/expected_output2.txt &>/dev/null
if [ $? -ne 0 ]
then
  echo "error (4)" >&2
  rm -f /dev/shm/${shm_name}
  exit 1
else
  echo "ok"
fi
rm -f /dev/shm/${shm_name}
rm -f test/output2.txt
