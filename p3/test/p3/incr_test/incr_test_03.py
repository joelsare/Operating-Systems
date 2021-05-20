#bin/python
import subprocess, pty, os, time
from subprocess import Popen, PIPE, DEVNULL
from pathlib import Path

script_dir = Path(__file__).parent

s1 = ""
waiting_time = 0.01



pid_1,fd_1 = pty.fork()
if pid_1 == 0:
    subprocess.run('bin/myshell')
    exit(0)

s1 += os.read(fd_1, 10000).decode('utf-8')

subprocess.run(['bash', str(script_dir) + '/incr_test_03b.sh'])

os.write(fd_1, b"incr 1\n")
time.sleep(waiting_time)
s1 += os.read(fd_1, 10000).decode('utf-8')
os.write(fd_1, b"exit\n")

f1 = open("test/output_01.txt", "w")
e1 = open("test/expected_output_01.txt", "w")

f1.write(s1)
e1.write("""@> incr 1
open shells: 1
increment counter (local): 1
increment counter (global): 20000001""")