script_dir="$(dirname $(realpath $0))"
#########################################################################
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
python3 $script_dir/incr_test_02.py

cat test/output_01.txt | grep -v "increment counter address" | sed 's/@>//g' | sed '/^$/d' > test/output_01b.txt
cat test/expected_output_01.txt | grep -v "increment counter address" | sed 's/@>//g' | sed '/^$/d' > test/expected_output_01b.txt
diff -iwB test/output_01b.txt test/expected_output_01b.txt &>/dev/null
if [ $? -ne 0 ]
then
  echo "error (3)" >&2
  rm -f /dev/shm/${shm_name}
  exit 1
fi
cat test/output_02.txt | grep -v "increment counter address" | sed 's/@>//g' | sed '/^$/d' > test/output_02b.txt
cat test/expected_output_02.txt | grep -v "increment counter address" | sed 's/@>//g' | sed '/^$/d' > test/expected_output_02b.txt
diff -iwB test/output_02b.txt test/expected_output_02b.txt &>/dev/null
if [ $? -ne 0 ]
then
  echo "error (4)" >&2
  rm -f /dev/shm/${shm_name}
  exit 1
fi
cat test/output_03.txt | grep -v "increment counter address" | sed 's/@>//g' | sed '/^$/d' > test/output_03b.txt
cat test/expected_output_03.txt | grep -v "increment counter address" | sed 's/@>//g' | sed '/^$/d' > test/expected_output_03b.txt
diff -iwB test/output_03b.txt test/expected_output_03b.txt &>/dev/null
if [ $? -ne 0 ]
then
  echo "error (5)" >&2
  rm -f /dev/shm/${shm_name}
  exit 1
fi
echo ok
# rm -f /dev/shm/${shm_name} test/output_01b.txt test/output_01b.txt test/output_02b.txt test/output_02b.txt test/output_03b.txt test/output_03b.txt