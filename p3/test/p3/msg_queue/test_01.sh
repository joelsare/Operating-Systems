script_dir="$(dirname $(realpath $0))"
$script_dir/../send_receive_test/test_01.sh $script_dir/test_init.sh $script_dir/../send_receive_test/test_destroy.sh send receive
if [ $? -ne 0 ]
then
  exit 1
fi
$destroy_script
$script_dir/../send_receive_test/test_01b.sh $script_dir/test_init.sh $script_dir/../send_receive_test/test_destroy.sh send receive