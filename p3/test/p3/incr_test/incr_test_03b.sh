command=$(printf 'incr 1000000\ncdir\n%.0s' {1..10})
printf "$command" | ./bin/myshell --echo >./test/output_02.txt 2>./test/error_02.txt &
child_pid_01=$!
printf "$command" | ./bin/myshell --echo >./test/output_03.txt 2>./test/error_03.txt &
child_pid_02=$!
wait $child_pid_01 2>/dev/null
wait $child_pid_02 2>/dev/null