echo "testing project 3 functionality..."
./test/p3/all_test.sh
#############################################################################
echo 
echo "testing project 2 functionality..."
./test/p2/all_test.sh
#############################################################################
echo 
echo "testing project 1 functionality..."
#############################################################################
./test/p1/all_test.sh

rm -f test/error_receiver_1.txt  test/error_sender_1.txt  test/error_sender_3.txt  test/expected_output2.txt  test/output2.txt            test/output_receiver_2.txt  test/output_sender_1.txt  test/output_sender_3.txt
rm -f test/error_receiver_2.txt  test/error_sender_2.txt  test/error_sender_4.txt  test/expected_output3.txt  test/output_receiver_1.txt  test/output_redirect2.txt   test/output_sender_2.txt  test/output_sender_4.txt