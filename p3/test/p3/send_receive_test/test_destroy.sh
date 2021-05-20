shm_name="myshell_$(whoami)_shm"
rm -f /dev/shm/${shm_name}
mq_name="myshell_$(whoami)_mqueue"
rm -f /dev/mqueue/${mq_name}
