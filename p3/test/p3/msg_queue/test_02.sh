script_dir="$(dirname $(realpath $0))"
$script_dir/../send_receive_test/test_02.sh $script_dir/test_init.sh $script_dir/../send_receive_test/test_destroy.sh send receive
if [ $? -ne 0 ]
then
  exit 1
fi
$script_dir/../send_receive_test/test_02b.sh $script_dir/test_init.sh $script_dir/../send_receive_test/test_destroy.sh send receive